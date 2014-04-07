//
//  NSObject+RuntimeSwizzle.h
//  FiarfaxTest
//
//  Created by alex tao on 2/24/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface NSObject (RuntimeSwizzle)

+ (BOOL)swizzle:(SEL)original with:(IMP)replacement store:(IMP*)store;
+ (BOOL)swizzle:(Class)cls with:(SEL)original and:(SEL)replacement;

@end
