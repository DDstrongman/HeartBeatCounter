//
//  RootViewController.h
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "HeartBeatsInfo.h"
#import "User.h"
#import "HiProgressView.h"
//分享
#import "APLCustomURLContainer.h"
//Admob
#import <GoogleMobileAds/GADBannerView.h>

@class GADBannerView;

@interface RootViewController : UIViewController

@property (nonatomic, retain) AppDelegate* myAppDelegate;
@property (nonatomic, strong) IBOutlet UILabel *rootHeartRateLabel;
@property (nonatomic, strong) IBOutlet UILabel *remindLabel;
@property (nonatomic, strong) IBOutlet UIButton *startNewButton;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UIButton *gotoButton;

@property(nonatomic, strong) IBOutlet GADBannerView *adBanner;
@end
