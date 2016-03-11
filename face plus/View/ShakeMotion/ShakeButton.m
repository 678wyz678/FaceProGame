//
//  ShakeButton.m
//  face plus
//
//  Created by linxudong on 14/12/2.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ShakeButton.h"
#import "ShakeModeDelegate.h"
@implementation ShakeButton
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    
    if (self) {
        _delegate=[[ShakeModeDelegate alloc]init];
               SEL toggle=@selector(toggleMode);
        [self addTarget:_delegate action:toggle forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}
@end
