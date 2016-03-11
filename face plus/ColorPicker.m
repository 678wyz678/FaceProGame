//
//  ColorPicker.m
//  face plus
//
//  Created by Willian on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ColorPicker.h"
#import "UIColorPickerButton.h"
#import "UIColorPickerButtonViewController.h"
#import "ColorPickerView.h"

@implementation ColorPicker

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.currentColor = [UIColor whiteColor];
    }
    return self;
}
+ (void)setDelegate:(id<ColorPickerDelegate> )delegate{
    [[self sharedInstance] setDelegate:delegate];
}
+ (ColorPicker *)sharedInstance{
    static ColorPicker *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[ColorPicker alloc] init];
    });
    return _sharedInstance;
}

+ (UIColor *)currentColor{
    return [[self.class sharedInstance] currentColor];
}
+ (void)didChangeColorTo:(UIColor *)color{
    ColorPicker *instance = [self.class sharedInstance];
    UIColorPickerButton *button = [instance button];
    ColorPickerView *pickerView = [instance pickerView];
    if (button != nil) {
        [button changeToColor:color];
    }
    if (pickerView != nil) {
        [pickerView changeColor:color];
    }
    instance.currentColor = color;
}
+ (void)hidePanel{
    ColorPicker *instance = [self.class sharedInstance];
    [[[instance button] controller] dismissPop];
}
@end
