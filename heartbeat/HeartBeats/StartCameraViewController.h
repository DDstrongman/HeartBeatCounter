//
//  StartCameraViewController.h
//  HeartBeats
//
//  Created by jt3 on 15/3/12.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"

@interface StartCameraViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, retain) AppDelegate* myAppDelegate;

@property (weak,nonatomic)IBOutlet UILabel *titleLabel;

@property (weak,nonatomic)IBOutlet UILabel *remindBeatLabel;
@property (weak,nonatomic)IBOutlet UILabel *startTimeLabel;
@property (weak,nonatomic)IBOutlet UILabel *showTimeLabel;
@property (weak,nonatomic)IBOutlet UIButton *backButton;


@end
