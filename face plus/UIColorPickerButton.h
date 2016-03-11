//
//  UIColorPickerButton.h
//  face plus
//
//  Created by Willian on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIColorPickerButtonViewController;
@interface UIColorPickerButton : UIButton

@property (strong,nonatomic,readonly) UIColorPickerButtonViewController *controller;
- (void)popDown;
- (void)popUp;
- (void)changeToColor:(UIColor *)color;

@end
