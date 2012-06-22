//
//  UtilController.m
//  CookSync
//
//  Created by Christopher Harris on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "UtilController.h"

@implementation UtilController

@synthesize backgroundImage;
@synthesize doneBarButton;
@synthesize editBarButton;
@synthesize plusBarButton;
@synthesize cancelBarButton;

- (id)init
{
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Default background
    backgroundImage = [UIImage imageNamed:@"background.png"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


// Start Navbar //

- (void)buildNavBar:(NSString *)type
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"navbar_%@.png",type]]];
    [bgImageView setFrame:CGRectMake(0, 0, STD_WIDTH, 44)];
    
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

- (void)setupNavButtons
{
    UIImage *editIcon = [UIImage imageNamed:@"nav_edit_icon.png"];
    UIButton *editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [editButton setImage:editIcon forState:UIControlStateNormal];
    editButton.showsTouchWhenHighlighted = YES;
    editButton.frame = CGRectMake(0.0, 0.0, editIcon.size.width, editIcon.size.height);
    [editButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    editBarButton = [[UIBarButtonItem alloc] initWithCustomView:editButton];
    
    UIImage *doneIcon = [UIImage imageNamed:@"nav_done_icon.png"];
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setImage:doneIcon forState:UIControlStateNormal];
    doneButton.showsTouchWhenHighlighted = YES;
    doneButton.frame = CGRectMake(0.0, 0.0, doneIcon.size.width, doneIcon.size.height);
    [doneButton addTarget:self action:@selector(toggleEdit:) forControlEvents:UIControlEventTouchUpInside];
    doneBarButton = [[UIBarButtonItem alloc] initWithCustomView:doneButton];
    
    UIImage *plusIcon = [UIImage imageNamed:@"nav_plus_icon.png"];
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setImage:plusIcon forState:UIControlStateNormal];
    plusButton.showsTouchWhenHighlighted = YES;
    plusButton.frame = CGRectMake(0.0, 0.0, plusIcon.size.width, plusIcon.size.height);
    [plusButton addTarget:self action:@selector(showAddDishView:) forControlEvents:UIControlEventTouchUpInside];
    plusBarButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    
    UIImage *cancelIcon = [UIImage imageNamed:@"nav_cancel_left_icon.png"];
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:cancelIcon forState:UIControlStateNormal];
    cancelButton.showsTouchWhenHighlighted = YES;
    cancelButton.frame = CGRectMake(0.0, 0.0, cancelIcon.size.width, cancelIcon.size.height);
    [cancelButton addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    cancelBarButton = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
}

// End NavBar //

- (void)setBackground:view withBackground:(NSString *)bgImg
{
    if(view == nil){
        return;
    } else if(bgImg == nil){
        [view setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];
    } else {
        [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:bgImg]]];
    }
}

- (BOOL)dishesExist
{
    NSLog(@"DISH COUNT: %d",[AD.configureTracker count]);
    if([AD.configureTracker count] > 0){
        return YES;
    }
    return NO;
}

// UITableView delegate methods //

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

// end UITableView delegate methods //

// UITextView delegate methods //

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
	if([text isEqualToString:@"\n"])
	{
		[textView resignFirstResponder];
		return NO;
	}
	return YES;
}

// end UITextView delegate methods //

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
