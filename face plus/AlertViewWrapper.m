//
//  AlertViewWrapper.m
//  face plus
//
//  Created by linxudong on 1/19/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "AlertViewWrapper.h"
#import "UIView+PopAnimation.h"
@implementation AlertViewWrapper
-(void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (!hidden) {
        [self popUp];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
