//
//  NSDecimalNumber+RoundNumber.m
//  iOS-RoundNumber
//
//  Created by colin on 16/7/3.
//  Copyright © 2016年 CHwang. All rights reserved.
//

#import "NSDecimalNumber+RoundNumber.h"

@implementation NSDecimalNumber (RoundNumber)

+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale
{
    return [[[NSDecimalNumber alloc] initWithFloat:value] roundToScale:scale];
}

+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [[[NSDecimalNumber alloc] initWithFloat:value] roundToScale:scale mode:mode];
}

+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale
{
    return [[[NSDecimalNumber alloc] initWithDouble:value] roundToScale:scale];
}

+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode
{
    return [[[NSDecimalNumber alloc] initWithDouble:value] roundToScale:scale mode:mode];
}

#pragma mark - Round
- (NSDecimalNumber *)roundToScale:(short)scale
{
    return [self roundToScale:scale mode:NSRoundPlain];
}

- (NSDecimalNumber *)roundToScale:(short)scale mode:(NSRoundingMode)roundingMode
{
    NSDecimalNumberHandler *handler = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:scale raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    return [self decimalNumberByRoundingAccordingToBehavior:handler];
}

@end
