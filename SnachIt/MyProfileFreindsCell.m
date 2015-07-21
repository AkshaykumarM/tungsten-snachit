//
//  MyProfileFreindsCell.m
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import "MyProfileFreindsCell.h"

@implementation MyProfileFreindsCell
@synthesize friendPic =_friendPic;
@synthesize friendName=_friendName;
@synthesize scrollview=_scrollview;
@synthesize noSnachsYet=_noSnachsYet;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code   cell.friendPic.layer.cornerRadius= cell.friendPic.frame.size.width/1.96;
        
        self.friendPic=[[UIImageView alloc] init];
        self.friendPic.clipsToBounds = YES;
        self.friendPic.layer.borderWidth = 5.0f;
        self.friendPic.layer.borderColor = [UIColor whiteColor].CGColor;
        self.scrollview=[[UIScrollView alloc] init];
        self.scrollview.scrollEnabled = YES;
        self.scrollview.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
