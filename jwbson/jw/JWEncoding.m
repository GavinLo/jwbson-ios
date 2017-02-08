//
//  JWEncoding.m
//  June Winter
//
//  Created by GavinLo on 14-2-20.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWEncoding.h"

@implementation JWEncodingUtils

+ (NSStringEncoding)toNSStringEncoding:(JWEncoding)encoding {
    switch (encoding) {
        case JWEncodingUTF8:
            return NSUTF8StringEncoding;
        case JWEncodingUTF16:
            return NSUTF16StringEncoding;
        default:
            return 0;
    }
    return 0;
}

+ (NSString *)toHttpEncoding:(JWEncoding)encoding {
    switch (encoding) {
        case JWEncodingUTF8:
            return @"utf-8";
        case JWEncodingUTF16:
            return @"utf-16";
        default:
            return @"";
    }
    return @"";
}

@end
