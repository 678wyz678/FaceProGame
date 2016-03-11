//
//  UIColorPickerButton.m
//  face plus
//
//  Created by Willian on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "UIColorPickerButton.h"
#import "UIColorPickerButtonViewController.h"
#import "ColorPicker.h"
#import <pop/POP.h>
#import "UIImage+Color.h"

@interface UIColorPickerButton ()

@property (weak,nonatomic) ColorPicker *colorPicker;
@property (strong,nonatomic,readwrite) UIColorPickerButtonViewController *controller;

@end

@implementation UIColorPickerButton
@synthesize colorPicker;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        colorPicker = [ColorPicker sharedInstance];
        [self changeToColor:[colorPicker currentColor]];
        [colorPicker setButton:self];
        [self setController:[UIColorPickerButtonViewController new]];
        [self.controller setView:self];

        SEL touchSelector = @selector(touchUpInside:);
        if ([self.controller respondsToSelector:touchSelector]) {
            [self addTarget:self.controller action:touchSelector forControlEvents:UIControlEventTouchUpInside];
        }else{
            NSLog(@"Nothing is responding to 「touch up inside」 event!");
        }
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.5;
    self.layer.shadowRadius = 1;
    self.layer.shadowOffset = CGSizeMake(0, 1.0f);
    [super drawRect:rect];
}

- (void)popDown{
    [self setUserInteractionEnabled:false];
    [self.layer pop_removeAllAnimations];
    POPSpringAnimation *upAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    upAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    upAnimation.springBounciness = 30;
    
    POPBasicAnimation *downAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    downAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    downAnimation.duration = 0.1;
    [downAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self setUserInteractionEnabled:true];
        [self.layer pop_addAnimation:upAnimation forKey:@"color-picker.button.pop-down.up"];
    }];
    [self.layer pop_addAnimation:downAnimation forKey:@"color-picker.button.pop-down.down"];
}

- (void)popUp{
    [self setUserInteractionEnabled:false];
    [self.layer pop_removeAllAnimations];
    POPSpringAnimation *downAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    downAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    downAnimation.springBounciness = 30;
    
    POPBasicAnimation *upAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    upAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2f, 1.2f)];
    upAnimation.duration = 0.1;
    [upAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self setUserInteractionEnabled:true];
        [self.layer pop_addAnimation:downAnimation forKey:@"color-picker.button.pop-up.down"];
    }];
    [self.layer pop_addAnimation:upAnimation forKey:@"color-picker.button.pop-up.up"];
}

- (void)changeToColor:(UIColor *)color{
    UIImage *coloredImage = [self.imageView.image imageWithTint:color];
    [self setImage:coloredImage forState:UIControlStateNormal];
}

@end
