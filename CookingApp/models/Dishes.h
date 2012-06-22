//
//  Dishes.h
//  CookSync
//
//  Created by Christopher Harris on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dishes : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *applianceType;
@property (nonatomic, retain) NSString *timeLeft;
@property (nonatomic, retain) NSString *timeLeftAction;
@property (nonatomic, retain) NSString *applianceNumber;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSDate *prepTime;
@property (nonatomic, retain) NSDate *startTime;

@end
