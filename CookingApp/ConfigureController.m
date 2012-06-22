//
//  ConfigureController.m
//  OvenApp
//
//  Created by Christopher Harris on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "UtilController.h"
#import "ConfigureController.h"
#import "DishdetailController.h"
#import "DishController.h"
#import "StartCell.h"


@implementation ConfigureController

@synthesize instructions;
@synthesize canvas;
@synthesize dishes;
@synthesize dishLabels;
@synthesize amountOfDishes;
@synthesize endDateTime;
@synthesize welcomeView;

- (id)init
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCustomTabbar];
    [self setBackground:self.view withBackground:nil];
    [self setupNavButtons];
    [self buildNavBar:@"dishes"];
    [self setupWelcomeMenu];
    [self setupDishes];
    [self enableNavigationBarButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    [self enableNavigationBarButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Appear");
    [super viewWillAppear:NO];
    [self toggleWelcomeAndDishViews];
    [self resizeDishesTable];
    [dishes reloadData];
    //Reload all dish table entries after edits
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [dishes setEditing:NO animated:YES];
}

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

- (void)toggleWelcomeAndDishViews
{
    if([AD.configureTracker count] == 0){
        [welcomeView setAlpha:0.0];
        [welcomeView setHidden:NO];
        [UIView animateWithDuration:0.30 animations:^{
            welcomeView.alpha = 1.0;
        }];
        [dishes setHidden:YES];
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        [welcomeView setAlpha:1.0];
        [UIView animateWithDuration:0.30 animations:^{
            welcomeView.alpha = 0.0;
        }];
        [welcomeView setHidden:YES];
        [dishes setHidden:NO];
        [dishes reloadData];
        if([self dishesExist]){
            self.navigationItem.leftBarButtonItem = editBarButton;
            [editBarButton setTag:0];
        }
    }
}

- (void)setupDishes
{
    dishCoords dishAttrs;
    dishAttrs.x = 0;
    dishAttrs.y = 0;
    dishAttrs.w = STD_WIDTH;
    dishAttrs.h = 100;
    
    dishes = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    [dishes setDelegate:(id)self];
    [dishes setDataSource:(id)self];
    [dishes setBackgroundView:[self dishesBackground]];
    [[dishes layer] setMasksToBounds:YES];
    [[dishes layer] setShadowColor:[UIColor blackColor].CGColor];
    [[dishes layer] setShadowOffset:CGSizeMake(1.0f, 1.0f)];
    [[dishes layer] setShadowOpacity:0.7];
    [[dishes layer] setShadowRadius:2];
    [[dishes layer] setMasksToBounds:NO];
    [dishes setSeparatorColor:[UIColor colorWithRed:64.0/255 green:122.0/255 blue:145.0/255 alpha:0.9]];
    [self.view addSubview:dishes];
}

- (void)setupWelcomeMenu
{
    UIImageView *welcome = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcome.png"]];
    [welcome setFrame:CGRectMake(0, -50, STD_WIDTH, 480)];
    [welcome setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    welcomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, STD_HEIGHT)];
    [welcomeView setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    [welcomeView addSubview:welcome];
    
    UIButton *plusIcon = [[UIButton alloc] initWithFrame:CGRectMake(125, 260, 70, 65)];
    [plusIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome_plus_icon.png"]]];
    [plusIcon addTarget:self action:@selector(showAddDishView:) forControlEvents:UIControlEventTouchUpInside];
    [welcomeView addSubview:plusIcon];
    
    [welcomeView setHidden:YES];
    [self.view addSubview:welcomeView];
}

- (UIImageView *)dishesBackground
{
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, STD_HEIGHT)];
    [bgImg setImage:backgroundImage];
    return bgImg;
}

- (void)enableNavigationBarButtons
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = nil;
    if([self dishesExist]){
        [self.navigationItem setLeftBarButtonItem:editBarButton];
    }
    [self.navigationItem setRightBarButtonItem:plusBarButton];
}

- (IBAction)showAddDishView:(id)sender
{
    UINavigationController *navCon = [[UINavigationController alloc] initWithRootViewController:AD.newdishController];
    [navCon setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:navCon animated:YES];
}

- (IBAction)hideAddDishView:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)resizeDishesTable
{
    [dishes setFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height)];
}

- (IBAction)toggleEdit:(id)sender
{
    if(dishes.isEditing == YES){
        [dishes setEditing:NO animated:YES];
        self.navigationItem.leftBarButtonItem = editBarButton;
    } else {
        [dishes setEditing:YES animated:YES];
        self.navigationItem.leftBarButtonItem = doneBarButton;
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animate
{
    [super setEditing:editing animated:animate];
    [dishes setEditing:editing animated:YES];
    if(!editing){
        [self resizeDishesTable];
    }
}

- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        [AD.configureTracker removeObjectAtIndex:indexPath.row];
        [dishes deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [dishes setContentSize:CGSizeMake(STD_WIDTH, dishes.contentSize.height - CELL_HEIGHT)];
        [self toggleWelcomeAndDishViews];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [dishes setFrame:CGRectMake(0, 0, STD_WIDTH, 416)];
    [dishes setContentSize:CGSizeMake(STD_WIDTH, CELL_HEIGHT*[AD.configureTracker count])];
    return AD.configureTracker.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static UILabel *emptyLabel = nil;
    if (!emptyLabel) {
        emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        emptyLabel.backgroundColor = [UIColor clearColor];
    }
    return emptyLabel;
}

- (UIBarButtonItem *)leftBarButtonItem
{
    if(self.dishes.editing){
        return doneBarButton;
    }
    return editBarButton;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *ad = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString *cellId = @"multiLineWithSubtitle";
    StartCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    DishController *data = [ad.configureTracker objectAtIndex:indexPath.row];
    if (cell == nil) {        
        cell = (StartCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.textLabel.numberOfLines = 1; 
        cell.detailTextLabel.numberOfLines = 1;
    }
    
    //Dish Icon
    [[cell imageView] setImage:[UIImage imageNamed:[data icon]]];
    
    //Dish Name
    [[cell textLabel] setText:[data title]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:22.0f]];
    [cell setTag:indexPath.row];
    
    //Dish duration
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Cook Time: %@",[data duration]]];
    
    //Edit accessory icon
    UIImage *indicatorImage = [UIImage imageNamed:@"edit_icon"];
    cell.accessoryView =[[UIImageView alloc] initWithImage:indicatorImage];
    
    return cell;
}

// Override to support row selection in the table view.
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//Navigation logic may go here. Create and push another view controller.
    if(self.editing){
        NSLog(@"edit!");
    } else {
        AD.dishDetailController.title = [NSString stringWithFormat:@"Dish %d",indexPath.row+1];
        AD.dishDetailController.did = indexPath.row;
        //to push the UIView.
        [self.navigationController pushViewController:AD.dishDetailController animated:YES];
    }
}

- (void)tableview:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *theCellSelected = [dishes cellForRowAtIndexPath:0];
    DishController *temp = [AD.configureTracker objectAtIndex:0];
    theCellSelected.textLabel.text = [temp title];
}

@end
