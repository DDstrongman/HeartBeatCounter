//
//  SettingInfoViewController.h
//  HeartBeats
//
//  Created by 李胜书 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OCBorghettiView.h"
#import "RETableViewManager.h"
#import "User.h"
#import "HeartBeatsInfo.h"
#import "AppDelegate.h"


@interface SettingInfoViewController : UIViewController<OCBorghettiViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, retain) AppDelegate* myAppDelegate;

@end
