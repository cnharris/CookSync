//
//  SettingsdetailController.m
//  CookingApp
//
//  Created by Christopher Harris on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsdetailController.h"

@implementation SettingsdetailController

@synthesize section;
@synthesize canvas;
@synthesize onoff;
@synthesize slider;

- (id)init
{
    [self retrieveOrBuildDefaults];
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self buildNavBar:section];
    [backButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if(section == @"notifications"){
        [self buildNotifications];
    } else if(section == @"about"){
        [self buildAbout];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:FALSE];
    [self saveDefaults];
}  

- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildNotifications
{
    [self.navigationItem setTitle:@"Notifications"];
    canvas = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, 416)];
    [canvas setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self.view addSubview:canvas];
    [canvas setContentSize:CGSizeMake(STD_WIDTH, 450)];
    [self retrieveOrBuildDefaults];
    [self buildSettingViews];
}

- (void)buildAbout
{
    [self.navigationItem setTitle:@"About"];
    
    canvas = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, 416)];
    [canvas setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self.view addSubview:canvas];
    [canvas setContentSize:CGSizeMake(STD_WIDTH, 450)];
    
    UIView *info = [[UIView alloc] initWithFrame:CGRectMake(10, 20, 300, 140)];
    [info setBackgroundColor:[UIColor whiteColor]];
    [[info layer] setCornerRadius:6.0];
    [[info layer] setBorderWidth:1];
    [[info layer] setBorderColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0].CGColor];
    
    UILabel *created = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 280, 15)];
    [created setTextAlignment:UITextAlignmentCenter];
    [created setTextColor:[UIColor darkGrayColor]];
    [created setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0]];
    [created setLineBreakMode:UILineBreakModeWordWrap];
    [created setText:@"Created by:"];
    
    UILabel *me = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 280, 20)];
    [me setTextAlignment:UITextAlignmentCenter];
    [me setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
    [me setLineBreakMode:UILineBreakModeWordWrap];
    [me setText:@"Christopher Harris"];
    
    UILabel *designed = [[UILabel alloc] initWithFrame:CGRectMake(10, 80, 280, 15)];
    [designed setTextAlignment:UITextAlignmentCenter];
    [designed setTextColor:[UIColor darkGrayColor]];
    [designed setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0]];
    [designed setLineBreakMode:UILineBreakModeWordWrap];
    [designed setText:@"Designed by:"];
    
    UILabel *her = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 280, 20)];
    [her setTextAlignment:UITextAlignmentCenter];
    [her setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0]];
    [her setLineBreakMode:UILineBreakModeWordWrap];
    [her setText:@"Nadia Sawir"];
    
    [info addSubview:created];
    [info addSubview:me];
    [info addSubview:designed];
    [info addSubview:her];
    
    [canvas addSubview:info];
    
}

- (void)saveDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSLog(@"DEFAULTS: %@",defaults);
    for(UILabel *view in canvas.subviews){
        if([NSClassFromString(@"UIView") isEqual:[view class]] && [view tag] == 4){
            NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
            NSLog(@"TEMP: %@",temp);
            for(id subview in view.subviews){
                if([subview tag] == 5){
                    [temp setValue:[subview text] forKey:@"name"];
                    NSLog(@"NAME IS: %@",[subview text]);
                }
                if([subview tag] == 6){
                    [temp setValue:(([subview isOn]) ? @"TRUE" : @"FALSE") forKey:@"on"];
                }

                if([subview tag] == 2){
                    [temp setValue:[NSString stringWithFormat:@"%d",(int)[(UISlider *)subview value]] forKey:@"value"];
                }

                if([subview tag] == 1){
                    [temp setValue:[subview text] forKey:@"label"];
                }
            }
            if([((UILabel *)[view viewWithTag:5]).text isEqual:@"Start Dish"]){
               [defaults setObject:temp forKey:@"startingNotification"];
                NSLog(@"NEW DEFAULTS: %@",[defaults objectForKey:@"startingNotification"]);
            } else if([((UILabel *)[view viewWithTag:5]).text isEqual:@"End Dish"]) {
               [defaults setObject:temp forKey:@"endingNotification"];
            }
        }
    }
    [defaults synchronize];
}

- (void)retrieveOrBuildDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *startingNotification = [defaults objectForKey:@"startingNotification"];
    NSMutableDictionary *endingNotification = [defaults objectForKey:@"endingNotification"];
    
    if(startingNotification == nil){
        [defaults setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Start Dish",@"name",@"2.0f",@"value",@"1:00",@"label",@"TRUE",@"on", nil] forKey:@"startingNotification"];
    }
    
    if(endingNotification == nil){
        [defaults setObject:[[NSMutableDictionary alloc] initWithObjectsAndKeys:@"End Dish",@"name",@"2.0f",@"value",@"1:00",@"label",@"TRUE",@"on", nil] forKey:@"endingNotification"];
    }
    [defaults synchronize];
}

- (void)buildSettingViews
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0,15,320, 50)];
    [info setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"settings_copy.png"]]];
    
    UIView *starting = [self buildWarning:@"Start Dish" withFrame:CGRectMake(10, 75, 300, 120) withSettings:[defaults objectForKey:@"startingNotification"]];
    UIView *ending = [self buildWarning:@"End Dish" withFrame:CGRectMake(10, 205, 300, 120) withSettings:[defaults objectForKey:@"endingNotification"]];
    
    [canvas addSubview:info];
    [canvas addSubview:starting];
    [canvas addSubview:ending];
}

- (UIView *)buildWarning:(NSString *)name withFrame:(CGRect)rect withSettings:(NSMutableDictionary *)sett
{
    UIView *warning = [[UIView alloc] initWithFrame:rect];
    [warning setBackgroundColor:[UIColor whiteColor]];
    [[warning layer] setCornerRadius:10.0];
    [[warning layer] setBorderWidth:1];
    [[warning layer] setBorderColor:[UIColor colorWithRed:150.0/255 green:150.0/255 blue:150.0/255 alpha:1.0].CGColor];
    [warning setTag:4];
    
    UILabel *copy = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 40)];
    [copy setText:name];
    [copy setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f]];
    [copy setTextColor:[UIColor blackColor]];
    [copy setTag:5];
    [warning addSubview:copy];
    
    onoff = [[UISwitch alloc] initWithFrame:CGRectMake(214, 12, 79, 27)];
    [onoff setOn:([[sett valueForKey:@"on"] isEqual:@"TRUE"]) ? TRUE : FALSE];
    [onoff setTag:6];
    [warning addSubview:onoff];
    [onoff addTarget:self action:@selector(switcherOnOff:) forControlEvents:UIControlEventValueChanged];
    
    slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 80, 280, 23)];
    [slider setEnabled:TRUE];
    [slider setMinimumValue:1];
    [slider setMaximumValue:40];
    [slider setThumbImage:[UIImage imageNamed:@"slider_knob.png"] forState:UIControlStateNormal];
    [slider setMinimumTrackImage:[UIImage imageNamed:@"slider_track.png"] forState:UIControlStateNormal];
    [slider setValue:[[sett valueForKey:@"value"] floatValue]];
    [slider setTag:2];
    [warning addSubview:slider];
    [slider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    
    UILabel *min = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, 30, 12)];
    [min setText:@"0:30"];
    [min setBackgroundColor:[UIColor clearColor]];
    [min setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    [min setTag:3];
    [warning addSubview:min];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(125, 58, 50, 22)];
    [label setText:[sett valueForKey:@"label"]];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:15.0f]];
    [label setTag:1];
    [warning addSubview:label];
    
    UILabel *max = [[UILabel alloc] initWithFrame:CGRectMake(255, 65, 40, 12)];
    [max setText:@"20:00"];
    [max setBackgroundColor:[UIColor clearColor]];
    [max setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    [max setTag:3];
    [warning addSubview:max];
    
    if(!onoff.isOn){
        [slider setEnabled:FALSE];
        [min setTextColor:[UIColor lightGrayColor]];
        [max setTextColor:[UIColor lightGrayColor]];
        [label setTextColor:[UIColor lightGrayColor]];
    }
    
    return warning;
}

- (IBAction)switcherOnOff:(id)sender {
    UISwitch *switcher = (UISwitch *)sender;
    for(UILabel *view in [sender superview].subviews){
        if([NSClassFromString(@"UISlider") isEqual:[view class]] && [view tag] == 2){
            if(switcher.isOn){
                [view setEnabled:TRUE];
            } else {
                [view setEnabled:FALSE];
                
            }
        }
        
        if([NSClassFromString(@"UILabel") isEqual:[view class]] && ([view tag] == 1 || [view tag] == 3)){
            if(switcher.isOn){
                [view setTextColor:[UIColor blackColor]];
            } else {
                [view setTextColor:[UIColor lightGrayColor]];    
            }
        }
    }
}

- (IBAction)sliderMoved:(id)sender {
    NSString *label;
    int numofsecs = 0;
    int mins = 0;
    int secs = 0;
    UISlider *movedslider = (UISlider *)sender;
    for(UILabel *view in [sender superview].subviews){
        if([NSClassFromString(@"UILabel") isEqual:[view class]] && [view tag] == 1){
            numofsecs = (int)[movedslider value] * 30;
            mins = (numofsecs / 60);
            secs = (numofsecs % 60);
            label = (secs == 0) ? [NSString stringWithFormat:@"%d:0%d",mins,secs] : [NSString stringWithFormat:@"%d:%d",mins,secs];
            [view setText:label];
        }
    }
}

@end
