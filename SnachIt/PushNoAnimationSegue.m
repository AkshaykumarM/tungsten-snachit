//
//  PushNoAnimationSegue.m
//  SnachIt
//
//  Created by Jayesh Kitukale on 1/14/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "PushNoAnimationSegue.h"

@implementation PushNoAnimationSegue
-(void) perform{
    [[[self sourceViewController] navigationController] pushViewController:[self   destinationViewController] animated:NO];
}

@end
