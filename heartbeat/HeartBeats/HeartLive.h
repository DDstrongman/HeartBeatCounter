//
//  HeartLive.h
//  HeartRateCurve
//
//  Created by IOS－001 on 14-4-23.
//  Copyright (c) 2014年 N/A. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface PointContainer : NSObject

@property (nonatomic , readonly) NSInteger numberOfTranslationElements;
@property (nonatomic , readonly) CGPoint *translationPointContainer;


+ (PointContainer *)sharedContainer;

//平移变换
- (void)addPointAsTranslationChangeform:(CGPoint)point;

@end



@interface HeartLive : UIView

- (void)fireDrawingWithPoints:(CGPoint *)points pointsCount:(NSInteger)count;
@property (nonatomic, retain) AppDelegate* myAppDelegate;

@end

