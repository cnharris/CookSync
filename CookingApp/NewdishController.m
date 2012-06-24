//
//  NewdishController.m
//  CookingApp
//
//  Created by Christopher Harris on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "NewdishController.h"

@implementation NewdishController

@synthesize managedObjectContext;

@synthesize did;
@synthesize canvas;
@synthesize overlay;
@synthesize nameField;
@synthesize durationField;
@synthesize durationHoursSlider;
@synthesize durationMinutesSlider;
@synthesize currentValues;
@synthesize favoritesCheckbox;
@synthesize saveButton;
@synthesize minmins;

- (id)init
{
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:defaultBackground];
    canvas = [self buildCanvasWithX:10 withY:8 withWidth:300 withHeight:400];
    [canvas setBackgroundColor:[UIColor whiteColor]];
    [[canvas layer] setCornerRadius:6.0];
    [self.view addSubview:canvas];
    
    [self buildName];
    [self buildDurationField];
    [self buildDurationHoursSlider];
    [self buildDurationMinutesSlider];
    [self buildFavoritesOption];
    [self buildSaveButton];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self buildNavBar:@"dishes"];
    self.navigationItem.leftBarButtonItem = cancelBarButton;
    self.navigationItem.rightBarButtonItem = favoritesBarButton;
    [cancelButton addTarget:self action:@selector(cancelDish:) forControlEvents:UIControlEventTouchUpInside];
    [favoritesButton addTarget:self action:@selector(showFavorites:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [self resetFields];
}

- (void)resetFields
{
    [nameField setText:@"Enter Dish Name"];
    [durationField setText:@"0 hour, 15 min"];
    [durationMinutesSlider setValue:15];
    [durationHoursSlider setValue:0];
}

- (IBAction)addDish:(id)sender
{
    [self checkIfAddToFavorites];
    currentValues = [[DishController alloc] init];
    [currentValues setTitle:[nameField text]];
    [currentValues setDuration:[durationField text]];
    [currentValues setIcon:@"dish_icon.png"];
    [AD.configureTracker addObject:currentValues];
    [AD.configureController.dishes setContentSize:CGSizeMake(STD_WIDTH, CELL_HEIGHT*[AD.configureTracker count])];
    NSLog(@"Done");
    
    NSLog(@"CONFIG TRACKER: %d",[AD.configureTracker count]);
    
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancelDish:(id)sender
{
    for(DishController *dish in AD.configureTracker){
        NSLog(@"Dish: %@",[dish title]);
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)saveFieldValuesToConfigureTracker
{
    [currentValues setTitle:[nameField text]];
    [currentValues setDuration:[durationField text]];
}

- (void)buildName
{
    if(!nameField){
        UIView *nameContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 60)];
        [nameContainer setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newdish_namecontainer.png"]]];
        [[nameContainer layer] setMasksToBounds:YES];
        [[nameContainer layer] setCornerRadius:6.0];
        
        //Prevent rounded corners on bottom of nameContainer
        UIView *bottomEdges = [[UIView alloc] initWithFrame:CGRectMake(0, 53, 300, 8)];
        [bottomEdges setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0]];
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0,61,300,1)];
        [bottomBorder setBackgroundColor:[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1.0]];

        nameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 8, 280, 45)];
        [nameField setDelegate:(id)self];
        [nameField setReturnKeyType:UIReturnKeyDone];
        [nameField setBorderStyle:UITextBorderStyleRoundedRect];
        [nameField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
        [nameField setTextAlignment:UITextAlignmentCenter];
        [nameField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [nameField addTarget:self action:@selector(close:) forControlEvents:UIControlEventEditingDidEndOnExit];
        
        [nameContainer addSubview:nameField];
        [canvas addSubview:nameContainer];
        [canvas addSubview:bottomEdges];
        [canvas addSubview:bottomBorder];
    }
    nameField.text = @"Enter Dish Name";
}

- (void)buildDurationField
{
    if(!durationField){
        UILabel *cookTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 69, 100, 30)];
        [cookTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [cookTimeLabel setTextColor:[UIColor colorWithRed:66.0/255 green:68.0/255 blue:74.0/255 alpha:1.0]];
        [cookTimeLabel setText:@"Cook Time"];
        [canvas addSubview:cookTimeLabel];
        
        durationField = [[UILabel alloc] initWithFrame:CGRectMake(10, 114, 280, 45)];
        [durationField setBackgroundColor:[UIColor colorWithRed:245.0/255 green:245.0/255 blue:245.0/255 alpha:1.0]];
        [durationField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:24.0f]];
        [durationField setTextAlignment:UITextAlignmentCenter];
        [durationField setUserInteractionEnabled:NO];
        [[durationField layer] setBorderWidth:1.0];
        [[durationField layer] setBorderColor:[UIColor colorWithRed:218.0/255 green:218.0/255 blue:218.0/255 alpha:1.0].CGColor];
        [[durationField layer] setCornerRadius:6.0];
        [canvas addSubview:durationField];
    }
    durationField.text = @"0 hour, 15 min";
}

- (void)buildDurationMinutesSlider
{
    NSMutableDictionary *hoursMins = [self parseDuration];
    if(!durationMinutesSlider){
        durationMinutesSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 190, 280, 20)];
        [durationMinutesSlider setMinimumValue:1];
        [durationMinutesSlider setMaximumValue:59];
        [durationMinutesSlider setThumbImage:[UIImage imageNamed:@"slider_knob.png"] forState:UIControlStateNormal];
        [durationMinutesSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_track.png"] forState:UIControlStateNormal];
        [canvas addSubview:durationMinutesSlider];
        [durationMinutesSlider addTarget:self action:@selector(sliderMinutesChanged:) 
                        forControlEvents:UIControlEventValueChanged];
        
        minmins = [[UILabel alloc] initWithFrame:CGRectMake(15, 178, 20, 12)];
        [minmins setText:@"1"];
        [minmins setBackgroundColor:[UIColor clearColor]];
        [minmins setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [canvas addSubview:minmins];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(124, 178, 52, 12)];
        [label setText:@"minutes"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [canvas addSubview:label];
        
        UILabel *maxmins = [[UILabel alloc] initWithFrame:CGRectMake(270, 178, 20, 12)];
        [maxmins setText:@"59"];
        [maxmins setBackgroundColor:[UIColor clearColor]];
        [maxmins setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        
        [canvas addSubview:minmins];
        [canvas addSubview:maxmins];
    }
    [durationMinutesSlider setValue:[[hoursMins objectForKey:@"mins"] integerValue]];
}

- (void)buildDurationHoursSlider
{
    NSMutableDictionary *hoursMins = [self parseDuration];
    if(!durationHoursSlider){
        durationHoursSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 250, 280, 20)];
        [durationHoursSlider setMinimumValue:0];
        [durationHoursSlider setMaximumValue:23];
        [durationHoursSlider setThumbImage:[UIImage imageNamed:@"slider_knob.png"] forState:UIControlStateNormal];
        [durationHoursSlider setValue:[[hoursMins objectForKey:@"hours"] integerValue]];
        [durationHoursSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_track.png"] forState:UIControlStateNormal];
        [canvas addSubview:durationHoursSlider];
        [durationHoursSlider addTarget:self action:@selector(sliderHoursChanged:) 
                      forControlEvents:UIControlEventValueChanged];
        
        UILabel *minhours = [[UILabel alloc] initWithFrame:CGRectMake(15, 238, 20, 12)];
        [minhours setText:@"0"];
        [minhours setBackgroundColor:[UIColor clearColor]];
        [minhours setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [canvas addSubview:minhours];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(132, 238, 40, 12)];
        [label setText:@"hours"];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [canvas addSubview:label];
        
        UILabel *maxhours = [[UILabel alloc] initWithFrame:CGRectMake(270, 238, 20, 12)];
        [maxhours setText:@"23"];
        [maxhours setBackgroundColor:[UIColor clearColor]];
        [maxhours setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        
        [canvas addSubview:minhours];
        [canvas addSubview:maxhours];
    }
    [durationHoursSlider setValue:[[hoursMins objectForKey:@"hours"] integerValue]];
    
}

- (void)buildFavoritesOption
{
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0,278,300,1)];
    [topBorder setBackgroundColor:[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1.0]];
    
    UILabel *saveToFav = [[UILabel alloc] initWithFrame:CGRectMake(10, 284, 200, 30)];
    [saveToFav setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
    [saveToFav setTextColor:[UIColor colorWithRed:66.0/255 green:68.0/255 blue:74.0/255 alpha:1.0]];
    [saveToFav setText:@"Save To Favorites"];
    [canvas addSubview:saveToFav];
    
    favoritesCheckbox = [[UIButton alloc] initWithFrame:CGRectMake(267, 287, 23, 23)];
    [favoritesCheckbox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newdish_checkbox_unchecked"]]];
    [favoritesCheckbox addTarget:self action:@selector(saveToFavorites:) forControlEvents:UIControlEventTouchUpInside];
    [favoritesCheckbox setTag:0];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0,318,300,1)];
    [bottomBorder setBackgroundColor:[UIColor colorWithRed:217.0/255 green:217.0/255 blue:217.0/255 alpha:1.0]];
    
    [canvas addSubview:topBorder];
    [canvas addSubview:saveToFav];
    [canvas addSubview:favoritesCheckbox];
    [canvas addSubview:bottomBorder];
    
}

- (void)checkIfAddToFavorites
{
    NSLog(@"Favorites Tag: %d",[favoritesCheckbox tag]);
    if([favoritesCheckbox tag] == 1){
        NSLog(@"Save to favorites!!!!");
        [self saveDishToFavorites];
    }
}

- (void)saveDishToFavorites
{
    NSManagedObjectContext *context = [AD managedObjectContext];
    DishesModel *favoriteDish = [NSEntityDescription
                                   insertNewObjectForEntityForName:@"DishesModel"
                                   inManagedObjectContext:context];
    favoriteDish.title = [nameField text];
    favoriteDish.duration = [durationField text];
    favoriteDish.icon = @"dish_icon.png";
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    } else {
        NSLog(@"IT GOT SAVED!!!");
    }
}

- (IBAction)saveToFavorites:(id)sender
{
    UIButton *theButton = (UIButton *)sender;
    if([theButton tag] == 0){
        [theButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newdish_checkbox_checked"]]];
        [theButton setTag:1];
    } else {
        [theButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newdish_checkbox_unchecked"]]];
        [theButton setTag:0];
    }
}

- (void)buildSaveButton
{
    if(!saveButton){
        saveButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 336, 280, 47)];
        [saveButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"newdish_addmydish_button"]]];
        [canvas addSubview:saveButton];
        [saveButton addTarget:self action:@selector(addDish:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (IBAction)showFavorites:(id)sender
{
    FavoritesController *fc = [[FavoritesController alloc] init];
    fc.managedObjectContext = self.managedObjectContext;
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:fc];
    [self presentModalViewController:navCon animated:YES];
}

- (NSMutableDictionary *)parseDuration
{
    NSMutableDictionary *hsh = [[NSMutableDictionary alloc] init];
    NSString *durationValue = durationField.text;
    NSArray *hoursmins = [durationValue componentsSeparatedByString: @", "];
    NSString *hours = [hoursmins objectAtIndex:0];
    NSString *mins = [hoursmins objectAtIndex:1];
    NSArray *hoursAndLabel = [hours componentsSeparatedByString: @" "];
    NSArray *minsAndLabel = [mins componentsSeparatedByString: @" "];
    [hsh setObject:[hoursAndLabel objectAtIndex:0] forKey:@"hours"];
    [hsh setObject:[minsAndLabel objectAtIndex:0] forKey:@"mins"];
    return hsh;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if([[textField text] isEqual:@"Enter Dish Name"]){
        [textField setText:@""];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if([[textView text] isEqual:@"Describe your dish..."]){
        [textView setText:@""];
    }
}

- (IBAction)close:(id)sender { 
    [nameField resignFirstResponder]; 
}

- (IBAction) sliderHoursChanged:(id)sender 
{
    UISlider *slider = (UISlider *)sender;
    int hours = (int)(slider.value + 0.5f);
    int mins = durationMinutesSlider.value;
    
    if(hours == 0){
        [durationMinutesSlider setMinimumValue:1];
        [minmins setText:@"1"];
    } else {
        [durationMinutesSlider setMinimumValue:0];
        [minmins setText:@"0"];
    }
    
    [durationField setText:[[NSString alloc] initWithFormat:@"%d hour, %d min", hours,mins]];
}

- (IBAction) sliderMinutesChanged:(id)sender 
{
    UISlider *slider = (UISlider *)sender;
    int hours = durationHoursSlider.value;
    int mins = (int)(slider.value + 0.5f);
    [durationField setText:[[NSString alloc] initWithFormat:@"%d hour, %d min", hours,mins]];
}

- (void)pickerView:(UIPickerView *)pV didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 1){
        NSLog(@"Hour");
    } else if(component == 2){
        NSLog(@"Min");
    }
}

- (NSInteger)rowHeightForComponent:(UIPickerView *)pickerView
{
    return 20;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{ 
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(component == 0){
        return [ad.pickerHours count];
    }
    return [ad.pickerMins count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(component == 1){
        return [ad.pickerHours objectAtIndex:row];
    }
    return [ad.pickerMins objectAtIndex:row];
}

@end
