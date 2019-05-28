//
//  RuntimeObject.m
//  iOSJade
//
//  Created by goingta on 2019/5/28.
//  Copyright © 2019 goingta. All rights reserved.
//

#import "RuntimeObject.h"
#import <objc/runtime.h>

@implementation RuntimeObject

//+ (void)load {
//    //获取test方法
//    Method test = class_getClassMethod(self, @selector(test));
//    //获取otherTest方法
//    Method otherTest = class_getClassMethod(self, @selector(otherTest));
//    //交换两个方法
//    method_exchangeImplementations(test, otherTest);
//}
//
//- (void)test {
//    NSLog(@"test");
//}
//
//- (void)otherTest {
//    //实际上调用test的h具体实现
//    [self otherTest];
//    NSLog(@"otherTest");
//}

void testImp (void) {
    NSLog(@"test invoke");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(test)) {
        NSLog(@"resolveInstanceMethod:");
        //动态添加test方法的实现
        class_addMethod(self, @selector(test), testImp, "v@:");
//        return YES;
        return NO;
    } else {
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"forwardingTargetForSelector:");
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(test)) {
        NSLog(@"methodSignatureForSelector:");
        //v 代表返回值是void类型的 @代表第一个参数类型是id，e即self
        //: 代表第二个参数是SEL类型的 即@selector(test)
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    } else {
        return [super methodSignatureForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"forwardInvocation:");
}

@end
