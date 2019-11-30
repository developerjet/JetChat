//
//  NSString+ShowRoundNumber.h
//  iOS-RoundNumber
//
//  Created by colin on 16/7/3.
//  Copyright © 2016年 CHwang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ShowRoundNumber)

/**
 *  Return a string from the provided float value. The float value is plain rounded in the way specified by scale. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Float value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string from the provided float value. The float value is rounded in the way specified by scale and roundingMode. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Float value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param mode     The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string containing the fraction digits of the provided float value. The float value is rounded in the way specified by scale and roundingMode.
 *
 *  @param value          Float value.
 *  @param scale          The number of digits a rounded value should have after its decimal point.
 *  @param mode           The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)stringFromFloat:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits;

/**
 *  Return a string from the provided double value. The double value is plain rounded in the way specified by scale. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Double value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string from the provided double value. The double value is rounded in the way specified by scale and roundingMode. The rounded value could be padded by zero to conform fraction digits to the scale.
 *
 *  @param value    Double value.
 *  @param scale    The number of digits a rounded value should have after its decimal point.
 *  @param mode     The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param isPadded If YES, allows the rounded value be padded by zero to conform fraction digits to the scale.(1.399 -> 1.4 -> 1.40)
 */
+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigitsPadded:(BOOL)isPadded;

/**
 *  Return a string containing the fraction digits of the provided double value. The double value is rounded in the way specified by scale and roundingMode.
 *
 *  @param value          Double value.
 *  @param scale          The number of digits a rounded value should have after its decimal point.
 *  @param mode           The rounding mode to use. There are four possible values: NSRoundUp, NSRoundDown, NSRoundPlain, and NSRoundBankers.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)stringFromDouble:(float)value roundingScale:(short)scale roundingMode:(NSRoundingMode)mode fractionDigits:(NSUInteger)fractionDigits;

/**
 *  Returns a string containing the fraction digits of the provided number object.
 *
 *  @param number         An NSNumber object that is parsed to create the returned string object.
 *  @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;


/**
 Returns a string containing the fraction digits of the provided number object. round

 @param number An NSNumber object that is parsed to create the returned string object.
 @param fractionDigits The number of digits after the decimal separator allowed as input and output by the receiver.
 */
+ (NSString *)stringRoundPlainFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits;


+ (NSString *)stringFromNumber:(NSNumber *)number fractionDigits:(NSUInteger)fractionDigits IntegerDigits:(NSUInteger)integerDigits;
@end
