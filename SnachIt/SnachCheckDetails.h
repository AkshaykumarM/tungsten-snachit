//
//  SnachCheckDetails.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/18/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SnachCheckDetails : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *brandImg;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UITextView *productDescription;
@property (weak, nonatomic) IBOutlet UIButton *productPrice;

@property (nonatomic, strong) NSString *prodPrice;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *cityStateZip;

- (IBAction)swipeToSnach:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *swipeToPay;

@end
