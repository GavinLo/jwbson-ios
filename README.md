#jwbson-ios

##描述
* 一个bson的序列化/反序列化的简单实现。
* 支持常用的数据类型：double/float, string, array, bytes, bool, int/int32/int64等。

##Description
* A Simple Bson Serializer
* Support data types: double/float, string, array, bytes, bool, int/int32/int64...

##用法 - Usage
###序列化 - Serialize
```objective-c
@interface A : NSObject

@property (nonatomic, readwrite) NSUInteger MyInt;
@property (nonatomic, readwrite) float MyFloat;

@end

@implementation A

@synthesize MyInt;
@synthesize MyFloat;

@end

@interface SA : JWSerializedClass

@end

@implementation SA

- (Class)clazz {
    return [A class];
}

- (NSArray<JWSerializedField *> *)getFields {
    return @[
             [JWSerializedField fieldWithName:@"MyInt" type:[JWInt32 class]
                                       getter:JWGetter(A,
                                                       return @(obj.MyInt);
                                                       )
                                       setter:JWSetterNumber(A,
                                                       obj.MyInt = num.unsignedIntegerValue;
                                                       )],
             [JWSerializedField fieldWithName:@"MyFloat"
                                       getter:JWGetter(A,
                                                       return @(obj.MyFloat);
                                                       )
                                       setter:JWSetterNumber(A,
                                                             obj.MyFloat = num.floatValue;
                                                             )],
             ];
}

@end
	
// bson
	[[JWSerializationManager instance] registerClass:[SA beSerialized]];
	
	JWBson* bson = [[JWBson alloc] initWithContext:[JWBson Context11]];   
    A* a = [[A alloc] init];
    NSString* path = nil;// path-to-write
    NSOutputStream* outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
    [bson serializeObject:a stream:outputStream];
    [outputStream close];

```
	
###反序列化 - Deserialize
	
```objective-c

// bson
	NSString* path = nil;// path-to-read
	A* aa = [[A alloc] init];
    NSInputStream* inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [bson deserializeObject:aa stream:inputStream];
    [inputStream close];
    
```