//
//  SnatchHistory.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnatchHistory : UIViewController


@property (weak, nonatomic) IBOutlet UISegmentedControl *snachHistorySegmentControl;
- (IBAction)snachHistorySegmentChanged:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(NSDictionary*)makeHistoryRequest:(NSData *)response;
@end
