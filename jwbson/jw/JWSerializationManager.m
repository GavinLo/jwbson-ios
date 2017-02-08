//
//  JWSerializationManager.m
//  jw_core
//
//  Created by ddeyes on 2017/1/12.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "JWSerializationManager.h"

static JWSerializationManager* s_JWSerializationManager = nil;

@interface JWSerializationManager () {
    NSMutableDictionary<Class, JWSerializedClass*>* mClasses;
}

@end

@implementation JWSerializationManager

+ (id)instance {
    if (s_JWSerializationManager == nil) {
        s_JWSerializationManager = [[JWSerializationManager alloc] init];
    }
    return s_JWSerializationManager;
}

- (void)registerClass:(JWSerializedClass *)aClass {
    if (aClass == nil) {
        return;
    }
    if (mClasses == nil) {
        mClasses = [NSMutableDictionary dictionary];
    }
    Class key = aClass.clazz;
    if (key == NULL) {
        NSLog(@"[SerializationManager::registerClass Error] Unknown class for register, implement JWSerializedClass::clazz to set one.");
        return;
    }
    [mClasses setObject:aClass forKey:key];
}

- (void)unregisterClass:(JWSerializedClass *)aClass {
    if (aClass == nil || aClass.clazz == NULL) {
        return;
    }
    if (mClasses == nil) {
        return;
    }
    [mClasses removeObjectForKey:aClass.clazz];
}

- (JWSerializedClass *)classForClass:(Class)aClass {
    if (mClasses == nil) {
        return nil;
    }
    return [mClasses objectForKey:aClass];
}

@end
