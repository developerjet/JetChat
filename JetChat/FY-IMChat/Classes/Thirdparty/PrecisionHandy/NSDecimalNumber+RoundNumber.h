//
//  NSDecimalNumber+RoundNumber.h
//  iOS-RoundNumber
//
//  Created by colin on 16/7/3.
//  Copyright © 2016年 CHwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDecimalNumber (RoundNumber)

/**
 *  Return a decimal number from float value, and rounds it off in the way specified by scale. The rounding mode is NSRoundPlain.
 *
 *  @param value Float value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 */
+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale;

/**
 *  Return a decimal number from float value, and rounds it off in the way specified by scale and roundingMode.
 *
 *  @param value Float value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 *  @param mode  The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 */
+ (NSDecimalNumber *)decimalNumberWithFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

/**
 *  Return a decimal number from double value, and rounds it off in the way specified by scale. The rounding mode is NSRoundPlain.
 *
 *  @param value Double value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 */
+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale;

/**
 *  Return a decimal number from double value, and rounds it off in the way specified by scale and roundingMode.
 *
 *  @param value Double value.
 *  @param scale The number of digits a rounded value should have after its decimal point.
 *  @param mode  The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 */
+ (NSDecimalNumber *)decimalNumberWithDouble:(double)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode;

#pragma mark - Round
/**
 *  Rounds a decimal number off in the way specified by scale. The rounding mode is NSRoundPlain.
 *
 *  @param scale The number of digits a rounded value should have after its decimal point.
 */
- (NSDecimalNumber *)roundToScale:(short)scale;

/**
 *  Rounds a decimal number off in the way specified by scale and roundingMode.
 *
 *  @param scale        The number of digits a rounded value should have after its decimal point.
 *  @param roundingMode The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 */
- (NSDecimalNumber *)roundToScale:(short)scale mode:(NSRoundingMode)roundingMode;

@end
