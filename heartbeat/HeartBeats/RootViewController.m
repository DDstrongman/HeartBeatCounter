//
//  RootViewController.m
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

{
    NSMutableArray *plottingDataValues1Temp;
    NSString  *rootHeartRate;
    BOOL FirstRoot;
    NSNumber *rootTime;
    NSString *userName;
    NSDate *userAge;
    NSString *userSex;
    HiProgressView *progressView;
}

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*********** 设置广告 start ************/
    
    // Initialize the banner at the bottom of the screen.
    //CGPoint origin = CGPointMake(0.0,[UIScreen mainScreen].bounds.size.height - 50);
    
    // Use predefined GADAdSize constants to define the GADBannerView.
    self.adBanner = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    
    //=======设置 banner 的位置，下面设置为底部中心 =======//
   self.adBanner.center = CGPointMake(self.view.bounds.size.width/2.0, [UIScreen mainScreen].bounds.size.height -25-100);
    
    // Replace this ad unit ID with your own ad unit ID.
    self.adBanner.adUnitID = kSampleAdUnitID;
    self.adBanner.rootViewController = self;
    
    GADRequest *request = [GADRequest request];
    // Requests test ads on devices you specify. Your test device ID is printed to the console when
    // an ad request is made. GADBannerView automatically returns test ads when running on a
    // simulator.
    request.testDevices = @[
                            @"c63d39f579f1c3602980b4972d605383d2e79408"  // Carlos's iPod Touch
                            ];
    [self.adBanner loadRequest:request];
    
    
    [self.view addSubview:self.adBanner];
    
    
    /*********** 设置广告 end ************/
    
    
    _myAppDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    plottingDataValues1Temp=[[NSMutableArray alloc]init];
    //创建分享按钮
    
    _remindLabel.text=NSLocalizedString(@"remindLabelContent", @"");
    [_startNewButton setTitle:NSLocalizedString(@"startNewButtonContent", @"") forState:UIControlStateNormal];
    [_shareButton setTitle:NSLocalizedString(@"shareButtonContent", @"") forState:UIControlStateNormal];
    [_gotoButton setTitle:NSLocalizedString(@"Go to Advice", @"") forState:UIControlStateNormal];
//    _gotoButton.center=CGPointMake(ViewWidth/2.0, ViewHeight-25-30);
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIImage *image_share = [UIImage imageNamed:@"share.png"];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image_share style:UIBarButtonItemStylePlain target:self action:@selector(shareAction)];
    self.navigationItem.title=NSLocalizedString(@"rootTitle", @"");
    UIImage *image_Goto = [UIImage imageNamed:@"menuIcon@2x.png"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image_Goto style:UIBarButtonItemStylePlain target:self action:@selector(goTo)];
    
    [self searchData];
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    if([plottingDataValues1Temp count]>0&&_myAppDelegate.SucessOrNot==YES)
    {
        rootHeartRate=[numberFormatter stringFromNumber:[plottingDataValues1Temp objectAtIndex:[plottingDataValues1Temp count]-1]];
        _rootHeartRateLabel.text=rootHeartRate;
    }
    else if(_myAppDelegate.SucessOrNot==NO)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"cancelWarn", @"") message:[NSString stringWithFormat:@""] delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        [NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(performDismiss:) userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert, @"alert", @"testing ", @"key" ,nil] repeats:NO];
        [alert show];
        _rootHeartRateLabel.text=@"--";
    }
    else
    {
        _rootHeartRateLabel.text=@"--";
    }
    
    //创建进度条
    if([_rootHeartRateLabel.text isEqualToString:@"--"])
    {
        progressView = [[HiProgressView alloc]initWithFrame:CGRectMake((ViewWidth-263)/2, 100, 263, 12) withProgress:0];
    }
    else
    {
        if([_rootHeartRateLabel.text intValue]>39&&[_rootHeartRateLabel.text intValue]<121)
        {
            _myAppDelegate.ProgressGreenOrNot=0;
        }
        else if([_rootHeartRateLabel.text intValue]<40)
        {
            _myAppDelegate.ProgressGreenOrNot=1;
        }
        else
        {
            _myAppDelegate.ProgressGreenOrNot=2;
        }
        float progressMeasureTemp=[_rootHeartRateLabel.text intValue];
        float progressMeasure=progressMeasureTemp/160.0;

        NSLog(@"number====%f",progressMeasure);
        progressView = [[HiProgressView alloc]initWithFrame:CGRectMake((ViewWidth-263)/2, 80, 263, 12) withProgress:progressMeasure];//传入参数范围0~1
    }
    [self.view addSubview:progressView];
    if(rootTime==nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"stateTitle", @"") message:NSLocalizedString(@"stateContent", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"acceptButtonTitle", @"") otherButtonTitles:nil, nil];
        [alert show];
        [self SetRootTimeNotNull];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)searchData
{
    NSFetchRequest* request=[[NSFetchRequest alloc] init];
    NSEntityDescription* heartBeats=[NSEntityDescription entityForName:@"HeartBeatsInfo" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request setEntity:heartBeats];
    NSPredicate* predicate=[NSPredicate predicateWithFormat:@"beats<300"];
    [request setPredicate:predicate];
    NSError* error=nil;
    NSMutableArray* mutableFetchResult=[[_myAppDelegate.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResult==nil) {
    }
    for (HeartBeatsInfo* heartBeats in mutableFetchResult)
    {
        [plottingDataValues1Temp addObject:heartBeats.beats];
    }
    NSFetchRequest* request1=[[NSFetchRequest alloc] init];
    NSEntityDescription* roottime=[NSEntityDescription entityForName:@"User" inManagedObjectContext:_myAppDelegate.managedObjectContext];
    [request1 setEntity:roottime];
    NSError* error1=nil;
    NSMutableArray* mutableFetchResult1=[[_myAppDelegate.managedObjectContext executeFetchRequest:request1 error:&error1] mutableCopy];
    if (mutableFetchResult1==nil)
    {
        
    }
    for (User* user in mutableFetchResult1)
    {
        rootTime=user.roottime;
        userName=user.name;
        userAge=user.birthday;
        userSex=user.sex;
    }
}

-(void)SetRootTimeNotNull
{
    User* user=(User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.myAppDelegate.managedObjectContext];
    [user setRoottime:[NSNumber numberWithInt:1]];
    NSError* error;
    BOOL isSaveSuccess=[_myAppDelegate.managedObjectContext save:&error];
    if (!isSaveSuccess) {
        NSLog(@"Error:%@",error);
    }else{
        NSLog(@"Save successful!");
    }
}

-(void)performDismiss:(NSTimer*)timer

{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    [timer invalidate];
    timer = nil;
    _myAppDelegate.SucessOrNot=YES;
}

-(IBAction)StartCamera:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"StartView"];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)goTo
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"SettingView"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareAction
{
    NSLog(@"btnAction");
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/phone-master/id%@?l=zh&ls=1&mt=8",kAppId]];
    //  获取截图
    UIImage *image = [self GetNewimage];
    NSArray *array = [[NSArray alloc]initWithObjects:image,NSLocalizedString(@"shareContent", @""),url, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
    
}

-(IBAction)shareButton:(id)sender
{
    NSLog(@"shareButton");
    
    NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/phone-master/id%@?l=zh&ls=1&mt=8",kAppId]];
    //  获取截图
    UIImage *image = [self GetNewimage];
    NSArray *array = [[NSArray alloc]initWithObjects:image,NSLocalizedString(@"I found a good App", @""),url, nil];
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
    
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (UIImage *)GetNewimage
{
    //  图片 尺寸 300 300
    // 下面是 缩放比例
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    }
    else
    {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow * window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            CGContextConcatCTM(context, [window transform]);
            CGContextTranslateCTM(context, -[window bounds].size.width*[[window layer] anchorPoint].x, -[window bounds].size.height*[[window layer] anchorPoint].y);
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

-(IBAction)gotoAdvice:(id)sender
{
    if(userSex!=nil&&userName!=nil&&userAge!=nil)
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"AdviceView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"SettingView"];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(IBAction)gotoHistory:(id)sender
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"HistoryDetailView"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
