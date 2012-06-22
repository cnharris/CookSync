//
//  DishdetailController.h
//  OvenApp
//
//  Created by Christopher Harris on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DishController.h"

@interface DishdetailController : UIViewController <UITextFieldDelegate>
{    
    int did;
    DishController *currentValues;
    IBOutlet UIView *canvas;
    IBOutlet UIView *overlay;
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *durationField;
    IBOutlet UISlider *durationHoursSlider;
    IBOutlet UISlider *durationMinutesSlider;
    IBOutlet UIButton *saveButton;
    IBOutlet UILabel *minmins;
    
    NSManagedObjectContext *managedObjectContext;
}

@property int did;
@property (nonatomic, retain) DishController *currentValues;
@property (nonatomic, retain) IBOutlet UIView *canvas;
@property (nonatomic, retain) IBOutlet UIView *overlay;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *durationField;
@property (nonatomic, retain) IBOutlet UISlider *durationHoursSlider;
@property (nonatomic, retain) IBOutlet UISlider *durationMinutesSlider;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UILabel *minmins;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

-(IBAction) sliderHoursChanged:(id)sender;
-(IBAction) sliderMinutesChanged:(id)sender;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(BOOL)checkIfTimerIsRunning;

@end
