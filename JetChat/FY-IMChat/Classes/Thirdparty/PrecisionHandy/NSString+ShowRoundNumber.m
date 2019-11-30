//
//  NSString+ShowRoundNumber.m
//  iOS-RoundNumber
//
//  Created by colin on 16/7/3.
//  Copyright © 2016年 CHwang. All rights reserved.
//

#import "NSString+ShowRoundNumber.h"
#import "NSDecimalNumber+RoundNumber.h"

@implementation NSString (ShowRoundNumber)

+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded
{
    return [NSString stringFromFloat:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithFloat:value roundingScale:scale roundingMode:mode];
    return [NSString stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded
{
    return [NSString stringFromDouble:value roundingScale:scale roundingMode:NSRoundPlain fractionDigitsPadded:isPadded];
}

+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    
    if (!isPadded) return [NSString stringWithFormat:@"%@", decimalNumber];
    
    return [NSString stringFromNumber:decimalNumber fractionDigits:scale];
}

+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits
{
    NSDecimalNumber *decimalNumber = [NSDecimalNumber decimalNumberWithDouble:value roundingScale:scale roundingMode:mode];
    return [NSString stringFromNumber:decimalNumber fractionDigits:fractionDigits];
}

+ (NSString *)stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits
{
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:fractionDigits];
    numberFormatter.roundingMode = NSNumberFormatterRoundDown;
    numberFormatter.minimumIntegerDigits = 1;
    numberFormatter.groupingSeparator = @"";
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @".";
    return [numberFormatter stringFromNumber:number];
}

+ (NSString *)stringRoundPlainFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:fractionDigits];
    numberFormatter.roundingMode = NSNumberFormatterRoundCeiling;
    numberFormatter.minimumIntegerDigits = 1;
    numberFormatter.groupingSeparator = @"";
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @".";
    return [numberFormatter stringFromNumber:number];
}


+ (NSString *)stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits IntegerDigits:(NSUInteger)integerDigits
{
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    [numberFormatter setMaximumFractionDigits:fractionDigits];
    [numberFormatter setMinimumFractionDigits:fractionDigits];
//    [numberFormatter setMaximumIntegerDigits:integerDigits];
    [numberFormatter setMinimumIntegerDigits:integerDigits];
    numberFormatter.roundingMode = NSNumberFormatterRoundDown;
    numberFormatter.groupingSeparator = @",";
    numberFormatter.usesGroupingSeparator = YES;
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.decimalSeparator = @".";
    return [numberFormatter stringFromNumber:number];
}
@end
