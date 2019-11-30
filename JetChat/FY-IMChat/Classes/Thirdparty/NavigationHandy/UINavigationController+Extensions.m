//
//  UINavigationController+Extensions.m
//  IDCMWallet
//
//  Created by IDCM on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import "UINavigationController+Extensions.h"
#import "NSObject+BinAdd.h"

@implementation UINavigationController (Extensions)
- (void)popBackViewController:(NSString *)vcClassName{
    UIViewController *vc;
    for (UIViewController *childVC in self.childViewControllers) {
        if ([childVC.className isEqualToString:vcClassName]) {
            vc = childVC;
            break;
        }
        
        //swift class name 会带上项目名称
        NSArray *arr  = [childVC.className componentsSeparatedByString:@"."];
        if (arr.lastObject != nil && [arr.lastObject isEqualToString:vcClassName]) {
            vc = childVC;
            break;
        }
    }
    
    if (vc) {
        [self popToViewController:vc animated:true];
    }
}
- (void)popBackViewControllerToIndex:(NSInteger)index{
    if (index > self.childViewControllers.count) {
        return;
    }
    UIViewController *vc = [self.childViewControllers objectAtIndex:index];
    [self popToViewController:vc animated:true];
}

- (void)popBackViewControllerFromIndex:(NSInteger)index{
    if (index > self.childViewControllers.count) {
        return;
    }
    UIViewController *vc = [self.childViewControllers objectAtIndex:self.childViewControllers.count - index - 1];
    [self popToViewController:vc animated:true];
}

- (UIViewController *)getViewControllerByname:(NSString *)vcClassName{
    UIViewController *vc;
    for (UIViewController *childVC in self.childViewControllers) {
        NSLog(@"childVC.className-------------------->%@",childVC.className);
        if ([childVC.className containsString:vcClassName]) {
            vc = childVC;
            break;
        }
    }
    
    if (vc) {
        return vc;
    }
    return nil;
}

- (UIViewController *)getViewControllerByIndex:(NSInteger)index{
    if (index > self.childViewControllers.count) {
        return nil;
    }
    UIViewController *vc = [self.childViewControllers objectAtIndex:index];
    return vc;
}

- (void)removeControllerWithName:(NSString *)name {
    UIViewController *controller = [self getViewControllerByname:name];
    if (controller) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObject:controller];
        [self setViewControllers:arr.copy];
    }
}

- (void)removeControllerFromIndex:(NSInteger)index {
    if (index >= 0 && index < self.viewControllers.count) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObjectAtIndex:index];
        [self setViewControllers:arr.copy];
    }
}

- (void)removeControllerToIndex:(NSInteger)index {
    if (index >= 0 && index < self.viewControllers.count) {
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr removeObjectAtIndex:(arr.count - 1) - index];
        [self setViewControllers:arr.copy];
    }
}
-(void)repleaseControllerAtIndex:(NSInteger)index withController:(UIViewController *)replaceVC{
    if (index >= 0 && index < self.viewControllers.count) {
        replaceVC.hidesBottomBarWhenPushed = index!= 0?YES:NO;
        NSMutableArray *arr = self.viewControllers.mutableCopy;
        [arr replaceObjectAtIndex:index withObject:replaceVC];
        [self setViewControllers:arr.copy];
    }
}
- (BOOL)containViewController:(NSString *)vcClassName{
    UIViewController *vc;
    for (UIViewController *childVC in self.childViewControllers) {
        if ([childVC.className isEqualToString:vcClassName]) {
            vc = childVC;
            break;
        }
    }
    
    if (vc) {
        return YES;
    }
    return NO;
}

@end
@implementation UIViewController (BackButtonHandler)

@end

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(navigationShouldPopOnBackButton)]) {
        shouldPop = [vc navigationShouldPopOnBackButton];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        // 取消 pop 后，复原返回按钮的状态
        for(UIView *subview in [navigationBar subviews]) {
            if(0. < subview.alpha && subview.alpha < 1.) {
                [UIView animateWithDuration:.25 animations:^{
                    subview.alpha = 1.;
                }];
            }
        }
    }
    return NO;
}

@end


