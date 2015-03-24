//
//  SnatchFeedCell.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "SnatchFeedCell.h"


@implementation SnatchFeedCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
