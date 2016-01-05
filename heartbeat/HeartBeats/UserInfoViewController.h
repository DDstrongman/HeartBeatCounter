//
//  UserInfoViewController.h
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "RETableViewOptionsController.h"
#import "HeartBeatsInfo.h"
#import "User.h"
#import "AppDelegate.h"

@interface UserInfoViewController : UITableViewController <RETableViewManagerDelegate>

@property (strong, readonly, nonatomic) RETableViewManager *manager;
@property (strong, readwrite, nonatomic) RETableViewSection *userInfoSection;
@property (strong, readwrite, nonatomic) RETableViewSection *creditCardSection;
@property (strong, readwrite, nonatomic) RETableViewSection *accessoriesSection;
@property (strong, readwrite, nonatomic) RETableViewSection *cutCopyPasteSection;
@property (strong, readwrite, nonatomic) RETableViewSection *buttonSection;

@property (nonatomic, retain) AppDelegate* myAppDelegate;

@end
