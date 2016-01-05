//
//  HiProgressView.m
//  LevelTest
//
//  Created by WangZeKeJi on 14-8-5.
//  Copyright (c) 2014年 ___ChengPeng___. All rights reserved.
//
#define H_HEIGHT 70


#import "HiProgressView.h"

@implementation HiProgressView

- (id)initWithFrame:(CGRect)frame withProgress:(float)progress
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGSize size = self.frame.size;
        _trackView = [[UIImageView alloc] initWithFrame:CGRectMake(0, H_HEIGHT-20, size.width, size.height)];
        _trackView.image = [UIImage imageNamed:@"1.png"];//进度未填充部分显示的图像
        
        [self addSubview:_trackView];
        
        UIView *progressViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height+H_HEIGHT)];
        progressViewBg.alpha = 0.85f;
        progressViewBg.clipsToBounds = YES;//当前view的主要作用是将出界了的_progressView剪切掉，所以需将clipsToBounds设置为YES
        [self addSubview:progressViewBg];
        _progressView = [[UIImageView alloc] init];
        
        _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
        if(_myAppDelegate.ProgressGreenOrNot==0)
        {
            _progressView.image = [UIImage imageNamed:@"2.png"];//进度填充部分显示的图像 绿色
        }
        else
        {
            _progressView.image = [UIImage imageNamed:@"3.png"];//进度填充部分显示的图像 改为红色
        }
//        for (int i = 0; i<5; i++) {
//            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+i*60, 2, 19, 23)];
//            imageView.image  = [UIImage imageNamed:[NSString stringWithFormat:@"t%d.png",i]];
//            [progressViewBg addSubview:imageView];
//        }
        UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 263, 23)];
        typeLabel.text = NSLocalizedString(@"progressText", @"");
        typeLabel.font = [UIFont systemFontOfSize:12];
        [progressViewBg addSubview:typeLabel];
        

        UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 61, 320, 23)];
        msgLabel.font = [UIFont systemFontOfSize:12];
        
        if(_myAppDelegate.ProgressGreenOrNot==-1)
        {
            msgLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"rootProgressLabel", @""),NSLocalizedString(@"rootProgressLabelNone", @"")];
        }
        else if(_myAppDelegate.ProgressGreenOrNot==0)
        {
        msgLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"rootProgressLabel", @""),NSLocalizedString(@"rootProgressLabelNormal", @"")];
        }
        else if(_myAppDelegate.ProgressGreenOrNot==1)
        {
            msgLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"rootProgressLabel", @""),NSLocalizedString(@"rootProgressLabelIllSlow", @"")];
        }
        else
        {
            msgLabel.text = [NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"rootProgressLabel", @""),NSLocalizedString(@"rootProgressLabelIllQuick", @"")];
        }
        
        [progressViewBg addSubview:msgLabel];
        
        [self setProgress:progress];//设置进度
        [progressViewBg addSubview:_progressView];
    }
    return self;
}
-(void)setProgress:(float)fProgress

{
    
    float progress;
    progress = fProgress;
    
    CGSize size = self.frame.size;
    
    _progressView.frame = CGRectMake(size.width * progress-size.width, H_HEIGHT-20, size.width, size.height);//image的宽和高不变，将x轴的坐标根据progress的大小左右移动即可显示出进度的大小，progress的值介于0.0至1.0之间。因为_progressView的父级view上clipsToBounds属性为YES，所以当_progressView的frame出界后不会被显示出来。
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
