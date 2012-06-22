//
//  UtilController.h
//  CookSync
//
//  Created by Christopher Harris on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UtilController : UIViewController
{
    UIImage *backgroundImage;
    IBOutlet UIBarButtonItem *editBarButton;
    IBOutlet UIBarButtonItem *doneBarButton;
    IBOutlet UIBarButtonItem *plusBarButton;
    IBOutlet UIBarButtonItem *cancelBarButton;
}

@property (nonatomic, retain) UIImage *backgroundImage;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *editBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *plusBarButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *cancelBarButton;

- (void)buildNavBar:(NSString *)type;
- (void)setupNavButtons;
- (void)setBackground:view withBackground:(NSString *)bgImg;
- (BOOL)dishesExist;

@end
