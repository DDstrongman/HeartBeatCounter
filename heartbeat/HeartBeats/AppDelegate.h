//
//  AppDelegate.h
//  HeartBeats
//
//  Created by Christian Roman on 30/08/13.
//  Copyright (c) 2013 Christian Roman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TalkingData.h"
#import <PromptAdvertising/PromptAdvertising.h>
#import "Appirater.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic) Boolean SucessOrNot;
@property (nonatomic) Boolean HeartRateOrNot;

@property (nonatomic) int ProgressGreenOrNot;

- (NSURL *)applicationDocumentsDirectory;
- (void)saveContext;

@end
