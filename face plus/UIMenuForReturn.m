//
//  UIMenuForReturn.m
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "UIMenuForReturn.h"

@implementation UIMenuForReturn
//-(instancetype)init{
//    if (self=[super init]) {
//        [self addTarget:self action:@selector(popViewController) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return self;
//}

-(void)popViewController{
       [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_ONE_CONTROLER" object:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
