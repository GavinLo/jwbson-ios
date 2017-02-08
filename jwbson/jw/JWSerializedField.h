//
//  JWSerializedField.h
//  jw_core
//
//  Created by ddeyes on 2017/1/12.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWType.h>
#import <jw/JWClass.h>

typedef id (^JWSerializedFieldGetter)(id obj);
typedef void (^JWSerializedFieldSetter)(id obj, id value);

@interface JWSerializedField : NSObject

+ (id) fieldWithName:(NSString*)name getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
+ (id) fieldWithName:(NSString*)name type:(Class)type getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
+ (id) fieldWithName:(NSString*)name type:(Class)type elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
+ (id) fieldWithName:(NSString*)name type:(Class)type dimension:(NSUInteger)dimension elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
- (id) initWithName:(NSString*)name getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
- (id) initWithName:(NSString*)name type:(Class)type getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
- (id) initWithName:(NSString*)name type:(Class)type elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;
- (id) initWithName:(NSString*)name type:(Class)type dimension:(NSUInteger)dimension elementType:(Class)elementType getter:(JWSerializedFieldGetter)getter setter:(JWSerializedFieldSetter)setter;

@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) Class type;
@property (nonatomic, readonly) NSUInteger dimension;
@property (nonatomic, readonly) Class elementType;

- (id) getValue:(id)obj;
- (void) setValue:(id)value forObject:(id)obj;

@end

#define JWGetter(t, code) ^id(id jwObj) { t* obj = (t*)jwObj; code }
#define JWSetter(t, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; code }
#define JWSetterNumber(t, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; NSNumber* num = (NSNumber*)value; code }
#define JWSetterString(t, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; NSString* str = (NSString*)value; code }
#define JWSetterData(t, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; NSData* data = (NSData*)value; code }
#define JWSetterObject(t, t2, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; t2* obj2 = (t2*)value; code }
#define JWSetterArray(t, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; NSArray* array = (NSArray*)value; code }
#define JWSetterDict(t, code) ^(id jwObj, id value) { t* obj = (t*)jwObj; NSDictionary* dict = (NSDictionary*)value; code }
