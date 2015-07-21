//
//  UIFont+UIFont_SytemFontOverride.m
//  SnachIt
//
//  Created by Akshay Maldhure on 3/19/15.
//  Copyright (c) 2015 Tungsten. All rights reserved.
//

#import "UIFont+UIFont_SytemFontOverride.h"

@implementation UIFont (UIFont_SytemFontOverride)


#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans" size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"OpenSans" size:fontSize];
}

#pragma clang diagnostic pop

@end
