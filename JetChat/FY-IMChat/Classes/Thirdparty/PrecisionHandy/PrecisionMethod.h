//
//  PrecisionMethod.h
//  PrecisionModel
//
//  Created by fisker.zhang on 2019/3/14.
//  Copyright © 2019 Miku. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PrecisionMethod : NSObject
/**
 返回 未丢失精度的 string
 
 @param balance NSNumber类型
 @return 未丢失精度的 string
 */
+ (NSString *)precisionControl:(NSNumber *)balance;

/**
 大于1000+逗号
 */
+ (NSString *)separateNumberUseCommaWith:(NSString *)number;

/**
 大于1000+逗号,并保留小数位
 */
+(NSString *)separateNumberUseCommaWith:(NSNumber *)number withDigits:(NSInteger)digits;
/**
 大于1000+不加逗号,并保留小数位 不足补零
 */
+(NSString *)separateNumberNoCommaWith:(NSNumber *)number withDigits:(NSInteger)digits;
/**
 四舍五入  大于1000+不加逗号,并保留小数位 不足补零
 */
+(NSString *)separateRoundNumberUseCommaWith:(NSNumber *)number withDigits:(NSInteger)digits;
/**
 四舍五入 大于1000+不加逗号,并保留小数位 不足补零
 */
+(NSString *)separateRoundNumberNoCommaWith:(NSNumber *)number withDigits:(NSInteger)digits;
@end

