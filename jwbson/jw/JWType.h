//
//  JWType.h
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef uint8_t JWByte;

typedef NS_ENUM(NSUInteger, JWType) {
    
    JWTypeUnknown = 0,
    
    // base type
    JWTypeBool,
    JWTypeChar,
    JWTypeByte,
    JWTypeInt8,
    JWTypeUInt8,
    JWTypeInt16,
    JWTypeUInt16,
    JWTypeInt32,
    JWTypeUInt32,
    JWTypeInt64,
    JWTypeUInt64,
    JWTypeFloat32,
    JWTypeFloat64,
    JWTypeFloat128,
    
    JWTypeObject, // id, NSObject
    JWTypeCount,
    
    JWTypeBaseStart = JWTypeBool,
    JWTypeBaseEnd = JWTypeFloat64,
    JWTypeIntStart = JWTypeInt8,
    JWTypeIntEnd = JWTypeUInt64,
    
    JWTypeCustom = 100, // 自定义
    
};

@interface JWTypeUtils : NSObject

+ (NSInteger) getNumBytes:(JWType)type;
+ (BOOL) isInteger:(JWType)type;

@end
