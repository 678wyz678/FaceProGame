//
//  AlertYesButton.m
//  face plus
//
//  Created by linxudong on 1/19/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "AlertYesButton.h"

@implementation AlertYesButton
-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(clickYes) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)clickYes{
    NSNumber*isYes=[NSNumber numberWithBool:YES];
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
