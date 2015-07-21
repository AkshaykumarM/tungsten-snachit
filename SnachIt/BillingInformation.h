//
//  BillingInformation.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "BillingInfoOverview.h"
@interface BillingInformation : UIViewController<SWTableViewCellDelegate,BillingInfoControllerDelegate>


- (IBAction)addCard:(id)sender;


@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;


@property (nonatomic,assign)int lastcheckeckedcelltag;
@end
