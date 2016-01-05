//
//  appTime.h
//  Alerttest
//
//  Created by chaohua on 15-2-5.
//  Copyright (c) 2015年 李朝华. All rights reserved.
//

#import <Foundation/Foundation.h>

#define APP_ACTIVE_COUNT @"activeCount" /* 起動回数 */
#define APP_FIRST_START @"firstStart" //第一次启动
@interface appTime : NSObject
- (id)initWithBaseURL:(NSString*)baseURL;
@end
