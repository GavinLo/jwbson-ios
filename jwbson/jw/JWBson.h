//
//  JWBson.h
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWBitUtils.h>
#import <jw/JWSerializationManager.h>
#import <jw/JWEncoding.h>

@protocol JIBsonContext <NSObject>

@property (nonatomic, readonly) JWByte TypeDouble;
@property (nonatomic, readonly) JWByte TypeString;
@property (nonatomic, readonly) JWByte TypeDocument;
@property (nonatomic, readonly) JWByte TypeArray;
@property (nonatomic, readonly) JWByte TypeBinary;
@property (nonatomic, readonly) JWByte TypeBool;
@property (nonatomic, readonly) JWByte TypeInt32;
@property (nonatomic, readonly) JWByte TypeInt64;

@property (nonatomic, readonly) JWByte SubTypeGeneric;

@property (nonatomic, readonly) JWByte ValueEnd;
@property (nonatomic, readonly) JWByte ValueFalse;
@property (nonatomic, readonly) JWByte ValueTrue;

@property (nonatomic, readonly) JWEndian Endian;

@property (nonatomic, readonly) JWStringEncodingFunc StringEncodingFunc;
@property (nonatomic, readonly) JWStringDecodingFunc StringDecodingFunc;

@property (nonatomic, readonly) BOOL Float32AsDouble; // NOTE 非Bson标准，是个优化

@end

@interface JWBsonContext11 : NSObject <JIBsonContext>

@end

@interface JWBsonContext11Min : JWBsonContext11

@end

@interface JWBson : NSObject

+ (id<JIBsonContext>) Context11;
+ (id<JIBsonContext>) Context11Min;

+ (id) bsonWithContext:(id<JIBsonContext>)context;
- (id) initWithContext:(id<JIBsonContext>)context;

- (BOOL) serializeObject:(NSObject*)obj stream:(NSOutputStream*)stream;
- (BOOL) deserializeObject:(NSObject*)obj stream:(NSInputStream*)stream;

@end
