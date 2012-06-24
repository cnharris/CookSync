//
//  UtilController.m
//  CookSync
//
//  Created by Christopher Harris on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UtilController.h"
#import "AppDelegate.h"

@implementation UtilController

@synthesize defaultBackground;
@synthesize defaultBackgroundImage;
@synthesize editBarButton;
@synthesize doneBarButton;
@synthesize plusBarButton;
@synthesize cancelBarButton;
@synthesize favoritesBarButton;
@synthesize editButton;
@synthesize doneButton;
@synthesize plusButton;
@synthesize cancelButton;
@synthesize backButton;
@synthesize favoritesButton;

- (id)init
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    defaultBackgroundImage = [UIImage imageNamed:@"background"];
    defaultBackground = [UIColor colorWithPatternImage:defaultBackgroundImage];
    [self setupNavButtons];
	// Do any additional setup after loading the view.
}

- (void)setupNavButtons
{
    UIImage *editIcon = [UIImage imageNamed:@"nav_edit_icon.png"];
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:editIcon forState:UIControlStateNormal];
    [[editButton layer] setZPosition:10];
    editButton.showsTouchWhenHighlighted = YES;
    editButton.frame = CGRectMake(0.0, 0.0, editIcon.size.width, editIcon.size.height);
    editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    UIImage *doneIcon = [UIImage imageNamed:@"nav_done_icon.png"];
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:doneIcon forState:UIControlStateNormal];
    [[doneButton layer] setZPosition:10];
    doneButton.showsTouchWhenHighlighted = YES;
    doneButton.frame = CGRectMake(0.0, 0.0, doneIcon.size.width, doneIcon.size.height);
    doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIImage *plusIcon = [UIImage imageNamed:@"nav_plus_icon.png"];
    plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setImage:plusIcon forState:UIControlStateNormal];
    [[plusButton layer] setZPosition:10];
    plusButton.showsTouchWhenHighlighted = YES;
    plusButton.frame = CGRectMake(0.0, 0.0, plusIcon.size.width, plusIcon.size.height);
    plusBarButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    
    UIImage *cancelIcon = [UIImage imageNamed:@"nav_cancel_left_icon.png"];
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:cancelIcon forState:UIControlStateNormal];
    [[cancelButton layer] setZPosition:10];
    cancelButton.showsTouchWhenHighlighted = YES;
    cancelButton.frame = CGRectMake(0.0, 0.0, cancelIcon.size.width, cancelIcon.size.height);
    [cancelButton addTarget:self action:@selector(cancelDish:) forControlEvents:UIControlEventTouchUpInside];
    cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    
    UIImage *backIcon = [UIImage imageNamed:@"nav_back_left_icon.png"];
    backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backIcon forState:UIControlStateNormal];
    [[backButton layer] setZPosition:10];
    backButton.showsTouchWhenHighlighted = YES;
    backButton.frame = CGRectMake(0.0, 0.0, backIcon.size.width, backIcon.size.height);
    backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UIImage *favoritesIcon = [UIImage imageNamed:@"nav_favorites_icon.png"];
    favoritesButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoritesButton setImage:favoritesIcon forState:UIControlStateNormal];
    [[favoritesButton layer] setZPosition:10];
    favoritesButton.showsTouchWhenHighlighted = YES;
    favoritesButton.frame = CGRectMake(0.0, 0.0, favoritesIcon.size.width, favoritesIcon.size.height);
    favoritesBarButton = [[UIBarButtonItem alloc] initWithCustomView:favoritesButton];
}

- (void)clearBarButtonActions
{
    [editButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [doneButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [plusButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
    [cancelButton removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
}

- (BOOL)dishesExist
{
    NSLog(@"DISH COUNT: %d",[AD.configureTracker count]);
    if([AD.configureTracker count] > 0){
        return YES;
    }
    return NO;
}

- (UIScrollView *)buildCanvasWithX:(float)x withY:(float)y withWidth:(float)width withHeight:(float)height
{
    UIScrollView *canvas = [[UIScrollView alloc] initWithFrame:CGRectMake(x,y,width,height)];
    canvas.contentSize = CGSizeMake(STD_WIDTH,self.view.frame.size.height-44);
    [canvas setBackgroundColor:defaultBackground];
    return canvas;
}

- (void)buildNavBar:(NSString *)type
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"navbar_%@",type]]];
    [bgImageView setFrame:CGRectMake(0, 0, STD_WIDTH, 44)];
    [[bgImageView layer] setZPosition:1];
    
    CALayer *navLayer = self.navigationController.navigationBar.layer;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.navigationController.navigationBar.bounds);
    navLayer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    navLayer.shadowColor = [UIColor darkGrayColor].CGColor;
    navLayer.shadowOffset = CGSizeMake(0, 3);
    navLayer.shadowRadius = 5;
    navLayer.shadowOpacity = 1.0;
    
    // Default clipsToBounds is YES, will clip off the shadow, so we disable it.
    self.navigationController.navigationBar.clipsToBounds = NO;
    [self.navigationController.navigationBar addSubview:bgImageView];
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

// Start UITableView Delegate Methods //

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 
    return CELL_HEIGHT;
}

// End UITableView Delegate Methods //

- (void)loadCustomTabbar
{
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"tab_dishes_selected.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"tab_dishes.png"];
    
    UIImage *selectedImage1 = [UIImage imageNamed:@"tab_start_selected.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"tab_start.png"];
    
    UIImage *selectedImage2 = [UIImage imageNamed:@"tab_settings_selected.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"tab_settings.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    [tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar.png"]];
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    [item0 setTitle:@"Dishes"];
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    [item1 setTitle:@"Start"];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    [item2 setTitle:@"Settings"];
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
