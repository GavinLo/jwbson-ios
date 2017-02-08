//
//  ViewController.m
//  jwbson
//
//  Created by ddeyes on 2017/1/20.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import "ViewController.h"
#import <jw/JWBson.h>

@interface B : NSObject

@property (nonatomic, readwrite) NSInteger MyInt;
@property (nonatomic, readwrite) float MyFloat;
@property (nonatomic, readwrite) NSString* MyString;
@property (nonatomic, readwrite) BOOL MyBool;

- (id) initDefaults;

@end

@implementation B

- (id)initDefaults {
    self = [super init];
    if (self != nil) {
        self.MyInt = 2342;
        self.MyFloat = 1234.567f;
        self.MyString = @"world";
        self.MyBool = true;
    }
    return self;
}

@end

@interface SB : JWSerializedClass

@end

@implementation SB

- (Class)clazz {
    return [B class];
}

- (NSArray<JWSerializedField *> *)getFields {
    return @[
             [JWSerializedField fieldWithName:@"MyInt" type:[JWInt32 class] getter:^id(id obj) {
                 return @(((B*)obj).MyInt);
             } setter:^(id obj, id value) {
                 ((B*)obj).MyInt = ((NSNumber*)value).unsignedIntegerValue;
             }],
             [JWSerializedField fieldWithName:@"MyFloat" getter:^id(id obj) {
                 return @(((B*)obj).MyFloat);
             } setter:^(id obj, id value) {
                 ((B*)obj).MyFloat = ((NSNumber*)value).floatValue;
             }],
             [JWSerializedField fieldWithName:@"MyString" getter:^id(id obj) {
                 return ((B*)obj).MyString;
             } setter:^(id obj, id value) {
                 ((B*)obj).MyString = (NSString*)value;
             }],
             [JWSerializedField fieldWithName:@"MyBool" getter:^id(id obj) {
                 return @(((B*)obj).MyBool);
             } setter:^(id obj, id value) {
                 ((B*)obj).MyBool = ((NSNumber*)value).boolValue;
             }],
             ];
}

@end

@interface A : NSObject

@property (nonatomic, readwrite) NSUInteger MyInt;
@property (nonatomic, readwrite) float MyFloat;
@property (nonatomic, readwrite) double MyDouble;
@property (nonatomic, readwrite) NSString* MyString;
@property (nonatomic, readwrite) BOOL MyBool;
@property (nonatomic, readwrite) NSArray* MyArray;
@property (nonatomic, readwrite) NSArray* MyArrayInArray;
@property (nonatomic, readwrite) B* bbb;
@property (nonatomic, readwrite) NSArray* MyBs;
@property (nonatomic, readwrite) NSDictionary* MyDict;
@property (nonatomic, readwrite) NSData* bsss;

- (id) initDefaults;

@end

@implementation A

- (id)initDefaults {
    self = [super init];
    if (self != nil) {
        self.MyInt = 234;
        self.MyFloat = 123.456f;
        self.MyDouble = 123.45678910234;
        self.MyString = @"hello";
        self.MyBool = true;
        self.MyArray = @[
                         @"me",
                         @"you",
                         [NSNull null],
                         @"she",
                         @"haha",
                         ];
        self.MyArrayInArray = @[
                                @[@"i", @"love", @"you"],
                                @[@"she", @"love", @"me"],
                                ];
        self.bbb = [[B alloc] initDefaults];
        self.MyBs = @[
                      [[B alloc] initDefaults],
                      [[B alloc] initDefaults],
                      [[B alloc] initDefaults],
                      ];
        self.MyDict = @{
                        @"aaa": @(111.222f),
                        @"bbb": @(222.666f),
                        };
        JWByte tbs[] = { 0x01, 0x02, 0x03, 0x04, };
        self.bsss = [NSData dataWithBytes:tbs length:sizeof(tbs)];
    }
    return self;
}

@synthesize MyInt;
@synthesize MyFloat;
@synthesize MyDouble;
@synthesize MyString;
@synthesize MyBool;
@synthesize MyArray;
@synthesize MyArrayInArray;
@synthesize bbb;
@synthesize MyBs;
@synthesize MyDict;

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
             [JWSerializedField fieldWithName:@"MyString"
                                       getter:JWGetter(A,
                                                       return obj.MyString;
                                                       )
                                       setter:JWSetterString(A,
                                                             obj.MyString = str;
                                                             )],
             [JWSerializedField fieldWithName:@"MyBool"
                                       getter:JWGetter(A,
                                                       return @(obj.MyBool);
                                                       )
                                       setter:JWSetterNumber(A,
                                                             obj.MyBool = num.boolValue;
                                                             )],
             [JWSerializedField fieldWithName:@"MyArray" type:[NSArray class] elementType:[NSString class]
                                       getter:JWGetter(A,
                                                       return obj.MyArray;
                                                       )
                                       setter:JWSetterArray(A,
                                                            obj.MyArray = array;
                                                            )],
             [JWSerializedField fieldWithName:@"MyArrayInArray" type:[NSArray class] dimension:2 elementType:[NSString class]
                                       getter:JWGetter(A,
                                                       return obj.MyArrayInArray;
                                                       )
                                       setter:JWSetterArray(A,
                                                            obj.MyArrayInArray = array;
                                                            )],
             [JWSerializedField fieldWithName:@"bbb" type:[B class]
                                       getter:JWGetter(A,
                                                       return obj.bbb;
                                                       )
                                       setter:JWSetterObject(A, B,
                                                             obj.bbb = obj2;
                                                             )],
             [JWSerializedField fieldWithName:@"MyBs" type:[NSArray class] elementType:[B class] getter:^id(id obj) {
                 return ((A*)obj).MyBs;
             } setter:^(id obj, id value) {
                 ((A*)obj).MyBs = (NSArray*)value;
             }],
             [JWSerializedField fieldWithName:@"MyDict" type:[NSDictionary class]
                                       getter:JWGetter(A,
                                                       return obj.MyDict;
                                                       )
                                       setter:JWSetterDict(A,
                                                           obj.MyDict = dict;
                                                           )],
             [JWSerializedField fieldWithName:@"bsss" type:[NSData class] getter:^id(id obj) {
                 return ((A*)obj).bsss;
             } setter:^(id obj, id value) {
                 ((A*)obj).bsss = (NSData*)value;
             }],
             ];
}

@end

@interface ViewController ()

@end

@implementation ViewController

+ (NSString *)documentDirPath {
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if(paths == nil || paths.count == 0)
        return nil;
    NSString* dir = [paths objectAtIndex:0];
    return dir;
}

+ (NSString *)fullPathForDocument:(NSString *)path {
    NSString* docDir = [self documentDirPath];
    if (docDir == nil) {
        return path;
    }
    NSString* fullPath = [docDir stringByAppendingPathComponent:path];
    return fullPath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // test
    [[JWSerializationManager instance] registerClass:[SA beSerialized]];
    [[JWSerializationManager instance] registerClass:[SB beSerialized]];
    
    JWBson* bson = [[JWBson alloc] initWithContext:[JWBson Context11]];
    
    A* a = [[A alloc] initDefaults];
    NSString* path = [ViewController fullPathForDocument:@"test.bson"];
    NSOutputStream* outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream open];
    [bson serializeObject:a stream:outputStream];
    [outputStream close];
    
    A* aa = [[A alloc] init];
    NSInputStream* inputStream = [NSInputStream inputStreamWithFileAtPath:path];
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [bson deserializeObject:aa stream:inputStream];
    [inputStream close];
    
    NSLog(@"done!!!");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
