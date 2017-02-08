//
//  NSString+JWCoreCategory.h
//  June Winter
//
//  Created by GavinLo on 14/11/11.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (JWCoreCategory)

+ (BOOL) is:(NSString*)l equalsTo:(NSString*)r;
+ (BOOL) is:(NSString*)l equalsTo:(NSString*)r by:(BOOL)caseSensitive;

@end
