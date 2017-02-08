//
//  NSOutputStream+JWCoreCategory.m
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "NSOutputStream+JWCoreCategory.h"

@implementation NSOutputStream (JWCoreCategory)

- (BOOL)writeByte:(JWByte)byte {
    return [self write:&byte maxLength:1] == 1;
}

- (NSInteger)writeBytes:(const JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    if ([JWBitUtils SystemEndian] == endian) {
        return [self write:bytes maxLength:length];
    }
    JWByte bytesToWrite[length];
    [JWBitUtils GetValueBytes:bytes bytes:bytesToWrite endian:endian length:length];
    return [self write:bytes maxLength:length];
}

- (BOOL)writeInt:(NSInteger)v endian:(JWEndian)endian length:(NSUInteger)length {
    JWByte bytes[length];
    [JWBitUtils GetIntBytes:v bytes:bytes endian:endian length:length];
    return [self write:bytes maxLength:length] == length;
}

- (BOOL)writeUint:(NSUInteger)v endian:(JWEndian)endian length:(NSUInteger)length {
    JWByte bytes[length];
    [JWBitUtils GetUIntBytes:v bytes:bytes endian:endian length:length];
    return [self write:bytes maxLength:length] == length;
}

- (NSUInteger)position {
    NSNumber* positionNumber = [self propertyForKey:NSStreamFileCurrentOffsetKey];
    return positionNumber.unsignedIntegerValue;
}

- (void)seek:(NSUInteger)position {
    [self setProperty:@(position) forKey:NSStreamFileCurrentOffsetKey];
}

@end
