//
//  HeartBeatsInfo.h
//  HeartBeats
//
//  Created by jt3 on 15/3/11.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"


@interface HeartBeatsInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * beats;
@property (nonatomic, retain) NSString * time;

@end
