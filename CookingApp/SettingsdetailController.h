//
//  SettingsdetailController.h
//  CookingApp
//
//  Created by Christopher Harris on 4/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsdetailController : UIViewController
{
    NSString *section;
    IBOutlet UISwitch *onoff;
    IBOutlet UISlider *slider;
    IBOutlet UIScrollView *canvas;
}

@property (nonatomic, retain) IBOutlet NSString *section;
@property (nonatomic, retain) IBOutlet UISlider *slider;
@property (nonatomic, retain) IBOutlet UISwitch *onoff;
@property (nonatomic, retain) IBOutlet UIScrollView *canvas;

- (id)init:(NSString *)sectionName;

@end
