//
//  AppDelegate.h
//  CookingApp
//
//  Created by Christopher Harris on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ConfigureController.h"
#import "DishdetailController.h"
#import "NewdishController.h"
#import "StartController.h"
#import "AudioController.h"
#import "SettingsController.h"
#import "DishdetailController.h"
#import "SettingsdetailController.h"
#import "UtilController.h"

#define AD ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define BUFFER_PREP 0.1
#define STD_WIDTH 320
#define STD_HEIGHT 480
#define CELL_HEIGHT 70
#define NOTIFICATION_INTERVAL 30
#define MAX_DISHES 5
#define TABBAR_WIDTH 640
#define TABBAR_HEIGHT 56

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    BOOL timerRunning;
    BOOL allDone;
    NSMutableArray *dishObjects;
    NSMutableArray *configureTracker;
    NSMutableArray *startTracker;
    NSArray *pickerHours;
    NSArray *pickerMins;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) NSMutableArray *dishObjects;
@property (nonatomic, retain) NSMutableArray *configureTracker;
@property (nonatomic, retain) NSMutableArray *startTracker;
@property (nonatomic, retain) NSArray *pickerHours;
@property (nonatomic, retain) NSArray *pickerMins;
@property (nonatomic, retain) ConfigureController *configureController;
@property (nonatomic, retain) DishdetailController *dishDetailController;
@property (nonatomic, retain) NewdishController *newdishController;
@property (nonatomic, retain) StartController *startController;
@property (nonatomic, retain) AudioController *audioController;
@property (nonatomic, retain) SettingsController *settingsController;
@property (nonatomic, retain) DishdetailController *timerController;
@property (nonatomic, retain) SettingsdetailController *settingsdetailController;
@property BOOL timerRunning;
@property BOOL allDone;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL*)applicationDocumentDirectory;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;






@end
