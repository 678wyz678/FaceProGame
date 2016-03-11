//
//  ColorView.m
//  face plus
//
//  Created by linxudong on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ColorView.h"
#import <pop/POP.h>
//颜色拾取的颜色view
@implementation ColorView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    self.layer.cornerRadius = 6.0;
    self.clipsToBounds = YES;
}


@end
