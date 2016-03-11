//
//  ColorPickerPanelView.m
//  face plus
//
//  Created by Willian on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ColorPickerPanelView.h"
#import "ColorPicker.h"

@implementation ColorPickerPanelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (ColorPickerPanelColorMode)mode{
    if (self.title.textColor == [UIColor whiteColor]) {
        return ColorPickerPanelColorModeDark;
    }
    return ColorPickerPanelColorModeLight;
}
- (void)setMode:(ColorPickerPanelColorMode )mode{
    if(         mode == ColorPickerPanelColorModeDark){
        self.title.textColor = [UIColor whiteColor];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if (  mode == ColorPickerPanelColorModeLight){
        self.title.textColor = [UIColor blackColor];
        [self.button setTitleColor:self.tintColor forState:UIControlStateNormal];
    }
}
- (IBAction)dismissPressed:(UIButton *)sender {
    [ColorPicker hidePanel];
}
@end
