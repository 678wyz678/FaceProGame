//
//  UIColor+UIColor_Library.m
//  face plus
//
//  Created by Willian on 14/11/12.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "UIColor+Library.h"

#import <ASCFlatUIColor/ASCFlatUIColor.h>

@implementation UIColor (Library)

+ (UIColor *)colorWithFlatUIColorType:(ASCFlatUIColorType)type{
    return [ASCFlatUIColor colorWithFlatUIColorType:type];
}
+ (UIColor *)colorWithStandardrizedInt:(int )number{
    int maxNumber = 19;
    if (number<0) {
        number = 0;
    }
    if (number>maxNumber) {
        number = maxNumber;
    }
    return [self colorWithFlatUIColorType:number];
}

@end
