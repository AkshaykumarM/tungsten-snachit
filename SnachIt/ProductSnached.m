//
//  ProductSnached.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "ProductSnached.h"
#import "SnoopingUserDetails.h"

@interface ProductSnached()

@end
@implementation ProductSnached
{
    SnoopingUserDetails *userDetails;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self initialize];
   
  }
-(void)initialize{
     userDetails=[SnoopingUserDetails sharedInstance];
    self.fullNameLbl.text=userDetails.shipFullName;
    self.streetAddressLbl.text=userDetails.shipStreetName;
    self.cityStateZipLbl.text=[NSString stringWithFormat:@"%@,%@,%@",userDetails.shipCity,userDetails.shipState,userDetails.shipZipCode];

}
- (IBAction)snachMoreBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.fullName=nil;
    self.streetAddressLbl=nil;
    self.cityStateZipLbl=nil;
    // Release any retained subviews of the main view.
}


@end
