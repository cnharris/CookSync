//
//  NewdishController.h
//  CookingApp
//
//  Created by Christopher Harris on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UtilController.h"
#import "DishController.h"
#import "DishesModel.h"
#import "FavoritesController.h"

@interface NewdishController : UtilController <UIPickerViewDataSource, UIPickerViewDelegate>
{
    int did;
    DishController *currentValues;
    IBOutlet UIView *canvas;
    IBOutlet UIView *overlay;
    IBOutlet UITextField *nameField;
    IBOutlet UILabel *durationField;
    IBOutlet UISlider *durationHoursSlider;
    IBOutlet UISlider *durationMinutesSlider;
    IBOutlet UIButton *favoritesCheckbox;
    IBOutlet UIButton *saveButton;
    IBOutlet UILabel *minmins;
    NSManagedObjectContext *managedObjectContext;
}

@property int did;
@property (nonatomic, retain) DishController *currentValues;
@property (nonatomic, retain) IBOutlet UIView *canvas;
@property (nonatomic, retain) IBOutlet UIView *overlay;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UILabel *durationField;
@property (nonatomic, retain) IBOutlet UISlider *durationHoursSlider;
@property (nonatomic, retain) IBOutlet UISlider *durationMinutesSlider;
@property (nonatomic, retain) IBOutlet UIButton *favoritesCheckbox;
@property (nonatomic, retain) IBOutlet UIButton *saveButton;
@property (nonatomic, retain) IBOutlet UILabel *minmins;


@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (IBAction)cancelDish:(id)sender;

@end
