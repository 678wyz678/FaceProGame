//
//  UIMenuForShake.m
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "UIMenuForShake.h"

@implementation UIMenuForShake
-(instancetype)init{
    if (self=[super init]) {
        //[self addTarget:self action:@selector(shake) forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(quitShaking) name:@"QUIT_SHAKE_MODE" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isShaking) name:@"RESET_ICONBUTTON" object:nil];

    }
    return self;
}
-(void)quitShaking{
    self.layer.borderColor=[UIColor clearColor].CGColor;
    self.layer.borderWidth=0.f;

    [self.layer removeAllAnimations];
}

-(void)isShaking{
    CGSize size=[self frame].size;
    self.layer.cornerRadius=size.width/2.f;
    self.layer.borderColor=[UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0x00/255.0 alpha:1] .CGColor;
    self.layer.borderWidth=2.0f;
    
   
    
    
    CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
    // animate from red to blue border ...
    color.fromValue = (id)[UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0x00/255.0 alpha:1].CGColor;
    color.toValue   = (id)[UIColor whiteColor].CGColor;
    // ... and change the model value
    color.repeatCount=HUGE_VALF;
    color.autoreverses=YES;
    color.duration=1.0;
    NSLog(@"闪烁");
    [self.layer addAnimation:color forKey:@"color"];
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)shake{
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_SHAKE_MODE" object:self];
}
@end
