//
//  DishdetailController.m
//  OvenApp
//
//  Created by Christopher Harris on 4/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DishdetailController.h"

@implementation DishdetailController

@synthesize did;
@synthesize canvas;
@synthesize overlay;
@synthesize nameField;
@synthesize durationField;
@synthesize durationHoursSlider;
@synthesize durationMinutesSlider;
@synthesize currentValues;
@synthesize saveButton;
@synthesize minmins;
@synthesize managedObjectContext;

- (id)init
{
    return self;
}

- (void)viewDidLoad 
{
    [super viewDidLoad];
    [self.view setBackgroundColor:defaultBackground];
    canvas = [self buildCanvasWithX:10 withY:8 withWidth:300 withHeight:340];
    [[canvas layer] setCornerRadius:6.0];
    [canvas setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:canvas];
    
	// Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [self saveFieldValuesToConfigureTracker];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self buildNavBar:@"dishes"];
    [backButton addTarget:self action:@selector(cancelDish:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [self getValues];
    [self buildName];
    [self buildDurationField];
    [self buildDurationMinutesSlider];
    [self buildDurationHoursSlider];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self saveFieldValuesToConfigureTracker];
    // Release any retained subviews of the main view.
}

- (void)viewWillUnload
{
    [super viewWillUnload];
    [self saveFieldValuesToConfigureTracker];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
    [self saveFieldValuesToConfigureTracker];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [nameField resignFirstResponder];
    [nameField endEditing:YES];
    return NO;
}

- (void)saveFieldValuesToConfigureTracker
{
    [currentValues setTitle:[nameField text]];
    [currentValues setDuration:[durationField text]];
    [AD.configureTracker replaceObjectAtIndex:did withObject:currentValues];
    [AD.configureController.dishes reloadData];
}

- (void)setNavTitle
{
    [self.navigationItem setTitle:[currentValues title]];
}

- (void)getValues
{
    currentValues = [AD.configureTracker objectAtIndex:did];
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
    [nameField setText:[currentValues title]];
}

- (void)buildDurationField
{
    if(!durationField){
        UILabel *cookTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 69, 100, 30)];
        [cookTimeLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0]];
        [cookTimeLabel setTextColor:[UIColor colorWithRed:66.0/255 green:68.0/255 blue:74.0/255 alpha:1.0]];
        [cookTimeLabel setText:@"Cook Time"];
        [canvas addSubview:cookTimeLabel];
        
        durationField = [[UITextField alloc] initWithFrame:CGRectMake(10, 114, 280, 45)];
        [durationField setBackgroundColor:[UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1.0]];
        [durationField setBorderStyle:UITextBorderStyleRoundedRect];
        [durationField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:24.0f]];
        [durationField setTextAlignment:UITextAlignmentCenter];
        [durationField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
        [durationField setUserInteractionEnabled:NO];
        [[durationField layer] setCornerRadius:6.0];
        [canvas addSubview:durationField];
    }
    [durationField setText:[currentValues duration]];
}

- (void)buildDurationMinutesSlider
{
    NSMutableDictionary *hoursMins = [self parseDuration];
    if(!durationMinutesSlider){
        durationMinutesSlider = [[UISlider alloc] initWithFrame:CGRectMake(10, 190, 280, 20)];
        [durationMinutesSlider setMinimumValue:1];
        [durationMinutesSlider setMaximumValue:59];
        [durationMinutesSlider setMinimumTrackImage:[UIImage imageNamed:@"slider_track.png"] forState:UIControlStateNormal];
        [canvas addSubview:durationMinutesSlider];
        [durationMinutesSlider addTarget:self action:@selector(sliderMinutesChanged:) 
                        forControlEvents:UIControlEventValueChanged];
        
        minmins = [[UILabel alloc] initWithFrame:CGRectMake(15, 178, 20, 12)];
        [minmins setText:@"1"];
        [minmins setBackgroundColor:[UIColor clearColor]];
        [minmins setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [canvas addSubview:minmins];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125, 177, 52, 12)];
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

- (IBAction)cancelDish:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkIfTimerIsRunning
{
    return ![AD timerRunning];
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

- (IBAction)closeKeyboard:(id)sender { 
    [nameField resignFirstResponder]; 
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
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
    
    if(hours == 1){
        [durationField setText:[[NSString alloc] initWithFormat:@"%d hr, %d min", hours,mins]];
    } else {
        [durationField setText:[[NSString alloc] initWithFormat:@"%d hr, %d min", hours,mins]];
    }
}

- (IBAction) sliderMinutesChanged:(id)sender 
{
    UISlider *slider = (UISlider *)sender;
    int hours = durationHoursSlider.value;
    int mins = (int)(slider.value + 0.5f);
    [durationField setText:[[NSString alloc] initWithFormat:@"%d hours, %d min", hours,mins]];
}

@end
