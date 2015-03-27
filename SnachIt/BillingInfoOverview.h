//
//  BillingInfoOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillingInfoOverview : UIViewController<UITextFieldDelegate>
;

@property (weak, nonatomic) IBOutlet UITableView *tableView;




- (IBAction)saveBtn:(id)sender;

@end
