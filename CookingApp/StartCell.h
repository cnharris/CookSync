//
//  StartCell.h
//  CookSync
//
//  Created by Christopher Harris on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartCell : UITableViewCell
{
    IBOutlet UIImageView *imageView;
    IBOutlet UILabel *textLabel;
    IBOutlet UILabel *detailTextLabel;
    IBOutlet UILabel *timeLeftAction;
    IBOutlet UILabel *timeLeft;
    IBOutlet UIImageView *doneIcon;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UILabel *textLabel;
@property (nonatomic, retain) IBOutlet UILabel *detailTextLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLeftAction;
@property (nonatomic, retain) IBOutlet UILabel *timeLeft;
@property (nonatomic, retain) IBOutlet UIImageView *doneIcon;

- (BOOL)doneIconIsHidden;
- (void)showDoneIcon;
- (void)hideDoneIcon;

@end
