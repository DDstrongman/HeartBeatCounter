//
//  HiProgressView.h
//  LevelTest
//
//  Created by WangZeKeJi on 14-8-5.
//  Copyright (c) 2014年 ___ChengPeng___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HiProgressView : UIView
- (id)initWithFrame:(CGRect)frame withProgress:(float)progress;

//- (id)initWithFrame:(CGRect)frame withProgress:(float)progress withDistanceProgress:(float)distanceProgress;

@property(nonatomic,strong)UIImageView *progressView;//进度填充部分显示的图像
@property(nonatomic,strong)UIImageView *trackView;//进度未填充部分显示的图像
@property (nonatomic, retain) AppDelegate* myAppDelegate;

@end
