//
//  JWEncoding.h
//  June Winter
//
//  Created by GavinLo on 14-2-19.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 数据编码
 */
typedef NS_ENUM(NSInteger, JWEncoding) {
    JWEncodingUnknown,
    JWEncodingUTF8,
    JWEncodingUTF16,
    JWEncodingBase64,
};

typedef NSData* (^JWStringEncodingFunc)(NSString* str);
//typedef NSString* (^JWStringDecodingFunc)(NSData* data, NSUInteger index, NSUInteger count);
typedef NSString* (^JWStringDecodingFunc)(NSData* data);

@interface JWEncodingUtils : NSObject

+ (NSStringEncoding) toNSStringEncoding:(JWEncoding)encoding;
+ (NSString*) toHttpEncoding:(JWEncoding)encoding;

@end
