//
//  SettingsController.h
//  CookingApp
//
//  Created by Christopher Harris on 4/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView *settings;
    IBOutlet UIView *viewHeader;
    NSMutableArray *data;
}

@property (nonatomic, retain) IBOutlet UITableView *settings;
@property (nonatomic, retain) IBOutlet UIView *viewHeader;
@property (nonatomic, retain) NSMutableArray *data;

@end
