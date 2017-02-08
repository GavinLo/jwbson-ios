//
//  NSInputStream+JWCoreCategory.m
//  jw_core
//
//  Created by ddeyes on 2017/1/16.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "NSInputStream+JWCoreCategory.h"
#import "JWCategoryVariables.h"

@interface NSInputStream (JWCoreCategoryPrivate)

@property (nonatomic, readonly) NSMutableData* readData;

@end

@implementation NSInputStream (JWCoreCategoryPrivate)

- (NSMutableData *)readData {
    NSMutableData* rd = [JWCategoryVariables hackTarget:self byClass:[NSMutableData class]];
    return rd;
}

@end

@implementation NSInputStream (JWCoreCategory)

- (BOOL)readByte:(JWByte *)b {
    return [self read:b maxLength:1] == 1;
}

- (NSInteger)readBytes:(JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length {
    if ([JWBitUtils SystemEndian] == endian) {
        return [self read:bytes maxLength:length];
    }
    JWByte bytesToRead[length];
    NSInteger n = [self read:bytesToRead maxLength:length];
    [JWBitUtils SetValueBytes:bytes bytes:bytesToRead endian:endian length:length];
    return n;
}

- (NSInteger)readUint:(NSUInteger*)v endian:(JWEndian)endian length:(NSUInteger)length {
    JWByte* bytes[length];
    NSInteger numBytesRead = [self read:bytes maxLength:length];
    [JWBitUtils SetValueBytes:v bytes:bytes endian:endian length:length];
    return numBytesRead;
}

- (NSInteger)readString:(NSString *__autoreleasing *)str encoding:(JWEncoding)encoding size:(NSInteger)size {
    if (encoding == JWEncodingUnknown) {
        encoding = JWEncodingUTF8;
    }
    return [self readString:str codeFunc:^NSString *(NSData *data) {
        return [[NSString alloc] initWithData:data encoding:[JWEncodingUtils toNSStringEncoding:encoding]];
    } size:size];
}

- (NSInteger)readString:(NSString *__autoreleasing *)str codeFunc:(JWStringDecodingFunc)codeFunc size:(NSInteger)size {
    if (str == nil || codeFunc == nil) {
        return -1;
    }
    NSInteger numBytesRead = 0;
    if (size <= 0) {
        const NSUInteger blockLength = 16;
        JWByte block[blockLength];
//        if (self.readData == nil) {
//            self.readData = [NSMutableData data];
//        }
        NSMutableData* readData = self.readData;
        readData.length = 0;
        NSUInteger oldPosition = self.position;
        while (true) {
            NSInteger n = [self read:block maxLength:blockLength];
            if (n == 0) {
                *str = codeFunc(readData);
                return numBytesRead;
            }
            for (NSUInteger i = 0; i < n; i++) {
                JWByte b = block[i];
                if (b == 0x00) {
                    numBytesRead++;
                    [self seek:(oldPosition + numBytesRead)];
                    *str = codeFunc(readData);
                    return numBytesRead;
                }
                [readData appendBytes:&b length:1];
                numBytesRead++;
            }
        }
    } else {
        NSMutableData* readData = self.readData;
        readData.length = size;
        numBytesRead = [self read:readData.mutableBytes maxLength:size];
        if (numBytesRead <= 0) {
            return numBytesRead;
        }
        *str = codeFunc(readData);
        return numBytesRead;
    }
    return -1;
}

- (NSUInteger)position {
    NSNumber* positionNumber = [self propertyForKey:NSStreamFileCurrentOffsetKey];
    return positionNumber.unsignedIntegerValue;
}

- (void)seek:(NSUInteger)position {
    [self setProperty:@(position) forKey:NSStreamFileCurrentOffsetKey];
}

@end
