//
//  UIColor+UIColor_Library.h
//  face plus
//
//  Created by Willian on 14/11/12.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <ASCFlatUIColor/ASCFlatUIColor.h>

@interface UIColor (Library)

+ (UIColor *)colorWithFlatUIColorType:(ASCFlatUIColorType)type;
+ (UIColor *)colorWithStandardrizedInt:(int )number;

@end
