//
//  SnatchFeed.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/11/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface SnatchFeed : UITableViewController


-(void)alertSnach:(NSNotification *)note;
@property (weak, nonatomic) IBOutlet UIImageView *profilePic;

@end
