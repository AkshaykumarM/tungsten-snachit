//
//  ProductSnached.h
//  SnachIt
//
//  Created by Akshakumar Maldhure on 1/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductSnached : UIViewController
- (IBAction)snachMoreBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *fullNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *streetAddressLbl;
@property (weak, nonatomic) IBOutlet UILabel *cityStateZipLbl;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *streetAddress;
@property (nonatomic, strong) NSString *cityStateZip;

- (IBAction)backBtn:(id)sender;

@end
