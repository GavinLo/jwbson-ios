//
//  JWClass.h
//  jw_core
//
//  Created by ddeyes on 2017/1/18.
//  Copyright © 2017年 luojunwen123@gmail.com. All rights reserved.
//

#import <jw/JWType.h>

@interface JWBaseType : NSObject

@end

@interface JWBool : JWBaseType

@end

@interface JWChar : JWBaseType

@end

@interface JWInt : JWBaseType

@end

@interface JWInt8 : JWInt

@end

@interface JWUint8 : JWInt

@end

@interface JWInt16 : JWInt

@end

@interface JWUInt16 : JWInt

@end

@interface JWInt32 : JWInt

@end

@interface JWUInt32 : JWInt

@end

@interface JWInt64 : JWInt

@end

@interface JWUInt64 : JWInt

@end

@interface JWFloat : JWBaseType

@end

@interface JWFloat16 : JWFloat

@end

@interface JWFloat32 : JWFloat

@end

@interface JWFloat64 : JWFloat

@end

@interface JWFloat128 : JWFloat

@end

@interface JWClassUtils : NSObject

+ (NSUInteger) getNumBytes:(Class)clazz;

@end
