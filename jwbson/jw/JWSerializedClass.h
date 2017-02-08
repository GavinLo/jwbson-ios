//
//  JWSerializedClass.h
//  jw_core
//
//  Created by ddeyes on 2017/1/20.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWSerializedField.h>

@interface JWSerializedClass : NSObject

+ (id) beSerialized;
- (NSArray<JWSerializedField*>*) getFields;

@property (nonatomic, readonly) Class clazz;
@property (nonatomic, readonly) NSArray<JWSerializedField*>* fields;
- (JWSerializedField*) fieldForName:(NSString*)name;

@end
