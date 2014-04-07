//
//  MethodSwizzleHelper.h
//  FiarfaxTest
//
//  Created by alex tao on 2/24/14.
//  Copyright (c) 2014 Fiarfax. All rights reserved.
//

#ifndef FiarfaxTest_MethodSwizzleHelper_h
#define FiarfaxTest_MethodSwizzleHelper_h

#import <objc/runtime.h>

BOOL class_swizzleMethodHelper(Class cls, SEL original, IMP replacement, IMP * store)
{
    IMP imp = NULL;
    Method method = class_getInstanceMethod(cls, original);
    if (method) {
        const char * type = method_getTypeEncoding(method);
        imp = class_replaceMethod(cls, original, replacement, type);
        if (!imp) {
            imp = method_getImplementation(method);
        }
    }
    if (imp && store) {
        *store = imp;
    }
    return (imp != NULL);
}

#endif
