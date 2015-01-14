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

@property (nonatomic, strong) NSString *prodName,*prodImgName,*brandImgName,*prodPrice,*prodDesc;
@property (weak, nonatomic) IBOutlet UILabel *productName;
- (IBAction)swipeToSnach:(id)sender;

@end
