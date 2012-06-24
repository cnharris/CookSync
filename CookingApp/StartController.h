//
//  StartController.h
//  CookingApp
//
//  Created by Christopher Harris on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UtilController.h"
#import "StartCell.h"

@interface StartController : UtilController <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
{
    IBOutlet UIScrollView *canvas;
    IBOutlet UITableView *dishes;
    IBOutlet UILabel *noDishes;
    IBOutlet UIView *stopTimeFieldAndButtonContainer;
    IBOutlet UILabel *stopTimeField;
    IBOutlet UIDatePicker *picker;
    IBOutlet UIView *overlay;
    IBOutlet UIView *timeView;
    IBOutlet UILabel *hoursBox;
    IBOutlet UILabel *minsBox;
    IBOutlet UILabel *ampmBox;
    IBOutlet UITapGestureRecognizer *labelTapGesture;
    IBOutlet UIButton *startStop;
    IBOutlet UIAlertView *doneAlert;
    IBOutlet UILabel *addDish;
    
    NSDate *startTimeButtonPressed;
    NSDate *stopTime;
    NSDictionary *largestDuration;
    NSMutableArray *prepTimers;
    NSMutableArray *stopTimers;
    
}

@property (nonatomic, retain) IBOutlet UIView *canvas;
@property (nonatomic, retain) IBOutlet UITableView *dishes;
@property (nonatomic, retain) IBOutlet UILabel *noDishes;
@property (nonatomic, retain) IBOutlet UIView *stopTimeFieldAndButtonContainer;
@property (nonatomic, retain) IBOutlet UILabel *stopTimeField;
@property (nonatomic, retain) IBOutlet UIView *overlay;
@property (nonatomic, retain) IBOutlet UIDatePicker *picker;
@property (nonatomic, retain) IBOutlet UIView *timeView;
@property (nonatomic, retain) IBOutlet UILabel *hoursBox;
@property (nonatomic, retain) IBOutlet UILabel *minsBox;
@property (nonatomic, retain) IBOutlet UILabel *ampmBox;
@property (nonatomic, retain) IBOutlet UITapGestureRecognizer *labelTapGesture;
@property (nonatomic, retain) IBOutlet UIButton *startStop;
@property (nonatomic, retain) IBOutlet UILabel *addDish;

@property NSDate *startTimeButtonPressed;
@property NSDate *stopTime;
@property NSDictionary *largestDuration;
@property NSMutableArray *prepTimers;
@property NSMutableArray *stopTimers;

- (NSInteger *)getTimeMinutes:(NSDictionary *)time;
- (void)stopAllTimers;

@end
