//
//  JWType.m
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWType.h"

@implementation JWTypeUtils

+ (NSInteger)getNumBytes:(JWType)type {
    if (type < JWTypeBaseStart || type > JWTypeBaseEnd) {
        return -1;
    }
    switch (type) {
        case JWTypeBool:
        case JWTypeChar:
        case JWTypeInt8:
        case JWTypeUInt8: {
            return 1;
        }
        case JWTypeInt16:
        case JWTypeUInt16: {
            return 2;
        }
        case JWTypeInt32:
        case JWTypeUInt32:
        case JWTypeFloat32: {
            return 4;
        }
        case JWTypeInt64:
        case JWTypeUInt64:
        case JWTypeFloat64: {
            return 8;
        }
    }
    return -1;
}

+ (BOOL) isInteger:(JWType)type {
    return JWTypeIntStart <= type && type <= JWTypeIntEnd;
}

@end
