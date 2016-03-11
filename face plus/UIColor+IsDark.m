//
//  UIColor+IsDark.m
//  face plus
//
//  Created by Willian on 14/11/23.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "UIColor+IsDark.h"

@implementation UIColor (IsDark)

- (BOOL)isDark;{
    const CGFloat *componentColors = CGColorGetComponents(self.CGColor);
    CGFloat colorBrightness = (componentColors[0] * 299) + (componentColors[1] * 587) + (componentColors[2] * 114);
    if (colorBrightness < 800){
        return true;
    }
    return false;
}
- (BOOL)isBright{
    return ![self isDark];
}

@end
