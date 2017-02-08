//
//  JWBitUtils.h
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWType.h>

typedef NS_ENUM(NSUInteger, JWEndian) {
    JWEndianUnknow,
    JWEndianBig,
    JWEndianLittle,
};

@interface JWBitUtils : NSObject

+ (JWEndian) SystemEndian;
+ (void) GetValueBytes:(const void*)v bytes:(JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;
+ (void) SetValueBytes:(void*)v bytes:(const JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;

+ (void) GetIntBytes:(NSInteger)v bytes:(JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;
+ (void) GetUIntBytes:(NSUInteger)v bytes:(JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;
+ (void) GetFloatBytes:(float)v bytes:(JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;
+ (void) GetDoubleBytes:(double)v bytes:(JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;

@end
