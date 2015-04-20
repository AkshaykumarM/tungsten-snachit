//
//  BillingInfoOverview.h
//  SnatchIt
//
//  Created by Akshakumar Maldhure on 12/27/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BillingInfoControllerDelegate

-(void)editingInfoWasFinished;

@end

@interface BillingInfoOverview : UIViewController<UITextFieldDelegate>
;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) int recordIDToEdit;

@property (nonatomic, strong) id<BillingInfoControllerDelegate> delegate;
- (IBAction)saveBtn:(id)sender;

@end
