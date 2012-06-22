//
//  DishController.h
//  CookSync
//
//  Created by Christopher Harris on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DishController : NSObject
{
    NSString *title;    
    NSString *duration;
    NSString *timeLeft;
    NSString *timeLeftAction;
    NSString *icon;
    NSDate *prepTime;
    NSDate *startTime;
    BOOL *doneIcon;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *duration;
@property (nonatomic, retain) NSString *timeLeft;
@property (nonatomic, retain) NSString *timeLeftAction;
@property (nonatomic, retain) NSString *icon;
@property (nonatomic, retain) NSDate *prepTime;
@property (nonatomic, retain) NSDate *startTime;
@property (nonatomic, assign) BOOL *doneIcon;

@end
