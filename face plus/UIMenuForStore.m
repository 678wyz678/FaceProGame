//
//  UIMenuForStore.m
//  face plus
//
//  Created by linxudong on 1/8/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "UIMenuForStore.h"

@implementation UIMenuForStore

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(store) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(store) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)store{
    NSString*Controller=@"Store";
    NSString*Storyboard=@"Main";
    NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
