//
//  NSInputStream+JWCoreCategory.h
//  jw_core
//
//  Created by ddeyes on 2017/1/16.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWBitUtils.h>
#import <jw/JWEncoding.h>

@interface NSInputStream (JWCoreCategory)

- (BOOL) readByte:(JWByte*)b;
- (NSInteger) readBytes:(JWByte*)bytes endian:(JWEndian)endian length:(NSUInteger)length;
- (NSInteger) readUint:(NSUInteger*)v endian:(JWEndian)endian length:(NSUInteger)length;
- (NSInteger) readString:(NSString**)str encoding:(JWEncoding)encoding size:(NSInteger)size;
- (NSInteger) readString:(NSString**)str codeFunc:(JWStringDecodingFunc)codeFunc size:(NSInteger)size;
@property (nonatomic, readonly) NSUInteger position;
- (void) seek:(NSUInteger)position;

@end
