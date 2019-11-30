//
//  WeakProxy.m
//  FPSDemo
//
//  Created by just so so on 2019/10/7.
//  Copyright © 2019 bruce yao. All rights reserved.
//链接：https://blog.csdn.net/weixin_38735568/article/details/101772108

#import "WeakProxy.h"
@interface WeakProxy()
@property (nonatomic, weak) id target;
@end
@implementation WeakProxy
///类方法 初始化
+ (instancetype)proxyWith:(id)target {
    WeakProxy *proxy = [WeakProxy alloc];
    proxy.target = target;
    return proxy;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation getReturnValue:&null];
}


@end
