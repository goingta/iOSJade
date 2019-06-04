//
//  RuntimeSuperObject.m
//  iOSJade
//
//  Created by goingta on 2019/6/4.
//  Copyright © 2019 goingta. All rights reserved.
//

#import "RuntimeSuperObject.h"
#import <objc/runtime.h>

@implementation RuntimeSuperObject

void superTestIMP(void) {
    NSLog(@"superTest invoke");
}

void super_testImp (void) {
    NSLog(@"super test invoke");
}


+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(test)) {
        NSLog(@"resolveInstanceMethod:");
        //动态添加test方法的实现
        class_addMethod(self, @selector(test), super_testImp, "v@:");
        return NO;
    } else if (sel == @selector(superTest)) {
        //动态添加superTest方法的实现
        class_addMethod(self, @selector(superTest), superTestIMP, "v@:");
        return NO;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"super forwardingTargetForSelector:");
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        NSLog(@"super methodSignatureForSelector:");
        //v 代表返回值是void类型的 @代表第一个参数类型是id，即self
        //: 代表第二个参数是SEL类型的 即@selector(test)
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"super forwardInvocation:");
}

@end
