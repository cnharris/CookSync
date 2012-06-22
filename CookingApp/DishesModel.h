//
//  DishesModel.h
//  CookSync
//
//  Created by Christopher Harris on 5/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DishesModel : NSManagedObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *timeLeft;
@property (nonatomic, retain) NSString *timeLeftAction;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSDate *prepTime;
@property (nonatomic, retain) NSDate *startTime;

@end
