//
//  NSObject+RuntimeSwizzle.m
//  FiarfaxTest
//
//  Created by alex tao on 2/24/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import "NSObject+RuntimeSwizzle.h"
#import "MethodSwizzleHelper.h"

@implementation NSObject (RuntimeSwizzle)

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMP*)store {
    return class_swizzleMethodHelper(self, original, replacement, store);
}

+ (BOOL)swizzle:(Class)cls with:(SEL)original and:(SEL)replacement {
    Method oriMethod = class_getInstanceMethod(cls, original);
    Method newMethod = class_getInstanceMethod(cls, replacement);
    if (oriMethod && newMethod) {
        method_exchangeImplementations(oriMethod, newMethod);
        return YES;
    }
    return NO;
}

@end
