//
//  ColorPicker.h
//  face plus
//
//  Created by Willian on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIColor;

@protocol ColorPickerDelegate <NSObject>

@required

/**
 *  Called when User trys to pick a color from the Color Picker
 *
 *  @param color The Color User picked.
 *
 *  @return Set to 「false」 to refuse to change color
 */
- (BOOL)shouldChangeColorTo:(UIColor *)color;

@end

@class ColorPickerView;
@class UIColorPickerButton;
@class UIColorPickerButtonViewController;
@interface ColorPicker : NSObject

/**
 *  Get the shared Instance
 *  ( You should not use the instance unless you know what you are doing )
 *
 *  @return the Color Picker itself
 */
+ (ColorPicker *)sharedInstance;
+ (UIColor *)currentColor;

@property (strong,nonatomic) UIColor *currentColor;
/**
 *  You should not set or get this unless you know what you are doing
 */
@property (weak,nonatomic) ColorPickerView *pickerView;
/**
 *  You should not set or get this unless you know what you are doing
 */
@property (weak,nonatomic) UIColorPickerButton *button;
/**
 *  Set the delegate to recieve and decide what to do on a color pick Event occurred
 *
 *  @param id the delegate
 */
+ (void)setDelegate:(id<ColorPickerDelegate> )delegate;
/**
 *  You should not set or get this unless you know what you are doing
 */
@property (weak,nonatomic) id<ColorPickerDelegate> delegate;

/**
 *  Call this when you change the Object user choson which has a different color to the privous one 
 *  or you manually changed the color somehow
 *
 *  @param color The new color changed to.
 */
+ (void)didChangeColorTo:(UIColor *)color;

/**
 *  Tells The Color Piker to hide the panel if shown
 */
+ (void)hidePanel;

@end
