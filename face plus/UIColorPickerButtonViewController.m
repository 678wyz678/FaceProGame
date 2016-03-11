//
//  UIColorPickerButtonViewController.m
//  face plus
//
//  Created by Willian on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "UIColorPickerButtonViewController.h"
#import "UIColorPickerButton.h"
#import "UIColor+Library.h"

#import "ColorPicker.h"

//#import "ColorPickerPresentingAnimator.h"
//#import "ColorPickerDismissingAnimator.h"

#import "ColorPickerView.h"

@interface UIColorPickerButtonViewController ()

@property BOOL isShowing;

@end

@implementation UIColorPickerButtonViewController


- (void)touchUpInside:(UIColorPickerButton *)sender{
    [self switchPop:sender];
}
@synthesize isShowing;
- (void)switchPop:(UIColorPickerButton *)sender{
    ColorPickerView *shared = [[ColorPicker sharedInstance] pickerView];
    if (isShowing) {
        [shared popOut:^(){
            [sender popDown];
        }];
        isShowing = false;
    }else{
        if (!shared) {
            [self persentPanel];
        }else{
            [shared popOver];
        }
        [sender popUp];
        isShowing = true;
    }
}
- (void)dismissPop{
    ColorPickerView *shared = [[ColorPicker sharedInstance] pickerView];
    if (isShowing) {
        [shared popOut:^(){
            [[[ColorPicker sharedInstance] button] popDown];
        }];
        isShowing = false;
    }
}
- (void)persentPanel{
//    ColorPickerViewController *vc = [ColorPickerViewController new];
    [ColorPickerView presentBelowView:self.view];
//    vc.view = view;
}




@end
