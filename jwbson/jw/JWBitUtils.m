//
//  JWBitUtils.m
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBitUtils.h"

static JWEndian s_SystemEndian = JWEndianUnknow;

@implementation JWBitUtils

+ (JWEndian)SystemEndian {
    if (s_SystemEndian == JWEndianUnknow) {
        uint32_t i = 0x12345678;
        uint8_t* b = &i;
        if (*b == 0x12) {
            s_SystemEndian = JWEndianBig;
        } else {
            s_SystemEndian = JWEndianLittle;
        }
    }
    return s_SystemEndian;
}

+ (void)GetValueBytes:(const void *)v bytes:(JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    [self copyBytesFromSrc:v srcEndian:[self SystemEndian] srcLength:sizeof(NSInteger) toDst:bytes dstEndian:endian dstLength:length];
}

+ (void)SetValueBytes:(void *)v bytes:(const JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    [self copyBytesFromSrc:bytes srcEndian:endian srcLength:sizeof(NSInteger) toDst:v dstEndian:[self SystemEndian] dstLength:length];
}

+ (void)GetIntBytes:(NSInteger)v bytes:(JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    [self copyBytesFromSrc:&v srcEndian:[self SystemEndian] srcLength:sizeof(NSInteger) toDst:bytes dstEndian:endian dstLength:length];
}

+ (void)GetUIntBytes:(NSUInteger)v bytes:(JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    [self copyBytesFromSrc:&v srcEndian:[self SystemEndian] srcLength:sizeof(NSInteger) toDst:bytes dstEndian:endian dstLength:length];
}

+ (void)GetFloatBytes:(float)v bytes:(JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    [self copyBytesFromSrc:&v srcEndian:[self SystemEndian] srcLength:sizeof(NSInteger) toDst:bytes dstEndian:endian dstLength:length];
}

+ (void)GetDoubleBytes:(double)v bytes:(JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    [self copyBytesFromSrc:&v srcEndian:[self SystemEndian] srcLength:sizeof(NSInteger) toDst:bytes dstEndian:endian dstLength:length];
}

+ (void)copyBytesFromSrc:(const JWByte*)src srcEndian:(JWEndian)srcEndian  srcLength:(NSUInteger)srcLength toDst:(JWByte*)dst dstEndian:(JWEndian)dstEndian dstLength:(NSUInteger)dstLength {
    NSUInteger size = MIN(srcLength, dstLength);
    if (srcEndian == dstEndian) {
        memcpy(dst, src, size);
    } else {
        for (NSUInteger i = 0; i < size; i++) {
            dst[i] = src[srcLength - i];
        }
    }
//    switch (srcEndian) {
//        case JWEndianBig: {
//            switch (dstEndian) {
//                case JWEndianBig: {
//                    memcpy(dst, src, size);
//                    break;
//                }
//                case JWEndianLittle: {
//                    for (NSUInteger i = 0; i < size; i++) {
//                        dst[dstLength - i] = src[i];
//                    }
//                    break;
//                }
//            }
//            break;
//        }
//        case JWEndianLittle: {
//            switch (dstEndian) {
//                case JWEndianBig: {
//                    for (NSUInteger i = 0; i < size; i++) {
//                        dst[i] = src[srcLength - i];
//                    }
//                    break;
//                }
//                case JWEndianLittle: {
//                    for (NSUInteger i = 0; i < size; i++) {
//                        dst[dstLength - i] = src[srcLength - i];
//                    }
//                    break;
//                }
//            }
//            break;
//        }
//    }
}

@end
