//
//  NSOutputStream+JWCoreCategory.h
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <jw/JWBitUtils.h>

@interface NSOutputStream (JWCoreCategory)

- (BOOL) writeByte:(JWByte)byte;
- (NSInteger) writeBytes:(const JWByte *)bytes endian:(JWEndian)endian length:(NSUInteger)length;
- (BOOL) writeInt:(NSInteger)v endian:(JWEndian)endian length:(NSUInteger)length;
- (BOOL) writeUint:(NSUInteger)v endian:(JWEndian)endian length:(NSUInteger)length;
@property (nonatomic, readonly) NSUInteger position;
- (void) seek:(NSUInteger)position;

@end
