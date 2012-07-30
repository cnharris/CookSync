//
//  ConfigureController.m
//  OvenApp
//
//  Created by Christopher Harris on 3/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigureController.h"

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
    [self.view setBackgroundColor:defaultBackground];
    [self buildNavBar:@"dishes"];
    [self setupWelcomeMenu];
    [self setupDishes];
    [self enableNavigationBarButtons];
    
    [self clearBarButtonActions];
    [self setupBarButtonActions];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Appear");
    [super viewWillAppear:NO];
    [self showOrHidePlusButton];
    [self toggleWelcomeAndDishViews];
    [self resizeDishesTable];
    [self enableNavigationBarButtons];
    [dishes reloadData];
    //Reload all dish table entries after edits
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [dishes setEditing:NO animated:YES];
}

- (void)setupBarButtonActions
{
    [editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [doneButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    [plusButton addTarget:self action:@selector(showAddDishView:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)toggleWelcomeAndDishViews
{
    if([AD.configureTracker count] == 0){
        [welcomeView setAlpha:0.0];
        [welcomeView setHidden:NO];
        [UIView animateWithDuration:0.20 animations:^{
            welcomeView.alpha = 1.0;
        }];
        [dishes setHidden:YES];
        [self.navigationController setNavigationBarHidden:YES];
    } else {
        [welcomeView setAlpha:1.0];
        [UIView animateWithDuration:0.20 animations:^{
            welcomeView.alpha = 0.0;
        }];
        [self.navigationController setNavigationBarHidden:NO];
        [welcomeView setHidden:YES];
        [dishes setHidden:NO];
        [dishes reloadData];
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
    [welcome setFrame:CGRectMake(0, -30, STD_WIDTH, 480)];
    [welcome setBackgroundColor:defaultBackground];
    welcomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, STD_HEIGHT)];
    [welcomeView setBackgroundColor:defaultBackground];
    [welcomeView addSubview:welcome];
    
    UIButton *plusIcon = [[UIButton alloc] initWithFrame:CGRectMake(125, 295, 70, 65)];
    [plusIcon setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"welcome_plus_icon.png"]]];
    [plusIcon addTarget:self action:@selector(showAddDishView:) forControlEvents:UIControlEventTouchUpInside];
    [welcomeView addSubview:plusIcon];
    
    [welcomeView setHidden:YES];
    [self.view addSubview:welcomeView];
}

- (void)showOrHidePlusButton
{
    [plusButton setHidden:([AD.configureTracker count] >= MAX_DISHES)];
}

- (UIImageView *)dishesBackground
{
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, STD_WIDTH, STD_HEIGHT)];
    [bgImg setImage:defaultBackgroundImage];
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
        [self showOrHidePlusButton];
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
    [[cell textLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
    [[cell textLabel] setTextColor:[UIColor whiteColor]];
    [cell setTag:indexPath.row];
    
    //Dish duration
    [[cell detailTextLabel] setText:[NSString stringWithFormat:@"Cook Time: %@",[data duration]]];
    [[cell detailTextLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
    [[cell detailTextLabel] setTextColor:[UIColor colorWithRed:181.0/255 green:181.0/255 blue:181.0/255 alpha:1.0]];
    
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
