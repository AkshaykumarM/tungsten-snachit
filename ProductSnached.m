//
//  ProductSnached.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/9/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "ProductSnached.h"

@implementation ProductSnached

- (IBAction)snachMoreBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
