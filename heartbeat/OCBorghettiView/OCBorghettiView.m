#import "OCBorghettiView.h"

@interface OCBorghettiView ()
@property (strong) NSMutableArray *views;
@property (strong) NSMutableArray *sections;
@property (assign) NSInteger accordionSectionActive;
@property (assign) NSInteger numberOfSections;
@property (assign) BOOL shouldAnimate;
@property (assign) BOOL hasBorder;
@end

@implementation OCBorghettiView

@synthesize accordionSectionBorderColor = _accordionSectionBorderColor;

#pragma mark - Public

#pragma mark View lifecycle

- (id)init
{
    @throw [NSException exceptionWithName:@"BadInitCall"
                                   reason:@"Initialize with initWithFrame: selector instead."
                                 userInfo:nil];
    
    return nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
        [self initBorghetti];
    
    return self;
}

#pragma mark Add Section and View

- (void)addSectionWithTitle:(NSString *)sectionTitle
                    andView:(id)sectionView
{
    UIButton *section = [[UIButton alloc] init];
    
    [section setBackgroundColor:self.accordionSectionColor];
    [section setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [section setAutoresizesSubviews:YES];
    [section setAdjustsImageWhenHighlighted:NO];
    [section setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [section setTitle:sectionTitle forState:UIControlStateNormal];
    [section.titleLabel setFont:self.accordionSectionFont];
    [section setTitleColor:self.accordionSectionTitleColor
                  forState:UIControlStateNormal];
    
    [sectionView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [sectionView setAutoresizesSubviews:YES];
    
    [self.sections addObject:section];
    [self.views addObject:sectionView];
    
    [self addSubview:section];
    [self addSubview:sectionView];
    
    [section setTag:self.sections.count - 1];
    [section addTarget:self
                action:@selector(sectionTouched:)
      forControlEvents:UIControlEventTouchUpInside];
    
    self.accordionSectionActive = 0;
}

#pragma mark Setter

- (void)setAccordionSectionBorderColor:(UIColor *)accordionSectionBorderColor
{
    _accordionSectionBorderColor = accordionSectionBorderColor;
    self.hasBorder = YES;
}

#pragma mark - Private

- (void)initBorghetti
{
    self.views = [NSMutableArray new];
    self.sections = [NSMutableArray new];
    
    self.accordionSectionHeight = 30;
    self.accordionSectionColor = [UIColor blackColor];
    self.accordionSectionFont = [UIFont fontWithName:@"Arial-BoldMT" size:16];
    self.accordionSectionTitleColor = [UIColor whiteColor];
    self.accordionSectionBorderColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
    self.hasBorder = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    self.autoresizesSubviews = YES;
    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    self.shouldAnimate = NO;
}

- (void)sectionTouched:(id)sender
{
    self.accordionSectionActive = [sender tag];
    [self setNeedsLayout];
    
    if ([self.delegate respondsToSelector:@selector(accordion:didSelectSection:withTitle:)]) {
        [self.delegate accordion:self
                didSelectSection:self.views[[sender tag]]
                       withTitle:[[self.sections[[sender tag]] titleLabel] text]];
    }
}

- (void)didAddSubview:(UIView *)subview
{
    if (![subview isKindOfClass:[UIButton class]])
        self.numberOfSections += 1;
}

- (void)layoutSubviews
{
    int height = 0;
    
    for (int i = 0; i < self.views.count; i++) {
        UIButton *sectionTitle = self.sections[i];
        id sectionView = self.views[i];
        
        CGRect sectionTitleFrame = [sectionTitle frame];
        sectionTitleFrame.origin.x = 0;
        sectionTitleFrame.size.width = self.frame.size.width;
        sectionTitleFrame.size.height = self.accordionSectionHeight;
        [sectionTitle setFrame:sectionTitleFrame];
        
        [sectionTitle setTitleEdgeInsets:UIEdgeInsetsMake(0.0f, -5.0f, 0.0f, 0.0f)];
        [sectionTitle setImageEdgeInsets:UIEdgeInsetsMake(0.0f, self.frame.size.width - 25.0f , 0.0f, 0.0f)];
        
        CGRect sectionViewFrame = [sectionView frame];
        sectionViewFrame.origin.x = 0;
        sectionViewFrame.size.width = self.frame.size.width;
        sectionViewFrame.size.height = (self.frame.size.height - (self.numberOfSections * self.accordionSectionHeight));
        [sectionView setFrame:sectionViewFrame];
        
        sectionTitleFrame.origin.y = height;
        height += sectionTitleFrame.size.height;
        sectionViewFrame.origin.y = height;
        
        if (self.accordionSectionActive == i) {
            [sectionTitle setImage:[UIImage imageNamed:@"OCBorghettiView.bundle/icon_down_arrow.png"]
                          forState:UIControlStateNormal];
            
            sectionViewFrame.size.height = (self.frame.size.height - (self.numberOfSections * self.accordionSectionHeight));
            [sectionView setFrame:CGRectMake(0, sectionViewFrame.origin.y, self.frame.size.width, 0)];
            
            if ([sectionView respondsToSelector:@selector(setScrollsToTop:)])
                [sectionView setScrollsToTop:YES];
        } else {
            [sectionTitle setImage:[UIImage imageNamed:@"OCBorghettiView.bundle/icon_right_arrow.png"]
                          forState:UIControlStateNormal];
            
            sectionViewFrame.size.height = 0;
            
            if ([sectionView respondsToSelector:@selector(setScrollsToTop:)])
                [sectionView setScrollsToTop:NO];
        }
        
        [self processBorder:sectionTitle atIndex:i];
        
        height += sectionViewFrame.size.height;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:self.shouldAnimate ? 0.1f : 0.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [UIView setAnimationBeginsFromCurrentState:YES];
        [sectionTitle setFrame:sectionTitleFrame];
        [sectionView setFrame:sectionViewFrame];
        [UIView commitAnimations];
    }
    
    self.shouldAnimate = YES;
}

- (void)processBorder:(UIButton *)sectionTitle
              atIndex:(NSInteger)index
{
    if (self.hasBorder) {
        if (index > 0) {
            UIView *topBorder = [[UIView alloc] init];
            topBorder.frame = CGRectMake(0.0f, 0.0f, sectionTitle.frame.size.width, 1.5f);
            topBorder.backgroundColor = self.accordionSectionBorderColor;
            topBorder.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            if (sectionTitle.subviews.count < 3) [sectionTitle addSubview:topBorder];
        }
    }
}

@end
