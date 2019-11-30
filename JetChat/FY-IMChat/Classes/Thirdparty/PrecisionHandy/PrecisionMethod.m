//
//  PrecisionMethod.m
//  PrecisionModel
//
//  Created by fisker.zhang on 2019/3/14.
//  Copyright © 2019 Miku. All rights reserved.
//

#import "PrecisionMethod.h"
#import "NSString+ShowRoundNumber.h"


@implementation PrecisionMethod

+ (NSString *)precisionControl:(NSNumber *)balance
{
    long double rounded_up = round([balance doubleValue] * 100000000) / 100000000;
    NSString *string = [NSString stringWithFormat:@"%.8Lf",rounded_up];
    NSString *amoutStr = [PrecisionMethod changeFloat:string];
    return amoutStr;
}
//删除小数点后面多余的0
+ (NSString *)changeFloat:(NSString *)stringFloat
{
    NSInteger length = [stringFloat length];
    if ([stringFloat containsString:@"."]) {
        
        for(NSInteger i = length - 1; i >= 0; i--)
        {
            NSString *subString = [stringFloat substringFromIndex:i];
            if(![subString isEqualToString:@"0"])
            {
                if ([subString isEqualToString:@"."]) {
                    
                    return [stringFloat substringToIndex:[stringFloat length] - 1];
                }else{
                    return stringFloat;
                }
            }
            else{
                stringFloat = [stringFloat substringToIndex:i];
            }
        }
    }
    return 0;
}
// 将数字转为每隔3位整数由逗号“,”分隔的字符串
+ (NSString *)separateNumberUseCommaWith:(NSString *)number {
    
    NSString *replacedStr = [number stringByReplacingOccurrencesOfString:@"," withString:@"."];
    // 分隔符
    NSString *divide = @",";
    
    NSString *integer = @"";
    NSString *radixPoint = @"";
    BOOL contains = NO;
    if ([replacedStr containsString:@"."]) {
        contains = YES;
        // 若传入浮点数，则需要将小数点后的数字分离出来
        NSArray *comArray = [replacedStr componentsSeparatedByString:@"."];
        integer = [comArray firstObject];
        radixPoint = [comArray lastObject];
    } else {
        integer = replacedStr;
    }
    // 将整数按各个字符为一组拆分成数组
    NSMutableArray *integerArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < integer.length; i ++) {
        NSString *subString = [integer substringWithRange:NSMakeRange(i, 1)];
        [integerArray addObject:subString];
    }
    // 将整数数组倒序每隔3个字符添加一个逗号“,”
    NSString *newNumber = @"";
    for (NSInteger i = 0 ; i < integerArray.count ; i ++) {
        NSString *getString = @"";
        NSInteger index = (integerArray.count-1) - i;
        if (integerArray.count > index) {
            getString = [integerArray objectAtIndex:index];
        }
        BOOL result = YES;
        if (index == 0 && integerArray.count%3 == 0) {
            result = NO;
        }
        if ((i+1)%3 == 0 && result) {
            newNumber = [NSString stringWithFormat:@"%@%@%@",divide,getString,newNumber];
        } else {
            newNumber = [NSString stringWithFormat:@"%@%@",getString,newNumber];
        }
    }
    if (contains) {
        newNumber = [NSString stringWithFormat:@"%@.%@",newNumber,radixPoint];
    }
    
    return newNumber;
}

+(NSString *)separateNumberUseCommaWith:(NSNumber *)number withDigits:(NSInteger)digits {
    
    NSString *num = [PrecisionMethod precisionControl:number];
    NSString *balance = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:num] fractionDigits:digits];
    NSString *str = [PrecisionMethod separateNumberUseCommaWith:balance];
    return str;
}
+(NSString *)separateNumberNoCommaWith:(NSNumber *)number withDigits:(NSInteger)digits {
    
    NSString *num = [PrecisionMethod precisionControl:number];
    NSString *balance = [NSString stringFromNumber:[NSDecimalNumber decimalNumberWithString:num] fractionDigits:digits];
    
    return balance;
}
+(NSString *)separateRoundNumberUseCommaWith:(NSNumber *)number withDigits:(NSInteger)digits {
    
    NSString *num = [PrecisionMethod precisionControl:number];
    NSString *roundBalance = [NSString stringRoundPlainFromNumber:[NSDecimalNumber decimalNumberWithString:num] fractionDigits:digits];
    NSString *str = [PrecisionMethod separateNumberUseCommaWith:roundBalance];
    return str;
}
+(NSString *)separateRoundNumberNoCommaWith:(NSNumber *)number withDigits:(NSInteger)digits {
    
    NSString *num = [PrecisionMethod precisionControl:number];
    NSString *roundBalance = [NSString stringRoundPlainFromNumber:[NSDecimalNumber decimalNumberWithString:num] fractionDigits:digits];
    return roundBalance;
}
@end
