//
//  JWClass.m
//  jw_core
//
//  Created by ddeyes on 2017/1/18.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWClass.h"

@implementation JWBaseType

@end

@implementation JWBool

@end

@implementation JWChar

@end

@implementation JWInt

@end

@implementation JWInt8

@end

@implementation JWUint8

@end

@implementation JWInt16

@end

@implementation JWUInt16

@end

@implementation JWInt32

@end

@implementation JWUInt32

@end

@implementation JWInt64

@end

@implementation JWUInt64

@end

@implementation JWFloat

@end

@implementation JWFloat16

@end

@implementation JWFloat32

@end

@implementation JWFloat64

@end

@implementation JWFloat128

@end

@implementation JWClassUtils

+ (NSUInteger)getNumBytes:(Class)clazz {
    if (clazz == NULL) {
        return 0;
    }
    
    if (clazz == [JWBool class]
        || clazz == [JWChar class]
        || clazz == [JWInt8 class]
        || clazz == [JWUint8 class]) {
        return 1;
    } else if (clazz == [JWInt16 class]
               || clazz == [JWUInt16 class]
               || clazz == [JWFloat16 class]) {
        return 2;
    } else if (clazz == [JWInt32 class]
               || clazz == [JWUInt32 class]
               || clazz == [JWFloat32 class]) {
        return 4;
    } else if (clazz == [JWInt64 class]
               || clazz == [JWUInt64 class]
               || clazz == [JWFloat64 class]) {
        return 8;
    } else if (clazz == [JWFloat128 class]) {
        return 16;
    }
    
    return 0;
}

@end

