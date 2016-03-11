//
//  ColorPickerView.m
//  face plus
//
//  Created by Willian on 14/11/14.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ColorPickerView.h"
#import "ColorPicker.h"
#import "UIColorPickerButton.h"
#import "ColorPickerPanelViewController.h"
#import "ColorPickerPanelView.h"
#import "UIColor+IsDark.h"
#import <pop/POP.h>

@interface ColorPickerView ()

@property (weak , nonatomic) ColorPickerPanelView *panelView;
@property (weak , nonatomic) UIView *summonerView;
@property (strong , nonatomic) ColorPickerPanelViewController *panelViewController;

@end


@implementation ColorPickerView

#pragma mark init methods

const int panelMargin = 10;
const int panelMarginTop = 5;

@synthesize panelView;
@synthesize summonerView;
+ (ColorPickerView *)presentBelowView:(UIView *)view{
    ColorPickerView *shared = [[ColorPicker sharedInstance] pickerView];
    if (shared) {
        NSLog(@"Already persented the View, try *show* it");
        return shared;
    }
    // Instantiating encapsulated here.
    ColorPickerView *this = [[ColorPickerView alloc] init];
    this.summonerView = view;
    
    UIView *superView = this.summonerView.window.subviews.firstObject;
    
    //[this setStyle];
    
    [[ColorPicker sharedInstance] setPickerView:this];
    [superView addSubview:this];
    //[pickerView initPanel];
    [this popFirstWithCompletion:^(POPAnimation *animation, BOOL finished) {
        [this popOver];
    }];
    
    return this;
}
- (CGRect)cgRectWithFrameToPutUpOn:(CGRect)frame{
    
    CGFloat width   = self.window.frame.size.width - panelMargin*2;
    CGFloat y       = frame.origin.y + frame.size.height +panelMarginTop;
    CGRect newRect = CGRectMake(panelMargin,y,width,self.window.frame.size.height - y - panelMargin);
    return newRect;
}
- (void)setStyle{
    [self.layer setCornerRadius:8.f];
    [self changeColor:[ColorPicker currentColor]];
    [self.layer setOpacity:0];
}
- (void)changeColor:(UIColor *)color{
    [self setBackgroundColor:color];
    if ([color isDark]) {
        [panelView setMode:ColorPickerPanelColorModeDark];
    }else{
        [panelView setMode:ColorPickerPanelColorModeLight];
    }
    
}
- (void)initConstraints:(UIView *)view{
    self.autoresizesSubviews = NO;
    view.translatesAutoresizingMaskIntoConstraints = false;
    //[view removeConstraints:self.constraints];
    NSArray *constraints =@[[NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:1
                                                          constant:0],
                            [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1
                                                          constant:0],
                            [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1
                                                          constant:0.0],
                            [NSLayoutConstraint constraintWithItem:view
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0.0]
                            ];
    [constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *obj, NSUInteger idx, BOOL *stop) {
        [obj setPriority:UILayoutPriorityRequired];
    }];
    [self addConstraints:constraints];
    [view setNeedsLayout];
}

- (void)initPanel{
    self.panelViewController = [ColorPickerPanelViewController new];
    [self addSubview:self.panelViewController.view];
    panelView = (ColorPickerPanelView *)self.panelViewController.view;
    [self initConstraints:self.panelViewController.view];
}
#pragma mark behaviors
- (CGRect)popOutLocation{
    CGRect oriRect = [summonerView frame];
    CGRect newRect = CGRectOffset(oriRect, oriRect.size.width/2, oriRect.size.height +panelMarginTop);
    return newRect;
}
- (void)popFirstWithCompletion:(void (^)(POPAnimation *animation, BOOL finished))block{
    [self setFrame:[self cgRectWithFrameToPutUpOn:summonerView.frame]];
    POPBasicAnimation *sizeFirst = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerSize];
    sizeFirst.toValue = [NSValue valueWithCGSize:[self cgRectWithFrameToPutUpOn:summonerView.frame].size];
    sizeFirst.duration = 0.01;
    [self.layer pop_addAnimation:sizeFirst forKey:@"picker-view.pop-over.size-first"];
    
    self.layer.anchorPoint = CGPointZero;
    
    POPBasicAnimation *positionFirst = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionFirst.toValue = [NSValue valueWithCGRect:[self popOutLocation]];
    positionFirst.duration = 0.01;
    [positionFirst setCompletionBlock:block];

    POPBasicAnimation *scaleFirst = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleFirst.toValue = [NSValue valueWithCGSize:CGSizeMake(.05f, .05f)];
    scaleFirst.duration = 0.01;
    [scaleFirst setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self.layer pop_addAnimation:positionFirst forKey:@"picker-view.pop-over.position-first"];
    }];
    
    [self.layer pop_addAnimation:scaleFirst forKey:@"picker-view.pop-over.scale-first"];
}
- (void)popOver{
    [self pop_removeAllAnimations];
    [self.layer pop_removeAllAnimations];
    self.layer.anchorPoint = CGPointZero;
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 12;
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
   [self.layer pop_addAnimation:scaleAnimation forKey:@"picker-view.pop-over.scale"];
    
    POPBasicAnimation *opcacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opcacityAnimation.toValue = @(1.f);
    [self.layer pop_addAnimation:opcacityAnimation forKey:@"picker-view.pop-over.opacity"];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animation];
    positionAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPosition];
    positionAnimation.duration = 0.25;
    positionAnimation.toValue = [NSValue valueWithCGRect:[self cgRectWithFrameToPutUpOn:[summonerView frame]]];
    [self.layer pop_addAnimation:positionAnimation forKey:@"picker-view.pop-over.position"];
}
- (void)popOut{
    [self popOut:nil];
}
- (void)popOut:(void (^)())block{
    [self pop_removeAllAnimations];
    [self.layer pop_removeAllAnimations];
    self.layer.anchorPoint = CGPointZero;
    
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(.05f, .05f)];
    scaleAnimation.duration = 0.3;
    [self.layer pop_addAnimation:scaleAnimation forKey:@"picker-view.pop-over.scale-down"];
    
    POPBasicAnimation *opcacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opcacityAnimation.toValue = @(0.f);
    opcacityAnimation.duration = 0.3;
    [opcacityAnimation setCompletionBlock:^(POPAnimation *ani, BOOL stop) {
        if(block != nil){
            block();
        }
    }];
    [self.layer pop_addAnimation:opcacityAnimation forKey:@"picker-view.pop-over.opacity-down"];
    
    POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPosition];
    positionAnimation.duration = 0.3;
    positionAnimation.toValue = [NSValue valueWithCGRect:[self popOutLocation]];
    
    [self.layer pop_addAnimation:positionAnimation forKey:@"picker-view.pop-over.position-down"];
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initPanel];
        [self setStyle];
    }
    return self;
}

/**
 *  = viewWillLoad
 *
 */
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    [super drawRect:rect];
//
//}

@end
