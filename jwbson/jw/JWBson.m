//
//  JWBson.m
//  jw_core
//
//  Created by ddeyes on 2017/1/11.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWBson.h"
#import "JWBitUtils.h"
#import "NSInputStream+JWCoreCategory.h"
#import "NSOutputStream+JWCoreCategory.h"

#define JWBsonNeedDebug

@interface JWBsonContext11 () {
    JWStringEncodingFunc mStringEncodingFunc;
    JWStringDecodingFunc mStringDecodingFunc;
}

@end

@implementation JWBsonContext11

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mStringEncodingFunc = ^(NSString* str) {
            return [str dataUsingEncoding:NSUTF8StringEncoding];
        };
        mStringDecodingFunc = ^NSString* (NSData* data) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        };
    }
    return self;
}

- (JWByte)TypeDouble {
    return 0x01; // "\x01" e_name double	64-bit binary floating point
}

- (JWByte)TypeString {
    return 0x02; // "\x02" e_name string	UTF-8 string
}

- (JWByte)TypeDocument {
    return 0x03; // "\x03" e_name document	Embedded document
}

- (JWByte)TypeArray {
    return 0x04; // "\x04" e_name document	Array
}

- (JWByte)TypeBinary {
    return 0x05; // "\x05" e_name binary	Binary data
}

- (JWByte)TypeBool {
    return 0x08; // "\x08" e_name "\x00"	Boolean "false"
}

- (JWByte)TypeInt32 {
    return 0x10; // "\x10" e_name int32	32-bit integer
}

- (JWByte)TypeInt64 {
    return 0x12; // "\x12" e_name int64	64-bit integer
}

- (JWByte)SubTypeGeneric {
    return 0x00; // "\x00"	Generic binary subtype
}

- (JWByte)ValueEnd {
    return 0x00; // "\x00"
}

- (JWByte)ValueFalse {
    return 0x00; // "\x08" e_name "\x00"	Boolean "false"
}

- (JWByte)ValueTrue {
    return 0x01; // "\x08" e_name "\x01"	Boolean "true"
}

- (JWEndian)Endian {
    return JWEndianLittle;
}

- (JWStringEncodingFunc)StringEncodingFunc {
    return mStringEncodingFunc;
}

- (JWStringDecodingFunc)StringDecodingFunc {
    return mStringDecodingFunc;
}

- (BOOL)Float32AsDouble {
    return NO;
}

@end

@implementation JWBsonContext11Min

- (BOOL)Float32AsDouble {
    return YES;
}

@end

static id<JIBsonContext> s_JWBsonContext11 = nil;
static id<JIBsonContext> s_JWBsonContext11Min = nil;

@interface JWBson () {
    id<JIBsonContext> mContext;
    NSMutableArray<NSMutableArray*>* mTempArrays;
    NSUInteger mTempArrayLevel;
#ifdef JWBsonNeedDebug
    BOOL mDebug;
    NSMutableString* mDebugString;
#endif
}

@end

@implementation JWBson

+ (id<JIBsonContext>)Context11 {
    if (s_JWBsonContext11 == nil) {
        s_JWBsonContext11 = [[JWBsonContext11 alloc] init];
    }
    return s_JWBsonContext11;
}

+ (id<JIBsonContext>)Context11Min {
    if (s_JWBsonContext11Min == nil) {
        s_JWBsonContext11Min = [[JWBsonContext11Min alloc] init];
    }
    return s_JWBsonContext11Min;
}

+ (id)bsonWithContext:(id<JIBsonContext>)context {
    return [[self alloc] initWithContext:context];
}

- (id)initWithContext:(id<JIBsonContext>)context {
    self = [super init];
    if (self != nil) {
        if (context == nil) {
            context = s_JWBsonContext11;
        }
        mContext = context;
        mDebug = YES;
    }
    return self;
}

- (BOOL)serializeObject:(NSObject *)obj stream:(NSOutputStream *)stream {
    if (obj == nil || stream == nil) {
        return NO;
    }
#ifdef JWBsonNeedDebug
    if (mDebug) {
        if (mDebugString == nil) {
            mDebugString = [NSMutableString string];
        }
        if (mDebugString.length > 0) {
            [mDebugString deleteCharactersInRange:NSMakeRange(0, mDebugString.length)];
        }
    }
#endif
    [self serializeObject:obj forKey:nil stream:stream];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        NSLog(@"[Bson Serialize] %@", mDebugString);
    }
#endif
    return YES;
}

- (BOOL)deserializeObject:(NSObject *)obj stream:(NSInputStream *)stream {
    if (obj == nil || stream == nil) {
        return NO;
    }
    mTempArrayLevel = 0;
    [self deserializeObj:obj stream:stream];
    return YES;
}

#pragma mark serialize

- (void) serializeObject:(NSObject*)obj forKey:(NSString*)objKey stream:(NSOutputStream*)stream {
    if (obj == nil || obj == [NSNull null]) {
        return;
    }
    
    if (objKey != nil) {
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugByte:mContext.TypeDocument];
        }
#endif
        [stream writeByte:mContext.TypeDocument];
        [self writeString:stream str:objKey];
    }
    
    NSUInteger sizePosition = 0;
    NSUInteger debugStringPosition = 0;
    [self wirteBeginObject:stream sizePosition:&sizePosition debugStringPosition:&debugStringPosition];
    JWSerializedClass* clazz = [[JWSerializationManager instance] classForClass:obj.class];
    NSArray<JWSerializedField*>* fields = clazz.fields;
    if (fields != nil) {
        for (JWSerializedField* field in fields) {
            if (field == nil) {
                continue;
            }
            id value = [field getValue:obj];
            [self serializeKey:field.name value:value valueType:field.type stream:stream];
        }
    }
    [self writeEndObject:stream sizePosition:sizePosition debugStringPosition:debugStringPosition];
}

- (void) serializeKey:(NSString*)key value:(id)value valueType:(Class)valueType stream:(NSOutputStream*)stream {
    if (key == nil || value == nil || value == [NSNull null]) {
        return;
    }
    if ([self writeKey:key value:value valueType:valueType stream:stream]) {
        return;
    }
    if ([value isKindOfClass:[NSArray class]]) {
        NSArray* array = value;
        [self serializeArray:array forKey:key stream:stream];
        return;
    }
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary* dict = value;
        [self serializeDict:dict forKey:key stream:stream];
        return;
    }
    [self serializeObject:value forKey:key stream:stream];
}

- (void) serializeArray:(NSArray*)array forKey:(NSString*)key stream:(NSOutputStream*)stream {
    [stream writeByte:mContext.TypeArray];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        [self appendDebugByte:mContext.TypeArray];
    }
#endif
    [self writeString:stream str:key];
    
    NSUInteger sizePosition = 0;
    NSUInteger debugStringPosition = 0;
    [self wirteBeginObject:stream sizePosition:&sizePosition debugStringPosition:&debugStringPosition];
    NSUInteger i = 0;
    for (id a in array) {
        [self serializeKey:@(i).stringValue value:a valueType:JWTypeUnknown stream:stream];
        i++;
    }
    [self writeEndObject:stream sizePosition:sizePosition debugStringPosition:debugStringPosition];
}

- (void) serializeDict:(NSDictionary*)dict forKey:(NSString*)key stream:(NSOutputStream*)stream {
    [stream writeByte:mContext.TypeDocument];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        [self appendDebugByte:mContext.TypeDocument];
    }
#endif
    [self writeString:stream str:key];
    
    NSUInteger sizePosition = 0;
    NSUInteger debugStringPosition = 0;
    [self wirteBeginObject:stream sizePosition:&sizePosition debugStringPosition:&debugStringPosition];
    for (id k in dict) {
        if (![k isKindOfClass:[NSString class]]) { // TODO 暂不支持NSString以外的key
            continue;
        }
        [self serializeKey:k value:[dict objectForKey:k] valueType:JWTypeUnknown stream:stream];
    }
    [self writeEndObject:stream sizePosition:sizePosition debugStringPosition:debugStringPosition];
}

- (BOOL) writeKey:(NSString*)key value:(id)value valueType:(Class)valueType stream:(NSOutputStream*)stream {
    JWByte type = 0x00;
    JWByte* valueBytes = NULL;
    NSUInteger length = 0;
#ifdef JWBsonNeedDebug
    NSString* valueString = nil;
#endif
    
    if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber* number = value;
        if (number == kCFBooleanTrue || number == kCFBooleanFalse) {
            BOOL v = number.boolValue;
            type = mContext.TypeBool;
            [stream writeByte:type];
#ifdef JWBsonNeedDebug
            if (mDebug) {
                [self appendDebugByte:type];
            }
#endif
            [self writeString:stream str:key];
            JWByte b = v ? mContext.ValueTrue : mContext.ValueFalse;
            [stream writeByte:b];
#ifdef JWBsonNeedDebug
            if (mDebug) {
                [self appendDebugByte:b];
                [mDebugString appendString:(v ? @"(true)" : @"(false)")];
            }
#endif
            return YES;
        }
        
        CFNumberType numberType = CFNumberGetType((CFNumberRef)number);
        switch (numberType) {
            case kCFNumberSInt64Type: {
                long v = number.longValue;
                length = [JWClassUtils getNumBytes:valueType];
                if (length < 0) {
                    length = 8;
                } else if (length < 4) {
                    length = 4;
                }
                type = length == 8 ? mContext.TypeInt64 : mContext.TypeInt32;
                valueBytes = &v;
#ifdef JWBsonNeedDebug
                valueString = @(v).stringValue;
#endif
                break;
            }
            case kCFNumberSInt32Type:
            case kCFNumberShortType: {
                int v = number.intValue;
                length = [JWClassUtils getNumBytes:valueType];
                if (length < 4) {
                    length = 4;
                }
                type = length == 8 ? mContext.TypeInt64 : mContext.TypeInt32;
                valueBytes = &v;
#ifdef JWBsonNeedDebug
                valueString = @(v).stringValue;
#endif
                break;
            }
            case kCFNumberFloat32Type:
            case kCFNumberFloat64Type: {
                if (!mContext.Float32AsDouble) {
                    double v = number.doubleValue;
                    type = mContext.TypeDouble;
                    valueBytes = &v;
                    length = 8;
#ifdef JWBsonNeedDebug
                    valueString = @(v).stringValue;
#endif
                } else {
                    float v = number.floatValue;
                    type = mContext.TypeDouble;
                    valueBytes = &v;
                    length = 4;
#ifdef JWBsonNeedDebug
                    valueString = @(v).stringValue;
#endif
                }
                break;
            }
        }
        
        if (valueBytes != NULL) {
            [stream writeByte:type];
#ifdef JWBsonNeedDebug
            if (mDebug) {
                [self appendDebugByte:type];
            }
#endif
            [self writeString:stream str:key];
            [stream writeBytes:valueBytes endian:mContext.Endian length:length];
#ifdef JWBsonNeedDebug
            if (mDebug) {
                [self appendDebugValueBytes:valueBytes length:length];
                [mDebugString appendFormat:@"(%@)\n", valueString];
            }
#endif
        }
        return YES;
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString* str = value;
        type = mContext.TypeString;
        [stream writeByte:type];
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugByte:type];
        }
#endif
        [self writeString:stream str:key];
        NSInteger size = str.length + 1; // NOTE 包含'\x00'
        [stream writeUint:size endian:mContext.Endian length:4];
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugUint:size length:4];
        }
#endif
        [self writeString:stream str:str];
        return YES;
    } else if ([value isKindOfClass:[NSData class]]) {
        NSData* data = value;
        type = mContext.TypeBinary;
        [stream writeByte:type];
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugByte:type];
        }
#endif
        [self writeString:stream str:key];
        NSInteger size = data.length;
        [stream writeUint:size endian:mContext.Endian length:4];
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugUint:size length:4];
        }
#endif
        JWByte subType = mContext.SubTypeGeneric;
        [stream writeByte:subType];
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugByte:subType];
        }
#endif
        const JWByte* bytes = (const JWByte*)data.bytes;
        [stream write:bytes maxLength:size];
#ifdef JWBsonNeedDebug
        if (mDebug) {
            [self appendDebugBytes:bytes length:size];
        }
#endif
        return YES;
    }
    
    return NO;
}

- (void) writeString:(NSOutputStream*)stream str:(NSString*)str {
    NSData* strData = mContext.StringEncodingFunc(str);
    JWByte* strBytes = strData.bytes;
    [stream write:strBytes maxLength:strData.length];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        [mDebugString appendString:str];
    }
#endif
    [self writeEnd:stream];
}

- (void) writeEnd:(NSOutputStream*)stream {
    [stream writeByte:mContext.ValueEnd];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        [self appendDebugByte:mContext.ValueEnd];
        [self appendDebugLine];
    }
#endif
}

- (void) wirteBeginObject:(NSOutputStream*)stream sizePosition:(NSUInteger*)sizePosition debugStringPosition:(NSUInteger*)debugStringPosition {
    // document ::= int32 e_list "\x00"
    // BSON Document. int32 is the total number of bytes comprising the document.
    // NOTE 预留子文档大小位置
    *sizePosition = stream.position;
    [stream writeUint:0 endian:mContext.Endian length:4];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        *debugStringPosition = 0;
        [self appendDebugUint:0 length:4];
        [self appendDebugLine];
    }
#endif
}

- (void) writeEndObject:(NSOutputStream*)stream sizePosition:(NSUInteger)sizePosition debugStringPosition:(NSUInteger)debugStringPosition {
    [self writeEnd:stream];
    NSUInteger endPosition = stream.position;
    [stream seek:sizePosition];
    NSUInteger size = endPosition - sizePosition;
    [stream writeUint:size endian:mContext.Endian length:4];
    [stream seek:endPosition];
#ifdef JWBsonNeedDebug
    if (mDebug) {
        [self replaceDebugUint:size length:4 position:debugStringPosition];
    }
#endif
}

#pragma mark deserialize

- (NSInteger) deserializeObj:(NSObject*)obj stream:(NSInputStream*)stream {
    NSInteger numBytesRead = 0;
    NSUInteger size = 0;
    NSInteger n = [self readSize:stream size:&size];
    if (n <= 0) {
        return n;
    }
    size -= n;
    numBytesRead += n;
    if (size <= 1) {
        return numBytesRead;
    }
    while (size > 1) {
        n = [self deserializeKeyValue:obj stream:stream];
        if (n <= 0) {
            return 0; // NOTE 表示结束
        }
        size -= n;
        numBytesRead += n;
    }
    [stream seek:(stream.position + 1)];
    numBytesRead++;
    return numBytesRead;
}

- (NSInteger) deserializeKeyValue:(NSObject*)obj stream:(NSInputStream*)stream {
    JWByte valueType = 0x00;
    NSString* key = nil;
    NSInteger totalBytesRead = 0;
    NSInteger numBytesRead = [self readKey:stream valueType:&valueType key:&key];
    if (numBytesRead <= 0) {
        return numBytesRead;
    }
    totalBytesRead += numBytesRead;
    
    Class targetValueType = NULL;
    JWSerializedField* field = nil;
    NSMutableDictionary* dict = [obj isKindOfClass:[NSMutableDictionary class]] ? obj : nil;
    if (dict == nil) {
        JWSerializedClass* clazz = [[JWSerializationManager instance] classForClass:obj.class];
        field = [clazz fieldForName:key];
        if (field != nil) {
            targetValueType = field.type;
        }
    }
    
    id value = nil;
    numBytesRead = [self readValue:stream valueType:valueType targetType:targetValueType outValue:&value];
    if (numBytesRead <= 0) {
        if (valueType == mContext.TypeArray || valueType == mContext.TypeDocument) {
            if (dict != nil && field == nil) { // NOTE 找不到内嵌对象的，直接跳过，NSDictionary除外
                NSUInteger size = 0;
                NSInteger n = [self readSize:stream size:&size];
                if (n <= 0) {
                    return 0; // NOTE 表示结束
                }
                size -= n;
                [stream seek:(stream.position + size)];
                totalBytesRead += size;
                return totalBytesRead;
            }
            if (valueType == mContext.TypeArray) {
                numBytesRead = [self deserializeArray:obj stream:stream field:field];
            } else {
                NSObject* o = nil;
                if (targetValueType == [NSDictionary class]) {
                    o = [NSMutableDictionary dictionary];
                } else {
                    o = [[targetValueType alloc] init];
                }
                numBytesRead = [self deserializeObj:o stream:stream];
                if (numBytesRead <= 0) {
                    return totalBytesRead;
                }
                if (targetValueType == [NSDictionary class]) {
                    NSMutableDictionary* md = o;
                    o = md.copy;
                }
                if (dict == nil) {
                    [field setValue:o forObject:obj];
                } else {
                    [dict setObject:o forKey:key];
                }
            }
        }
    } else {
        if (dict == nil) {
            [field setValue:value forObject:obj];
        } else {
            [dict setObject:value forKey:key];
        }
    }
    totalBytesRead += numBytesRead;
    return totalBytesRead;
}

- (NSInteger) deserializeArray:(NSObject*)obj stream:(NSInputStream*)stream field:(JWSerializedField*)field {
    NSArray* array = nil;
    NSInteger numBytesRead = [self readArray:stream arrayType:field.type dimension:1 elementType:field.elementType  targetDimension:field.dimension outArray:&array];
    if (numBytesRead <= 0) {
        return numBytesRead;
    }
    [field setValue:array forObject:obj];
    return numBytesRead;
}

- (NSInteger) readKey:(NSInputStream*)stream valueType:(JWByte*)valueType key:(NSString**)key {
    JWByte b = 0x00;
    if (![stream readByte:&b]) {
        return -1;
    }
    *valueType = b;
    NSInteger numBytesRead = 1;
    
    NSInteger n = [stream readString:key encoding:JWEncodingUTF8 size:0];
    if (n <= 0) {
        return n;
    }
    numBytesRead += n;
#ifdef JWBsonNeedDebug
    if (mDebug) {
        NSLog(@"Find Key=%@ Type=0x%02x", *key, valueType);
    }
#endif
    return numBytesRead;
}

- (NSInteger) readSize:(NSInputStream*)stream size:(NSUInteger*)size {
    return [stream readUint:size endian:mContext.Endian length:4];
}

- (NSInteger) readSubType:(NSInputStream*)stream subType:(JWByte*)subType {
    if (![stream readByte:subType]) {
        return 0;
    }
    return 1;
}

- (NSInteger) readValue:(NSInputStream*)stream valueType:(JWByte)valueType targetType:(Class)targetType outValue:(id*)outValue {
    NSInteger numBytesRead = 0;
    *outValue = nil;
    if (valueType == mContext.TypeInt32) {
        NSInteger v = 0;
        numBytesRead = [stream readBytes:&v endian:mContext.Endian length:4];
        if (numBytesRead <= 0) {
            return numBytesRead;
        }
        *outValue = @(v);
    } else if (valueType == mContext.TypeInt64) {
        NSInteger v = 0;
        numBytesRead = [stream readBytes:&v endian:mContext.Endian length:8];
        if (numBytesRead <= 0) {
            return numBytesRead;
        }
        *outValue = @(v);
    } else if (valueType == mContext.TypeDouble) {
        if (!mContext.Float32AsDouble) {
            double v = 0.0;
            numBytesRead = [stream readBytes:&v endian:mContext.Endian length:8];
            if (numBytesRead <= 0) {
                return numBytesRead;
            }
            *outValue = @(v);
        } else {
            float v = 0.0f;
            numBytesRead = [stream readBytes:&v endian:mContext.Endian length:4];
            if (numBytesRead <= 0) {
                return numBytesRead;
            }
            *outValue = @(v);
        }
    } else if (valueType == mContext.TypeString) {
        NSUInteger size = 0;
        numBytesRead = [self readSize:stream size:&size];
        if (numBytesRead <= 0) {
            return numBytesRead;
        }
        NSString* v = nil;
        NSInteger n = [stream readString:&v codeFunc:mContext.StringDecodingFunc size:size];
        if (n <= 0) {
            return numBytesRead;
        }
        numBytesRead += n;
        *outValue = v;
    } else if (valueType == mContext.TypeBool) {
        JWByte v;
        if (![stream readByte:&v]) {
            return -1;
        }
        numBytesRead = 1;
        *outValue = v == 0x01 ? @(true) : @(false);
    } else if (valueType == mContext.TypeBinary) {
        NSUInteger size = 0;
        numBytesRead = [self readSize:stream size:&size];
        if (numBytesRead <= 0) {
            return numBytesRead;
        }
        JWByte subType = 0x00;
        NSUInteger n = [self readSubType:stream subType:&subType];
        if (n <= 0) {
            return n;
        }
        numBytesRead += n;
        
        if (targetType != [NSData class] && targetType != [NSMutableData class]) {
            [stream seek:(stream.position + size)];
            numBytesRead += size;
            return numBytesRead;
        }
        JWByte* bytes = (JWByte*)malloc(size);
        [stream read:bytes maxLength:size];
        if (targetType == [NSData class]) {
            *outValue = [NSData dataWithBytesNoCopy:bytes length:size];
        } else {
            *outValue = [NSMutableData dataWithBytesNoCopy:bytes length:size];
        }
    }
    return numBytesRead;
}

- (NSInteger) readArray:(NSInputStream*)stream arrayType:(Class)arrayType dimension:(NSUInteger)dimension elementType:(Class)elementType targetDimension:(NSUInteger)targetDimension  outArray:(NSArray**)outArray {
    NSUInteger size = 0;
    NSInteger numBytesRead = [self readSize:stream size:&size];
    if (numBytesRead <= 0) {
        if (mTempArrayLevel > 0) {
            mTempArrayLevel--;
        }
        return numBytesRead;
    }
    NSUInteger numBytesToRead = size - numBytesRead;
    
    if ((arrayType != [NSArray class] && arrayType != [NSMutableArray class]) || elementType == NULL || targetDimension == 0) {
        numBytesRead = size;
        [stream seek:(stream.position + numBytesToRead)];
        return numBytesRead;
    }
    
    NSMutableArray* tempArray = [self getTempArray:mTempArrayLevel];
    mTempArrayLevel++;
    if (dimension > targetDimension || dimension != mTempArrayLevel) {
        mTempArrayLevel--;
        numBytesRead = size;
        [stream seek:(stream.position + numBytesToRead)];
        return numBytesRead;
    }
    while (numBytesToRead > 1) {
        JWByte valueType = 0x00;
        NSString* key = nil;
        NSInteger n = [self readKey:stream valueType:&valueType key:&key];
        if (n <= 0) {
            return n;
        }
        numBytesToRead -= n;
        numBytesRead += n;
        // 数组视为这样的子文档{"0":ele0, "1":ele1, "2":ele2,...}，直接忽略顺序
        id element = nil;
        n = [self readValue:stream valueType:valueType targetType:elementType outValue:&element];
        if (n < 0) {
            return n;
        }
        numBytesToRead -= n;
        numBytesRead += n;
        if (element == nil) {
            if (valueType == mContext.TypeArray) {
                NSArray* elementArray = nil;
                n = [self readArray:stream arrayType:arrayType dimension:(dimension + 1) elementType:elementType targetDimension:targetDimension outArray:&elementArray];
                if (n <= 0) {
                    return n;
                }
                numBytesToRead -= n;
                numBytesRead += n;
                element = elementArray;
            } else if (valueType == mContext.TypeDocument) {
                element = [[elementType alloc] init];
                n = [self deserializeObj:element stream:stream];
                if (n <= 0) {
                    return n;
                }
                numBytesToRead -= n;
                numBytesRead += n;
            }
            if (element == nil) {
                continue;
            }
        }
        [tempArray addObject:element];
    }
    mTempArrayLevel--;
    [stream seek:(stream.position + numBytesToRead)]; // NOTE 跳过剩余数据
    numBytesRead += numBytesToRead;
    
    if (arrayType == [NSArray class]) {
        *outArray = [tempArray copy];
    } else {
        *outArray = [tempArray mutableCopy];
    }
    return numBytesRead;
}

- (NSMutableArray*) getTempArray:(NSUInteger)level {
    if (mTempArrays == nil) {
        mTempArrays = [NSMutableArray array];
    }
    NSMutableArray* a = nil;
    if (mTempArrays.count <= level) {
        a = [NSMutableArray array];
        [mTempArrays addObject:a];
    } else {
        a = [mTempArrays objectAtIndex:level];
    }
    [a removeAllObjects];
    return a;
}

#pragma mark debug

- (void) appendDebugByte:(JWByte)b {
    [mDebugString appendFormat:@"\\x%02x", b];
}

- (void) appendDebugBytes:(JWByte*)bs length:(NSUInteger)l {
    for (NSUInteger i = 0; i < l; i++) {
        [self appendDebugByte:bs[i]];
    }
}

- (NSUInteger) replaceDebugByte:(JWByte)b position:(NSUInteger)position {
    NSString* r = [NSString stringWithFormat:@"\\x%02x", b];
    [mDebugString replaceCharactersInRange:NSMakeRange(position, r.length) withString:r];
    return r.length;
}

- (void) replaceDebugBytes:(JWByte*)bs length:(NSUInteger)l position:(NSUInteger)position {
    for (NSUInteger i = 0; i < l; i++) {
        NSUInteger r = [self replaceDebugByte:bs[i] position:position];
        position += r;
    }
}

- (void) appendDebugUint:(NSUInteger)i length:(NSUInteger)length {
    JWByte bytes[length];
    [JWBitUtils GetIntBytes:i bytes:bytes endian:mContext.Endian length:length];
    [self appendDebugBytes:bytes length:length];
}

- (void) replaceDebugUint:(NSUInteger)i length:(NSUInteger)length position:(NSUInteger)position {
    JWByte bytes[length];
    [JWBitUtils GetIntBytes:i bytes:bytes endian:mContext.Endian length:length];
    [self replaceDebugBytes:bytes length:length position:position];
}

- (void) appendDebugValueBytes:(JWByte*)v length:(NSUInteger)length {
    JWByte bytes[length];
    [JWBitUtils GetValueBytes:v bytes:bytes endian:mContext.Endian length:length];
    [self appendDebugBytes:bytes length:length];
}

- (void) appendDebugLine {
    [mDebugString appendString:@"\n"];
}

@end
