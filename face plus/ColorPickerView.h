//
//  ColorPickerView.h
//  face plus
//
//  Created by Willian on 14/11/14.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorPickerView : UIView

+ (ColorPickerView *)presentBelowView:(UIView *)view;
- (void)popOver;
- (void)popOut;
- (void)popOut:(void (^)())block;
- (void)changeColor:(UIColor *)color;

@end
