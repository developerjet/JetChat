//
//  WeakProxy.h
//  FPSDemo
//
//  Created by just so so on 2019/10/7.
//  Copyright © 2019 bruce yao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakProxy : NSProxy
+ (instancetype)proxyWith:(id)target;
@end

NS_ASSUME_NONNULL_END
