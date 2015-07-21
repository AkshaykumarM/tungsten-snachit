//
//  MyAccountOptions.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/12/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "MyAccountOptions.h"

@implementation MyAccountOptions
@synthesize option=_option;
@synthesize icon=_icon;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
