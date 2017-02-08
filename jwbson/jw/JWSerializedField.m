//
//  JWSerializedField.m
//  jw_core
//
//  Created by ddeyes on 2017/1/12.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSerializedField.h"

@interface JWSerializedField () {
    NSString* mName;
    Class mType;
    NSUInteger mDimension;
    Class mElementType;
    JWSerializedFieldGetter mGetter;
    JWSerializedFieldSetter mSetter;
}

@end

@implementation JWSerializedField

+ (id)fieldWithName:(NSString *)name getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [[self alloc] initWithName:name getter:getter setter:setter];
}

+ (id)fieldWithName:(NSString *)name type:(Class)type getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [[self alloc] initWithName:name type:type getter:getter setter:setter];
}

+ (id)fieldWithName:(NSString *)name type:(Class)type elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [[self alloc] initWithName:name type:type elementType:elementType getter:getter setter:setter];
}

+ (id)fieldWithName:(NSString *)name type:(Class)type dimension:(NSUInteger)dimension elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [[self alloc] initWithName:name type:type dimension:dimension elementType:elementType getter:getter setter:setter];
}

- (id)initWithName:(NSString *)name getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [self initWithName:name type:NULL getter:getter setter:setter];
}

- (id)initWithName:(NSString *)name type:(Class)type getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [self initWithName:name type:type elementType:NULL getter:getter setter:setter];
}

- (id)initWithName:(NSString *)name type:(Class)type elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    return [self initWithName:name type:type dimension:1 elementType:elementType getter:getter setter:setter];
}

- (id)initWithName:(NSString *)name type:(Class)type dimension:(NSUInteger)dimension elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter {
    self = [super init];
    if (self != nil) {
        mName = name;
        mType = type;
        mDimension = elementType == NULL ? 0 : dimension;
        mElementType = elementType;
        mGetter = getter;
        mSetter = setter;
    }
    return self;
}

@synthesize name = mName;
@synthesize type = mType;
@synthesize dimension = mDimension;
@synthesize elementType = mElementType;

- (id)getValue:(id)obj {
    if (mGetter == nil) {
        return nil;
    }
    return mGetter(obj);
}

- (void)setValue:(id)value forObject:(id)obj {
    if (mSetter == nil) {
        return;
    }
    mSetter(obj, value);
}

@end
