//
//  User.h
//  HeartBeats
//
//  Created by jt3 on 15/3/17.
//  Copyright (c) 2015年 Christian Roman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * birthday;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * sex;
@property (nonatomic, retain) NSNumber * roottime;

@end
