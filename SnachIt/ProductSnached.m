//
//  ProductSnached.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "ProductSnached.h"

@implementation ProductSnached


-(void)viewDidLoad{
    [super viewDidLoad];
    [self initialize];
  }
-(void)initialize{
    self.fullNameLbl.text=self.fullName;
    self.streetAddressLbl.text=self.streetAddress;
    self.cityStateZipLbl.text=self.cityStateZip;

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
