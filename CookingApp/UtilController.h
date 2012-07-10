//
//  UtilController.h
//  CookSync
//
//  Created by Christopher Harris on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UtilController : UIViewController
{
    UIColor *defaultBackground;
    UIImage *defaultBackgroundImage;
    IBOutlet UIBarButtonItem *editBarButton;
    IBOutlet UIBarButtonItem *doneBarButton;
    IBOutlet UIBarButtonItem *plusBarButton;
    IBOutlet UIBarButtonItem *cancelBarButton;
    IBOutlet UIBarButtonItem *backBarButton;
    IBOutlet UIBarButtonItem *favoritesBarButton;
    IBOutlet UIButton *editButton;
    IBOutlet UIButton *doneButton;
    IBOutlet UIButton *plusButton;
    IBOutlet UIButton *cancelButton;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *favoritesButton;
}

@property (nonatomic, retain) UIColor *defaultBackground;
@property (nonatomic, retain) UIImage *defaultBackgroundImage;
@property (nonatomic, retain) UIBarButtonItem *editBarButton;
@property (nonatomic, retain) UIBarButtonItem *doneBarButton;
@property (nonatomic, retain) UIBarButtonItem *plusBarButton;
@property (nonatomic, retain) UIBarButtonItem *cancelBarButton;
@property (nonatomic, retain) UIBarButtonItem *backBarButton;
@property (nonatomic, retain) UIBarButtonItem *favoritesBarButton;
@property (nonatomic, retain) IBOutlet UIButton *editButton;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIButton *plusButton;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *favoritesButton;

- (UIScrollView *)buildCanvasWithX:(float)x withY:(float)y withWidth:(float)width withHeight:(float)height;
- (void)buildNavBar:(NSString *)type;
- (void)clearBarButtonActions;
- (BOOL)dishesExist;
- (void)loadCustomTabbar;
- (void)enableDishesSettingsTabs;
- (void)disableDishesSettingsTabs;
- (void)showTabBarAndExtendTableView:(UITableView *)tableView;
- (void)hideTabBarAndExtendTableView:(UITableView *)tableView;

// UITableView Delegate Methods
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
