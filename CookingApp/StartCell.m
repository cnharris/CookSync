//
//  StartCell.m
//  CookSync
//
//  Created by Christopher Harris on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StartCell.h"

@implementation StartCell

@synthesize imageView;
@synthesize textLabel;
@synthesize detailTextLabel;
@synthesize timeLeftAction;
@synthesize timeLeft;
@synthesize doneIcon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.textLabel setNumberOfLines:1];
        [self.detailTextLabel setNumberOfLines:1];
        [self.timeLeftAction setNumberOfLines:1];
        [self.timeLeft setNumberOfLines:1];
        
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dish_icon.png"]];
        [imageView setFrame:CGRectMake(0, 10, 60, 45)];
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
     
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 11, 165, 20)];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [textLabel setText:@"Some Text Goes Here"];
        [textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
        [textLabel setTextColor:[UIColor whiteColor]];
        
        detailTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 36, 165, 15)];
        [detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [detailTextLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [detailTextLabel setTextColor:[UIColor colorWithRed:181.0/255 green:181.0/255 blue:181.0/255 alpha:1.0]];
        
        timeLeftAction = [[UILabel alloc] initWithFrame:CGRectMake(240, 11, 80, 20)];
        [timeLeftAction setBackgroundColor:[UIColor clearColor]];
        [timeLeftAction setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:14.0f]];
        [timeLeftAction setTextColor:[UIColor whiteColor]];
        
        timeLeft = [[UILabel alloc] initWithFrame:CGRectMake(240, 32, 80, 20)];
        [timeLeft setBackgroundColor:[UIColor clearColor]];
        [timeLeft setFont:[UIFont fontWithName:@"HelveticaNeue-Medium" size:18.0f]];
        [timeLeft setTextColor:[UIColor colorWithRed:187.0/255 green:241.0/255 blue:255.0/255 alpha:1.0]];
        
        doneIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_doneIcon.png"]];
        [doneIcon setFrame:CGRectMake(280, 22, 17, 17)];
        [doneIcon setHidden:YES];
        
        [self.contentView addSubview:imageView];
        [self.contentView addSubview:textLabel];
        [self.contentView addSubview:detailTextLabel];
        [self.contentView addSubview:timeLeftAction];
        [self.contentView addSubview:timeLeft];
        [self.contentView addSubview:doneIcon];
        
        [self setUserInteractionEnabled:NO];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)doneIconIsHidden
{
    return [doneIcon isHidden];
}

- (void)showDoneIcon
{
    [doneIcon setHidden:NO];
}

- (void)hideDoneIcon
{
    [doneIcon setHidden:YES];
}

@end
