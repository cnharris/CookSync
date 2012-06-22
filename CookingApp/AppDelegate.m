//
//  AppDelegate.m
//  CookingApp
//
//  Created by Christopher Harris on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DishdetailController.h"
#import "AudioController.h"
#import "SettingsController.h"
#import "DishdetailController.h"
#import "DishController.h"
#import "FavoritesController.h"
#import "SettingsdetailController.h"

#include <stdlib.h>

@implementation AppDelegate

@synthesize window = _window;

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

@synthesize dishObjects;
@synthesize configureTracker;
@synthesize startTracker;
@synthesize pickerHours;
@synthesize pickerMins;
@synthesize configureController;
@synthesize dishDetailController;
@synthesize newdishController;
@synthesize audioController;
@synthesize startController;
@synthesize settingsController;
@synthesize settingsdetailController;
@synthesize timerController;
@synthesize utilController;
@synthesize timerRunning;
@synthesize allDone;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
    else {
        NSLog(@"Could not be saved, managedObjectContext is nil");
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(![self checkVersion]){
        return YES;
    }
    
    //Black status bar
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    //Array to house dish objects
    //dishObjects = [[NSMutableArray alloc] init];
    //[self prepopulateDishes];
    
    configureTracker = [[NSMutableArray alloc] init];
    
    //Initialize time to NOT running
    timerRunning = FALSE;
    
    //Initialize controllers
    configureController = [[ConfigureController alloc] init];
    dishDetailController = [[DishdetailController alloc] init];
    newdishController = [[NewdishController alloc] init];
    startController = [[StartController alloc] init];
    settingsdetailController = [[SettingsdetailController alloc] init];
    audioController = [[AudioController alloc] init];
    
    // *** IMPORTANT *** //
    // *** Set context to appDelegate context for ANY controller using CORE DATA *** //
    NSManagedObjectContext *context = [self managedObjectContext];
    newdishController.managedObjectContext = context;
    
    //[self deleteAllObjects:@"Dish"];
    
    pickerHours = [[NSArray alloc] initWithObjects: 0,1,2,3,4,5,6,7,8,9,
                                                    10,11,12,13,14,15,16,17,18,19,
                                                    20,21,22,23,nil];
    pickerHours = [[NSArray alloc] initWithObjects: 0,1,2,3,4,5,6,7,8,9,
                                                    10,11,12,13,14,15,16,17,18,19,
                                                    20,21,22,23,24,25,26,27,28,29,
                                                    30,31,32,33,34,35,36,37,38,39,
                                                    40,41,42,43,44,45,46,47,48,49,
                                                    50,51,52,53,54,55,56,57,58,59,nil];
    
    [self setTabBarItemCustomizations];
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    [[[UIAlertView alloc] initWithTitle:@"Reminder" message:[notification alertBody] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    [self.audioController playBell];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [self saveContext];
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self.startController stopAllTimers];
    [self saveContext];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [self saveContext];
}

- (void)applicationSignificantTimeChange:(UIApplication *)application
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)setTabBarItemCustomizations
{
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:0.0/255 green:151.0/216 blue:216.0/255 alpha:1.0], UITextAttributeTextColor, 
      [UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0], UITextAttributeFont, 
      nil] 
                                             forState:UIControlStateHighlighted];
    
    [[UITabBarItem appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor darkGrayColor], UITextAttributeTextColor, 
      [UIFont fontWithName:@"HelveticaNeue-Medium" size:0.0], UITextAttributeFont,nil] 
                                             forState:UIControlStateNormal];
}

- (void)prepopulateDishes
{
    for(int i = 0; i < 2; i++){
        DishController *d = [[DishController alloc] init];
        [d setTitle:[NSString stringWithFormat:@"Dish %d", i+1]];
        [d setDuration:@"0 hr, 15 min"];
        [d setTimeLeft:@""];
        [d setTimeLeftAction:@""];
        [d setIcon:@"dish_icon@2x"];
        [dishObjects addObject:d];
    }
}

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    
    for (NSManagedObject *managedObject in items) {
        [__managedObjectContext deleteObject:managedObject];
        NSLog(@"%@ object deleted",entityDescription);
    }
    if (![__managedObjectContext save:&error]) {
        NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

- (BOOL)checkVersion
{
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if(version < 5){
        NSString *msg = @"We're sorry, but you need iOS 5+ to run this app. Please upgrade your device.";
        UIAlertView *versionAlert = [[UIAlertView alloc] initWithTitle:@"Unsupported Version" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.window addSubview:versionAlert];
        return NO;
    }
    return YES;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    NSLog(@"GOT IN!!");
    if (__managedObjectContext != nil) {
        NSLog(@"222");
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DishesModel" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CookSync.sqlite"];
    NSLog(@"Store URL: %@",storeURL);
    
    //Buggy!
//    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
//        NSLog(@"PRELOADING!!!!!!!");
//        NSLog(@"Path: %@",[[NSBundle mainBundle] pathForResource:@"CookSync" ofType:@"sqlite"]);
//        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"CookSync" ofType:@"sqlite"]];
//        NSLog(@"Preloaded URL: %@",preloadURL);
//        NSError* err = nil;
//        
//        if (![[NSFileManager defaultManager] copyItemAtURL:storeURL toURL:storeURL error:&err]) {
//            NSLog(@"Oops, could copy preloaded data");
//        }
//    }
//    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
