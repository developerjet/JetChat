//
//  UINavigationController+Extensions.h
//  IDCMWallet
//
//  Created by IDCM on 2018/5/21.
//  Copyright © 2018年 IDCM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Extensions)



/**
 返回对应控制器 根据类名
 
 @param vcClassName 根据类名返回vc
 */
- (UIViewController *)getViewControllerByname:(NSString *)vcClassName;

/**
 返回对应控制器 根据index
 
 @param index 根据index返回vc
 */
- (UIViewController *)getViewControllerByIndex:(NSInteger )index;

/**
 返回对应的层 从前往后

 @param index 从前往后第几个 如果超过childs长度则返回root
 */
- (void)popBackViewControllerToIndex:(NSInteger)index;

/**
 返回对应的层 从后往前
 
 @param index 从后往前第几个 如果超过childs长度则返回root
 */
- (void)popBackViewControllerFromIndex:(NSInteger)index;

/**
 返回对应的层 根据类名
 
 @param vcClassName 根据类名返回到对应页面
 */
- (void)popBackViewController:(NSString *)vcClassName;

- (void)removeControllerWithName:(NSString *)name;
- (void)removeControllerFromIndex:(NSInteger)index;
- (void)removeControllerToIndex:(NSInteger)index;

/**
 判断是否包含类
 
 @param vcClassName 类名
 */
- (BOOL)containViewController:(NSString *)vcClassName;

/**
 替换当前栈堆 控制器位置

 @param index 替换的位置 index
 @param replaceVC 替换的控制器
 */
-(void)repleaseControllerAtIndex:(NSInteger )index withController:(UIViewController *)replaceVC;
@end

// UIViewController+BackButtonHandler.h
@protocol BackButtonHandlerProtocol <NSObject>
@optional
// 重写下面的方法以拦截导航栏返回按钮点击事件，返回 YES 则 pop，NO 则不 pop
-(BOOL)navigationShouldPopOnBackButton;
@end

@interface UIViewController (BackButtonHandler) <BackButtonHandlerProtocol>

@end




