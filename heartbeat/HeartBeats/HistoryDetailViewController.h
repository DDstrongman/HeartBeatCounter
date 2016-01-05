//
//  HistoryDetailViewController.h
//  HeartBeats
//
//  Created by jt3 on 15/3/16.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RETableViewManager.h"
#import "AppDelegate.h"
#import "HeartBeatsInfo.h"

@interface HistoryDetailViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, readonly, nonatomic) RETableViewManager *manager;

@property (nonatomic, retain) AppDelegate* myAppDelegate;

@property (strong, readwrite, nonatomic) RETableViewItem *currentItem;
@property (copy, readwrite, nonatomic) void (^deleteConfirmationHandler)(void);

@end
