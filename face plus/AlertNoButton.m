//
//  AlertNoButton.m
//  face plus
//
//  Created by linxudong on 1/19/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "AlertNoButton.h"

@implementation AlertNoButton
-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(clickNO) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)clickNO{
    NSNumber*isYes=[NSNumber numberWithBool:NO];
    NSDictionary*dict=NSDictionaryOfVariableBindings(isYes);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ALERT_RESULT" object:self userInfo:dict];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
