//
//  SnachProductDetails.h
//  SnatchIt
//
//  Created by Jayesh Kitukale on 12/15/14.
//  Copyright (c) 2014 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SnachProductDetails : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *brandimag;

@property (weak, nonatomic) IBOutlet UIImageView *productimage;
@property (weak, nonatomic) IBOutlet UILabel *productName;
@property (weak, nonatomic) IBOutlet UITextView *productDescription;
@property (weak, nonatomic) IBOutlet UIButton *productPrice;

@property (nonatomic, strong) NSData *brandImageData;
@property (nonatomic, strong) NSData *productImageData;
@property (weak, nonatomic) IBOutlet UIButton *counter;
- (IBAction)snachit:(id)sender;



@end
