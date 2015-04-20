//
//  ShippingInformation.h
//  SnatchIt
//
//  Created by Akshay Maldhure on 12/13/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "ShippingInfoOverview.h"
@interface ShippingInformation : UIViewController<UINavigationControllerDelegate,SWTableViewCellDelegate,ShippingInfoControllerDelegate>


- (IBAction)addAddress:(id)sender;


@property (nonatomic,retain)NSIndexPath * checkedIndexPath ;


@end
