//
//  SettingsController.m
//  CookingApp
//
//  Created by Christopher Harris on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsController.h"

@implementation SettingsController

@synthesize settings;
@synthesize viewHeader;
@synthesize data;

- (id)init
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self buildNavBar:@"settings"];
    [self.view setBackgroundColor:defaultBackground];
    [self buildSettingsData];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"RELOAD!!!!");
    [super viewWillAppear:YES];
    [settings reloadData];
}

- (void)buildSettingsData
{
    data = [[NSMutableArray alloc] initWithObjects:@"Notifications", @"About", nil];
    settings = [[UITableView alloc] initWithFrame:CGRectMake(10, 20, 300, 89) style:UITableViewCellStyleDefault];
    [[settings layer] setBackgroundColor:[UIColor whiteColor].CGColor];
    [[settings layer] setCornerRadius:6.0];
    [[settings layer] setBorderWidth:1.0];
    [[settings layer] setBorderColor:[UIColor colorWithRed:171.0/255 green:171.0/255 blue:171.0/255 alpha:1.0].CGColor];
    [settings setSeparatorColor:[UIColor colorWithRed:171.0/255 green:171.0/255 blue:171.0/255 alpha:1.0]];
    [settings setDelegate:self];
    [settings setDataSource:self];
    [self.view addSubview:settings];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"singleLine"];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"singleLine"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        [[cell textLabel] setText:[data objectAtIndex:indexPath.row]];
        [[cell textLabel] setNumberOfLines:1];
        [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:16.0f]];
        [cell setTag:indexPath.row];
    }
    
    //Only using 1 reminder at this point
    NSLog(@"Index row: %d",indexPath.row);
    if(indexPath.row == 0){
        [[cell imageView] setImage:[UIImage imageNamed:@"icon_speaker.png"]];
    } else if(indexPath.row == 1){
        [[cell imageView] setImage:[UIImage imageNamed:@"icon_i.png"]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0){
        AD.settingsdetailController.section = @"notifications";
        [AD.settingsdetailController.navigationItem setTitle:@"Notifications"];
    } else {
        AD.settingsdetailController.section = @"about";
        [AD.settingsdetailController.navigationItem setTitle:@"About"];
    }
    
    [AD.settingsdetailController.navigationItem setHidesBackButton:YES];
    [self.navigationController pushViewController:AD.settingsdetailController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    return CELL_HEIGHT - 25;
}

@end
