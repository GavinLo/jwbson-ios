//
//  JWSerializedClass.m
//  jw_core
//
//  Created by ddeyes on 2017/1/20.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSerializedClass.h"
#import "NSString+JWCoreCategory.h"

@interface JWSerializedClass () {
    NSArray<JWSerializedField*>* mFields;
}

@end

@implementation JWSerializedClass

+ (id)beSerialized {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        mFields = [self getFields];
    }
    return self;
}

- (Class)clazz {
    return NULL;
}

- (NSArray<JWSerializedField *> *)fields {
    return mFields;
}

- (JWSerializedField *)fieldForName:(NSString *)name {
    NSArray<JWSerializedField*>* fields = self.fields;
    if (fields == nil) {
        return nil;
    }
    for (JWSerializedField* field in fields) {
        if ([NSString is:field.name equalsTo:name]) {
            return field;
        }
    }
    return nil;
}

@end
