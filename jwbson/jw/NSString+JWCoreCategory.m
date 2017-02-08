//
//  NSString+JWCoreCategory.m
//  June Winter
//
//  Created by GavinLo on 14/11/11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "NSString+JWCoreCategory.h"

@implementation NSString (JWCoreCategory)

+ (BOOL)is:(NSString *)l equalsTo:(NSString *)r
{
    return [self is:l equalsTo:r by:YES];
}

+ (BOOL)is:(NSString *)l equalsTo:(NSString *)r by:(BOOL)caseSensitive
{
    if(l == nil && r == nil)
        return YES;
    if(l == nil || r == nil)
        return NO;
    if(caseSensitive)
        return [l isEqual:r];
    return [l caseInsensitiveCompare:r] == NSOrderedSame;
}

@end
