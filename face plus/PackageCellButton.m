//
//  PackageCellButton.m
//  face plus
//
//  Created by linxudong on 1/13/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "PackageCellButton.h"

@implementation PackageCellButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(mouseEnter) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(mouseLeave) forControlEvents:UIControlEventTouchUpInside];
        [self addTarget:self action:@selector(mouseLeave) forControlEvents:UIControlEventTouchCancel];

    }
    return self;
}


-(void)mouseEnter{
    BaseEntity*entity=self.entity;
    NSDictionary* dict=NSDictionaryOfVariableBindings(entity);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newOperationWithReverse" object:self userInfo:dict];
    
}
-(void)mouseLeave{
 
 NSTimer* timer=   [NSTimer timerWithTimeInterval:0.01 target:self selector:@selector(recover) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
}
-(void)recover{
    BaseEntity*entity=self.entity;
    NSDictionary* dict=NSDictionaryOfVariableBindings(entity);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"BackwardOperation" object:self userInfo:dict];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
