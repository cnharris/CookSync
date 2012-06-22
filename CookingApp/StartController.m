//
//  StartController.m
//  CookingApp
//
//  Created by Christopher Harris on 4/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <stdlib.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "StartController.h"
#import "StartCell.h"

@implementation StartController

@synthesize canvas;
@synthesize dishes;
@synthesize noDishes;
@synthesize stopTimeFieldAndButtonContainer;
@synthesize stopTimeField;
@synthesize stopTime;
@synthesize largestDuration;
@synthesize picker;
@synthesize overlay;
@synthesize timeView;
@synthesize hoursBox;
@synthesize minsBox;
@synthesize ampmBox;
@synthesize labelTapGesture;
@synthesize addDish;
@synthesize startStop;
@synthesize startTimeButtonPressed;
@synthesize stopTimers;
@synthesize prepTimers;
@synthesize title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];   
    [self copyAllItemsFromConfigureTracker];
    stopTime = nil;
    stopTimers = nil;
    prepTimers = nil;
    canvas = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, 416)];
    canvas.contentSize = CGSizeMake(STD_WIDTH,self.view.frame.size.height-44);
    [canvas setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [self.view addSubview:canvas];
    
    [self setupNavBar];
    [self setupStopTimeFieldAndButtonContainer];
    //[self buildStopTime];
    [self buildStartStopButton];
    [self setupDishesAndNoDishes];
    [self buildDatePicker];
    
    //Give user a suggesting stopTime
    //Let them configure completely after
    largestDuration = [self findAndSetLargestDuration];
    [self addLargestTimeAsStopTimeFromCurrentTime:NULL];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self copyAllItemsFromConfigureTracker];
    if([ad.startTracker count] > 0){
        [dishes setHidden:NO];
        [noDishes setHidden:YES];
        [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_starttimers_button.png"]]];
        [startStop setUserInteractionEnabled:YES];
        [stopTimeFieldAndButtonContainer setUserInteractionEnabled:YES];
    } else {
        [dishes setHidden:YES];
        [noDishes setHidden:NO];
        [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_starttimersfaded_button.png"]]];
        [startStop setUserInteractionEnabled:NO];
        [stopTimeFieldAndButtonContainer setUserInteractionEnabled:NO];
    }
    [dishes reloadData];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [picker setMinimumDate:[NSDate date]];
    [picker setMaximumDate:[stopTime dateByAddingTimeInterval:(60*60*24)]];
}

- (void)setupNavBar
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navbar_start.png"]];
    [bgImageView setFrame:CGRectMake(0, 0, STD_WIDTH, 44)];
    
    CALayer *navLayer = self.navigationController.navigationBar.layer;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.navigationController.navigationBar.bounds);
    navLayer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    navLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    navLayer.shadowOffset = CGSizeMake(0, 2);
    navLayer.shadowRadius = 5;
    navLayer.shadowOpacity = 0.9;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.navigationController.navigationBar addSubview:bgImageView];
}

- (void)setupStopTimeFieldAndButtonContainer
{
    stopTimeFieldAndButtonContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 155)];
    [stopTimeFieldAndButtonContainer setBackgroundColor:[UIColor colorWithRed:229.0/255 green:229.0/255 blue:229.0/255 alpha:1.0]];
    [[stopTimeFieldAndButtonContainer layer] setCornerRadius:6.0];
    
    //Setup stop time clock UI
    [self setupTimeUI];
    
    UIView *stopTimeContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 94)];
    [stopTimeContainer setBackgroundColor:[UIColor whiteColor]];
    [[stopTimeContainer layer] setCornerRadius:6.0];
    [stopTimeFieldAndButtonContainer addSubview:stopTimeContainer];
    [canvas addSubview:stopTimeFieldAndButtonContainer];
    [stopTimeFieldAndButtonContainer addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadDatePicker:)]];
    
    UIView *hideTopCorners = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 10)];
    [hideTopCorners setBackgroundColor:[UIColor whiteColor]];
    [stopTimeFieldAndButtonContainer addSubview:hideTopCorners];
}

- (void)setupTimeUI
{
    timeView = [[UIView alloc] initWithFrame:CGRectMake(50, 14, 220, 69)];
    [[timeView layer] setZPosition:5];
    
    hoursBox = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 75, 69)];
    [hoursBox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_hoursmin_box.png"]]];
    [hoursBox setTextAlignment:UITextAlignmentCenter];
    [hoursBox setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:56.0f]];
    [hoursBox setTextColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0]];
    [timeView addSubview:hoursBox];
    
    UILabel *colon = [[UILabel alloc] initWithFrame:CGRectMake(78, 0, 6, 69)];
    [colon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_timecolon.png"]]];
    [timeView addSubview:colon];
    
    minsBox = [[UILabel alloc] initWithFrame:CGRectMake(87, 0, 75, 69)];
    [minsBox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_hoursmin_box.png"]]];
    [minsBox setTextAlignment:UITextAlignmentCenter];
    [minsBox setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:56.0f]];
    [minsBox setTextColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0]];
    [timeView addSubview:minsBox];
    
    ampmBox = [[UILabel alloc] initWithFrame:CGRectMake(166, 0, 54, 69)];
    [ampmBox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_ampm_box.png"]]];
    [ampmBox setTextAlignment:UITextAlignmentCenter];
    [ampmBox setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:28.0f]];
    [ampmBox setTextColor:[UIColor colorWithRed:99.0/255 green:99.0/255 blue:99.0/255 alpha:1.0]];
    [timeView addSubview:ampmBox];
    
    [stopTimeFieldAndButtonContainer addSubview:timeView];
}

- (void)copyAllItemsFromConfigureTracker
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    ad.startTracker = [ad.configureTracker mutableCopy];
}

- (void)checkForPresenceOfDishes
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([ad.startTracker count] == 0){
        [startStop setUserInteractionEnabled:NO];
        [stopTimeField setUserInteractionEnabled:NO];
        
        if(!addDish){
            addDish = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 50)];
            [addDish setText:@"Click the '+' sign to add a dish."];
            [addDish setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
            [[addDish layer] setCornerRadius:10.0f];
            [canvas addSubview:addDish];
        }
    }
}

- (void)buildDatePicker
{
    overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, 367)];
    [overlay setHidden:YES];
    [overlay setBackgroundColor:[UIColor blackColor]];
    [[overlay layer] setOpacity:0.4];
    [[overlay layer] setZPosition:2];
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 156, STD_WIDTH, 216)];
    [picker setHidden:YES];
    [[picker layer] setZPosition:3];
    [canvas addSubview:overlay];
    [canvas addSubview:picker];
    [picker addTarget:self action:@selector(pickerChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)startStopTimers:(id)sender
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIButton *senderButton = (UIButton *)sender;
    
    ad.timerRunning = NO;
    ad.allDone = NO;
    [self enableDishesSettingsTabs];
    
    if([senderButton tag] == 0){
        [self buildAndStartTimers];
        if(![self checkTimeValidity]){
            [self buildAlertAndStopExecution];
            [self stopAllTimers];
            [self setStartButtonStart];
        } else {
            ad.timerRunning = YES;
            [self buildNotifications];
            [self setStartButtonStop];
            [self disableDishesSettingsTabs];
        }
    } else if([senderButton tag] == 1) {
        [self stopAllTimers];
        [self setStartButtonStart];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)setStartButtonStart
{
    [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_starttimers_button.png"]]];
    [startStop setTag:0];
    [[startStop layer] setBorderColor:[UIColor colorWithRed:0.0/255.0 green:221.0/255.0 blue:0.0/255 alpha:1.0].CGColor];
}

- (void)setStartButtonStop
{
    [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_pausetimers_button.png"]]];
    [startStop setTag:1];
    [[startStop layer] setBorderColor:[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0.0/255 alpha:1.0].CGColor];
}

- (void)setStartButtonReset
{
    [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_resettimers_button.png"]]];
    [startStop setTag:2];
    [[startStop layer] setBorderColor:[UIColor colorWithRed:255.0/255 green:204.0/255 blue:0.0/255 alpha:1.0].CGColor];
}

- (int)prepTimeSeconds
{
    return 60 * BUFFER_PREP;
}

- (int)futureSeconds
{
    return 300;
}

- (void)enableDishesSettingsTabs
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *dishesTab = [tabBar.items objectAtIndex:0];
    UITabBarItem *settingsTab = [tabBar.items objectAtIndex:2];
    [dishesTab setEnabled:YES];
    [settingsTab setEnabled:YES];
}

- (void)disableDishesSettingsTabs
{
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *dishesTab = [tabBar.items objectAtIndex:0];
    UITabBarItem *settingsTab = [tabBar.items objectAtIndex:2];
    [dishesTab setEnabled:NO];
    [settingsTab setEnabled:NO];
}

- (void)buildAlertAndStopExecution
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSString *msg = @"Oops, all your dishes will not be ready by this time. Please select a later time.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [self.view addSubview:alert];
    [alert show];
}

//Return false is not enough time to from prepTime to stopTime
- (BOOL)checkTimeValidity
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDate *stopTimeMinusStartTime = nil;
    NSDate *stopTimeMinusStartTimeAndPrepTime = nil;
    NSDate *prepTime = nil;
    
    for(DishController *cell in ad.startTracker){
        
        stopTimeMinusStartTime = [self getNsdateFromTimeMinusDuration:stopTime withStringDuration:[cell duration]];
        stopTimeMinusStartTimeAndPrepTime = [stopTimeMinusStartTime dateByAddingTimeInterval:-[self prepTimeSeconds]];
        prepTime = [cell prepTime];
        
        NSLog(@"compare: %@",stopTimeMinusStartTime);
        NSLog(@"prep: %@",[cell prepTime]);
        NSLog(@"stoptime: %@",stopTime);
        
        NSLog(@"Results: %d",[stopTimeMinusStartTime compare:prepTime]);
        
        if([stopTimeMinusStartTime compare:prepTime] != 1){
            return FALSE;
        }
    }
    return TRUE;
}

- (void)stopAllTimers
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (id obj in prepTimers){
        if(obj != nil){
            [obj invalidate];
        }
    }
    
    for (id obj in stopTimers){
        if(obj != nil){
            [obj invalidate];
        }
    }
    
    for(DishController *cell in ad.startTracker){
        [cell setTimeLeftAction:@""];
        [cell setTimeLeft:@""];
    }
        
    stopTimers = nil;
    prepTimers = nil;
    [dishes reloadData];
    
}

- (void)buildAndStartTimers
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    startTimeButtonPressed = [[NSDate alloc] init];
    prepTimers = [[NSMutableArray alloc] init];
    stopTimers = [[NSMutableArray alloc] init];
    NSTimer *prepTimer = nil;
    NSTimer *stopTimer = nil;
    int count = 0;
    
    for(DishController *cell in ad.startTracker){
        NSDate *prepTimeStart = [NSDate date];
        NSDate *startTime = [self getNsdateFromTimeMinusDuration:stopTime withStringDuration:[cell duration]];
        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                                         [cell title],@"title",
                                         [NSString stringWithFormat:@"%d",count],@"tag",
                                         prepTimeStart,@"prepTimeStart",
                                         startTime,@"startTime",
                                         nil];
        NSLog(@"START TIME: %@",startTime);
        NSLog(@"PREP TIME: %@",prepTimeStart);
        [cell setStartTime:startTime];
        [cell setPrepTime:prepTimeStart];
        
        prepTimer = [[NSTimer alloc] initWithFireDate:prepTimeStart interval:1.0 target:self selector:@selector(prepTimeCallback:) userInfo:userInfo repeats:YES];
        stopTimer = [[NSTimer alloc] initWithFireDate:startTime interval:1.0 target:self selector:@selector(stopTimeCallback:) userInfo:userInfo repeats:YES];
        [prepTimers addObject:prepTimer];
        [stopTimers addObject:stopTimer];
        
        [[NSRunLoop currentRunLoop] addTimer:prepTimer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] addTimer:stopTimer forMode:NSRunLoopCommonModes];
        count++;
    }
}

- (void)buildNotifications
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for(DishController *cell in ad.startTracker){
        //Reminder prepTime
        NSDate *startTime = [self getNsdateFromTimeMinusDuration:stopTime withStringDuration:[cell duration]];
        [self aboutToStartNotification:startTime withTitle:[cell title]];
        
        //PrepTimeOver
        NSString *prepOver = [NSString stringWithFormat:@"Start %@ now!",[cell title]];
        [self setupNotification:[startTime dateByAddingTimeInterval:-1] withMessage:prepOver];
    }
    
    //Reminder prepTime
    [self aboutToStopNotification:stopTime];
    
    //PrepTimeOver
    [self setupNotification:stopTime withMessage:@"Take all dishes out!"];
}

- (void)aboutToStartNotification:(NSDate *)datetime withTitle:(NSString *)dishTitle
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *starting = [defaults objectForKey:@"startingNotification"];
    NSString *isOn = [starting objectForKey:@"on"];
    if([isOn compare:@"TRUE"] == 0){
        int seconds = [[starting objectForKey:@"value"] integerValue] * 30;
        NSString *secondsStr = [self convertSecondsToDateTimeString:seconds];
        NSString *prepReminder = [NSString stringWithFormat:@"Start %@ in %@",dishTitle,secondsStr];
        [self setupNotification:[datetime dateByAddingTimeInterval:-(seconds)] withMessage:prepReminder];
    }
}

- (NSString *)convertSecondsToDateTimeString:(int)seconds
{
    NSString *minstr = [[NSString alloc] initWithFormat:@"%d",seconds/60];
    NSString *secstr;
    int remaining_seconds = fmod(seconds,60);
    
    if(remaining_seconds < 10){
        secstr = [[NSString alloc] initWithFormat:@"0%d",remaining_seconds];
    } else {
        secstr = [[NSString alloc] initWithFormat:@"%d",remaining_seconds];
    }
    
    return [minstr stringByAppendingFormat:@":%@",secstr];
}

- (void)aboutToStopNotification:(NSDate *)datetime
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *ending = [defaults objectForKey:@"endingNotification"];
    NSString *isOn = [ending objectForKey:@"on"];
    if([isOn compare:@"TRUE"] == 0){
        int seconds = [[ending objectForKey:@"value"] integerValue] * 30;
        NSString *secondsStr = [self convertSecondsToDateTimeString:seconds];
        NSString *prepReminder = [NSString stringWithFormat:@"Take out all dishes in %@",secondsStr];
        [self setupNotification:[datetime dateByAddingTimeInterval:-(seconds)] withMessage:prepReminder];
    }
}

- (NSMutableDictionary *)differenceBetweenTwoNSDates:(NSDate *)date1 withDate:(NSDate *)date2
{
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSMutableDictionary *timeParts = [[NSMutableDictionary alloc] initWithCapacity:3];
    unsigned int unitFlags = NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit;
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date1  toDate:date2  options:0];
    [timeParts setValue:[NSString stringWithFormat:@"%d",[breakdownInfo second]] forKey:@"seconds"];
    [timeParts setValue:[NSString stringWithFormat:@"%d",[breakdownInfo minute]] forKey:@"minutes"];
    [timeParts setValue:[NSString stringWithFormat:@"%d",[breakdownInfo hour]] forKey:@"hours"];
    
    NSLog(@"Break down: %dsec %dmin %dhours",[breakdownInfo second], [breakdownInfo minute], [breakdownInfo hour]);
    return timeParts;
}

- (void)setupNotification:(NSDate *)date withMessage:(NSString *)msg
{
    //Don't setup notification if reminder datetime has passed
    if([self dateTimeHasPassed:date] == NO){
        return;
    }
    
    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
    if(notifyAlarm){
        notifyAlarm.fireDate = date;
        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
        notifyAlarm.repeatInterval = 0;
        notifyAlarm.soundName = @"bell";
        notifyAlarm.alertBody = msg;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifyAlarm];
    }
    
}

- (BOOL)dateTimeHasPassed:(NSDate *)date
{
    if([date compare:[NSDate date]] == NSOrderedAscending){
        return NO;
    }
    return YES;
}

- (void)prepTimeCallback:(NSTimer *)timer
{
    NSDictionary *timeLeftHash = [self differenceBetweenTwoNSDates:[NSDate date] withDate:[timer.userInfo objectForKey:@"startTime"]];
    int hours = [[timeLeftHash objectForKey:@"hours"] integerValue];
    int mins = [[timeLeftHash objectForKey:@"minutes"] integerValue];
    int secs = [[timeLeftHash objectForKey:@"seconds"] integerValue];
    
    if(hours <= 0 && mins <= 0 && secs <= 0){
        [timer invalidate];
        return;
    }

    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DishController *cell = [ad.startTracker objectAtIndex:[[timer.userInfo objectForKey:@"tag"] integerValue]];
    [cell setTimeLeftAction:@"Starts in"];
    [cell setTimeLeft:[NSString stringWithFormat:@"%@",[self formattedTime:timeLeftHash]]];
    [dishes reloadData];
}

- (void)stopTimeCallback:(NSTimer *)timer
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *timeLeftHash = [self differenceBetweenTwoNSDates:[NSDate date] withDate:stopTime];
    DishController *cell = [ad.startTracker objectAtIndex:[[timer.userInfo objectForKey:@"tag"] integerValue]];
    int hours = [[timeLeftHash objectForKey:@"hours"] integerValue];
    int mins = [[timeLeftHash objectForKey:@"minutes"] integerValue];
    int secs = [[timeLeftHash objectForKey:@"seconds"] integerValue];
    
    [cell setTimeLeftAction:@"Finishes in"];
    [cell setTimeLeft:[NSString stringWithFormat:@"%@",[self formattedTime:timeLeftHash]]];
    
    //SETTING    
    if(hours <= 0 && mins <= 0 && secs <= 0){
        ad.allDone = YES;
        [timer invalidate];
        [self stopAllTimers];
        [dishes reloadData];
        return;
    }
    [dishes reloadData];
}

- (NSString *)formattedTime:(NSDictionary *)timeLeftHash
{
    NSString *output;
    NSString *hoursStr;
    NSString *minsStr;
    NSString *secsStr;
    int hours = [[timeLeftHash objectForKey:@"hours"] integerValue];
    int mins = [[timeLeftHash objectForKey:@"minutes"] integerValue];
    int secs = [[timeLeftHash objectForKey:@"seconds"] integerValue];
    
    hoursStr = (hours < 10) ? [NSString stringWithFormat:@"0%d",hours] : [NSString stringWithFormat:@"%d",hours];
    minsStr = (mins < 10) ? [NSString stringWithFormat:@"0%d",mins] : [NSString stringWithFormat:@"%d",mins];
    secsStr = (secs < 10) ? [NSString stringWithFormat:@"0%d",secs] : [NSString stringWithFormat:@"%d",secs];
    
    if(hours == 0){
        output = [NSString stringWithFormat:@"%@:%@",minsStr,secsStr];
    } else {
        output = [NSString stringWithFormat:@"%@:%@:%@",hoursStr,minsStr,secsStr];
    }
    return output;
}

- (void)warningSound
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(![ad.audioController.bellPlayer isPlaying]){
        [ad.audioController playBell];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [ad.audioController stopMarimba];
}

- (IBAction)pickerChanged:(id)sender
{
    stopTime = [picker date];
    //NSLog(@"DATE IS: %@",stopTime];
    //[stopTimeField setText:[NSString stringWithFormat:@"%@",[self nsdateToNsstring:stopTime withFormat:@"h:mm a"]]];
    [self setHoursMinsAmpmBoxes:stopTime];
}

- (void)setHoursMinsAmpmBoxes:(NSDate *)date
{
    [hoursBox setText:[NSString stringWithFormat:@"%@",[self nsdateToNsstring:date withFormat:@"h"]]];
    [minsBox setText:[NSString stringWithFormat:@"%@",[self nsdateToNsstring:date withFormat:@"mm"]]];
    [ampmBox setText:[NSString stringWithFormat:@"%@",[self nsdateToNsstring:date withFormat:@"a"]]];
}

- (IBAction)hidePicker:(id)sender
{
    [overlay setHidden:YES];
    [picker setHidden:YES];
    self.navigationItem.rightBarButtonItem = nil;
}

- (IBAction)loadDatePicker:(id)sender
{ 
    [overlay setHidden:NO];
    [picker setHidden:NO];
    [self setHoursMinsAmpmBoxes:[picker date]];
    
    UIImage *doneIcon = [UIImage imageNamed:@"nav_done_icon.png"];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:doneIcon forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    doneButton.frame = CGRectMake(0.0, 0.0, doneIcon.size.width, doneIcon.size.height);
    [doneButton addTarget:self action:@selector(hidePicker:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
}

- (void)addLargestTimeAsStopTimeFromCurrentTime:(NSInteger *)buffer
{
    NSInteger hours = [[largestDuration objectForKey:@"hours"] integerValue];
    NSInteger mins = [[largestDuration objectForKey:@"mins"] integerValue];
    NSInteger seconds = (60 * (BUFFER_PREP + mins + (60 * hours)));
    
    //setting
    stopTime = [[NSDate date] dateByAddingTimeInterval:seconds];
    NSLog(@"stop time: %@",stopTime);
    [self setHoursMinsAmpmBoxes:[picker date]];
}

- (NSDate *)getCurrentTime
{
    NSDate *sourceDate = [NSDate date];
    NSTimeZone *sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone *destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    NSDate *destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
    return destinationDate;
}

- (NSDictionary *)findAndSetLargestDuration
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary *duration = NULL;
    NSDictionary *largest = NULL;
    for(DishController *cell in ad.startTracker){
        duration = [self parseDuration:[cell duration]];
        largest = [self compareHashTimes:largest withTime:duration];
    }
    return largest;
}

- (void)buildStartStopButton
{
    if(!startStop){
        startStop = [[UIButton alloc] initWithFrame:CGRectMake(10, 100, 300, 51)];
        [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_starttimers_button.png"]]];
        [startStop setTag:0];
        [canvas addSubview:startStop];
        [startStop addTarget:self action:@selector(startStopTimers:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)buildStopTime
{
    if(!stopTimeField){
        stopTimeField = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 300, 60)];
        [[stopTimeField layer] setCornerRadius:10];
        [stopTimeField setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:24.0f]];
        [stopTimeField setTextAlignment:UITextAlignmentCenter];
        [stopTimeField setUserInteractionEnabled:YES];
    }
}

- (NSMutableDictionary *)parseDuration:(NSString *)duration
{
    NSMutableDictionary *hsh = [[NSMutableDictionary alloc] init];    
    NSArray *hoursmins = [duration componentsSeparatedByString: @", "];
    NSString *hours = [hoursmins objectAtIndex:0];
    NSString *mins = [hoursmins objectAtIndex:1];
    NSArray *hoursAndLabel = [hours componentsSeparatedByString: @" "];
    NSArray *minsAndLabel = [mins componentsSeparatedByString: @" "];
    [hsh setObject:[hoursAndLabel objectAtIndex:0] forKey:@"hours"];
    [hsh setObject:[minsAndLabel objectAtIndex:0] forKey:@"mins"];
    return hsh;
}

- (NSDictionary *)compareHashTimes:(NSDictionary *)time1 withTime:(NSDictionary *)time2
{
    if(time1 == NULL && time2 == NULL){
        return NULL;
    } else if(time1 == NULL){
        return time2;
    } else if(time2 == NULL){
        return time1;
    }

    if([self getTimeMinutes:time1] >= [self getTimeMinutes:time2]){
        return time1;
    }
    return time2;
}

- (NSInteger *)getTimeMinutes:(NSDictionary *)time
{
    return (NSInteger *)(([[time objectForKey:@"hours"] integerValue] * 60) + [[time objectForKey:@"mins"] integerValue]);
}

- (NSString *)nsdateToNsstring:(NSDate *)date withFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}

- (NSDate *)getNsdateFromTimeMinusDuration:(NSDate *)localStopTime withDuration:(int)duration
{
    if(!localStopTime){
        localStopTime = stopTime;
    }
    return [localStopTime dateByAddingTimeInterval:-(duration)];
}
              
- (NSDate *)getNsdateFromTimeMinusDuration:(NSDate *)localStopTime withStringDuration:(NSString *)duration
{
    //NSLog(@"the stop: %@",localStopTime);
    if(!localStopTime){
        localStopTime = stopTime;
    }
    
    int seconds = 0;
    NSDictionary *timeParts = [self parseDuration:duration];
    seconds += [[timeParts objectForKey:@"hours"] integerValue] * 60 * 60;
    seconds += [[timeParts objectForKey:@"mins"] integerValue] * 60;
    return [localStopTime dateByAddingTimeInterval:-(seconds)];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [dishes setFrame:CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height-160)];
    return ad.startTracker.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (UIView *)sectionFiller {
    static UILabel *emptyLabel = nil;
    if (!emptyLabel) {
        emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        emptyLabel.backgroundColor = [UIColor clearColor];
    }
    return emptyLabel;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [self sectionFiller];
}

- (UITableViewCell*)cellType:(NSString*)cellId
{ 
    StartCell *cell = NULL;
    if(cellId == @"StartCell")
    {
        cell = [[StartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 1; 
        cell.detailTextLabel.numberOfLines = 1;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    return CELL_HEIGHT;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    DishController *data = [ad.startTracker objectAtIndex:indexPath.row];
    NSInteger hours = 0,mins = 0;
    NSDictionary *dataHsh = NULL;
    NSDate *date;    
    
    static NSString *cellId = @"multiLineWithSubtitle";
    StartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {        
        cell = [[StartCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        [cell setTag:indexPath.row];
    }
    
    [[cell imageView] setImage:[UIImage imageNamed:[data icon]]];
    [[cell textLabel] setText:[data title]];
    [[cell detailTextLabel] setText:[data duration]];
    [[cell timeLeftAction] setText:[data timeLeftAction]];
    [[cell timeLeft] setText:[data timeLeft]];
    
    if(ad.allDone){
        [[cell doneIcon] setHidden:NO];
        [startStop setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_starttimers_button.png"]]];
        [startStop setTag:0];
    } else {
        [[cell doneIcon] setHidden:YES];
    }
    
    
    dataHsh = [self parseDuration:[data duration]];
    hours = [[dataHsh objectForKey:@"hours"] integerValue];
    mins = [[dataHsh objectForKey:@"mins"] integerValue];
    date = [stopTime dateByAddingTimeInterval:-[self secondsToMinutes:hours withMinutes:mins]];
    return cell;
}

- (int)secondsToMinutes:(int)hours withMinutes:(int)mins
{
    return ((60 * 60 * hours)+(60 * mins));
}

- (int)secondsToMinutes:(NSString *)duration
{
    NSMutableArray *validValues = [[NSMutableArray alloc] initWithCapacity:2];
    NSArray *durationVals1 = [duration componentsSeparatedByString:@", "];
    for(NSString *str in durationVals1){
        NSArray *durationVals2 = [str componentsSeparatedByString:@" "];
        [validValues addObject:[durationVals2 objectAtIndex:0]];
    }
    
    int tduration = (60 * 60 * [[validValues objectAtIndex:0] integerValue]) + (60 * [[validValues objectAtIndex:1] integerValue]);
    return tduration;
}

- (void)setupDishesAndNoDishes
{
    dishCoords dishAttrs;
    dishAttrs.x = 0;
    dishAttrs.y = 0;
    dishAttrs.w = STD_WIDTH;
    dishAttrs.h = 100;
    
    dishes = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) style:UITableViewCellStyleDefault];
    [dishes setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    [dishes setSeparatorColor:[UIColor colorWithRed:64.0/255 green:122.0/255 blue:145.0/255 alpha:0.9]];
    [dishes setDelegate:(id)self];
    [dishes setDataSource:(id)self];
    [canvas addSubview:dishes];
    [dishes setHidden:YES];
    
    noDishes = [[UILabel alloc] initWithFrame:CGRectMake(0, 220, 320, 50)];
    [noDishes setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"start_nodishes.png"]]];
    [noDishes setNumberOfLines:2];
    [canvas addSubview:noDishes];
    [noDishes setHidden:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
