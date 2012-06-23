//
//  ConfigureController.h
//  OvenApp
//
//  Created by Christopher Harris on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DishdetailController.h"
#import "DishController.h"
#import "StartCell.h"

@interface ConfigureController : UIViewController
{
    IBOutlet UIScrollView *canvas;
    IBOutlet UITextView *instructions;
    IBOutlet UITableView *dishes;
    IBOutlet UIView *welcomeView;
    IBOutlet UIBarButtonItem *editBarButton;
    IBOutlet UIBarButtonItem *doneBarButton;
    IBOutlet UIBarButtonItem *plusBarButton;
}

typedef struct coords {
    int x;
    int y;
    int h;
    int w;
} dishCoords;

@property (nonatomic, retain) IBOutlet UITextView *instructions;
@property (nonatomic, retain) IBOutlet UIScrollView *canvas;
@property (nonatomic, retain) IBOutlet UITableView *dishes;
@property (nonatomic, retain) IBOutlet UIView *welcomeView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *plusBarButton;

@property (nonatomic, retain) NSDate *endDateTime;
@property int amountOfDishes;
@property (nonatomic, retain) NSMutableArray *dishLabels;


@end
