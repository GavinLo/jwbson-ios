//
//  JWCategoryVariables.m
//  June Winter
//
//  Created by GavinLo on 14-5-23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import "JWCategoryVariables.h"

@implementation JWCategoryVariables

+ (id)getExtraFromTarget:(id)target byClass:(Class)variablesClass {
    const void* key = CFBridgingRetain(variablesClass);
    id variables = objc_getAssociatedObject(target, key);
    CFBridgingRelease(key);
    return variables;
}

+ (void)setExtraToTarget:(id)target withVariables:(id)variables usePolicy:(objc_AssociationPolicy)policy {
    if (variables == nil) {
        return;
    }
    Class variablesClass = [variables class];
    const void* key = CFBridgingRetain(variablesClass);
    objc_setAssociatedObject(target, key, variables, policy);
    CFBridgingRelease(key);
}

+ (id)hackTarget:(id)target byClass:(Class)variablesClass {
    const void* key = CFBridgingRetain(variablesClass);
    id variables = objc_getAssociatedObject(target, key);
    if (variables == nil) {
        variables = [[variablesClass alloc] init];
        objc_setAssociatedObject(target, key, variables, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    CFBridgingRelease(key);
    return variables;
}

@end
