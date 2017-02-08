//
//  JWSerializationManager.h
//  jw_core
//
//  Created by ddeyes on 2017/1/12.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWSerializedClass.h>
#import <Foundation/Foundation.h>

@interface JWSerializationManager : NSObject

+ (id) instance;

- (void) registerClass:(JWSerializedClass*)aClass;
- (void) unregisterClass:(JWSerializedClass*)aClass;
- (JWSerializedClass*) classForClass:(Class)aClass;

@end
