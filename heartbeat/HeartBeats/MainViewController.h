//
//  MainViewController.h
//  HeartBeats
//
//  Created by Christian Roman on 30/08/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "HeartBeatsInfo.h"
#import "HeartLive.h"
#import <POP.h>

@interface MainViewController : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate>

{
    POPSpringAnimation *scaleAnimation;
    NSTimer *timer;
    NSTimer *delayTimer;
}

@property (nonatomic, retain) AppDelegate* myAppDelegate;

@property (weak,nonatomic) IBOutlet UIButton              *cancelButton;
@property (strong,nonatomic ) IBOutlet UIView             *translationMoniterBackGroundView;
//@property (strong,nonatomic ) IBOutlet HeartLive             *translationMoniterView;
@property (nonatomic , strong) HeartLive *translationMoniterView;
@property (weak,nonatomic ) IBOutlet UIButton              *resultButton;
@property (weak,nonatomic ) IBOutlet UIView                *resultView;
@property (weak,nonatomic ) IBOutlet UILabel               *remindLabel;
@property (weak,nonatomic ) IBOutlet UIProgressView        *progress;
@property (nonatomic) BOOL animated;

@end