//
//  ColorPickerPanelView.h
//  face plus
//
//  Created by Willian on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ColorPickerPanelView : UIView

typedef enum {
    ColorPickerPanelColorModeLight,
    ColorPickerPanelColorModeDark
}ColorPickerPanelColorMode;

@property () ColorPickerPanelColorMode mode;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *button;
- (IBAction)dismissPressed:(UIButton *)sender;

@end
