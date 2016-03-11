//
//  UIView+PopAnimation.m
//  face plus
//
//  Created by linxudong on 14/12/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "UIView+PopAnimation.h"
#import <pop/POP.h>
@implementation UIView (PopAnimation)
-(void)popUp{
    [self setUserInteractionEnabled:false];
    [self.layer pop_removeAllAnimations];
    POPSpringAnimation *downAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    downAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    downAnimation.springBounciness = 20;
    
    POPBasicAnimation *upAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    upAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.2f, 1.2f)];
    upAnimation.duration = 0.1;
    [upAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self setUserInteractionEnabled:true];
        [self.layer pop_addAnimation:downAnimation forKey:@"color-picker.button.pop-up.down"];
    }];
    [self.layer pop_addAnimation:upAnimation forKey:@"color-picker.button.pop-up.up"];
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

-(void)breathPOP{
    [self setUserInteractionEnabled:false];
    [self.layer pop_removeAllAnimations];
    POPBasicAnimation *upAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    POPBasicAnimation *downAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];

    upAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    upAnimation.duration=2.2;
    
    [upAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self setUserInteractionEnabled:true];
        [self.layer pop_addAnimation:downAnimation forKey:@"color-picker.button.pop-down.up"];
    }];
    
    downAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.8f, 0.8f)];
    downAnimation.duration = 2.2;
    [downAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        [self setUserInteractionEnabled:true];
        [self.layer pop_addAnimation:upAnimation forKey:@"color-picker.button.pop-down.up"];
    }];
    [self.layer pop_addAnimation:downAnimation forKey:@"color-picker.button.pop-down.down"];
}



@end
