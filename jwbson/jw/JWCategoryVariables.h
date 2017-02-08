//
//  JWCategoryVariables.h
//  June Winter
//
//  Created by GavinLo on 14-5-23.
//  Copyright 2015 luojunwen123@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface JWCategoryVariables : NSObject

+ (id) getExtraFromTarget:(id)target byClass:(Class)variablesClass;
+ (void) setExtraToTarget:(id)target withVariables:(id)variables usePolicy:(objc_AssociationPolicy)policy;

+ (id) hackTarget:(id)target byClass:(Class)variablesClass;

@end
