//
//  IconButtonForScrollView.m
//  face plus
//
//  Created by linxudong on 14/12/2.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "IconButtonForScrollView.h"

@implementation IconButtonForScrollView
@synthesize isSelected=_isSelected;
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    self.layer.cornerRadius=self.frame.size.width/2.01;
    self.layer.borderWidth=2.0;
    self.layer.borderColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2].CGColor;

    if (self) {
        
        _isSelected=false;
        SEL toggle=@selector(toggleSelected);
            [self addTarget:self action:toggle forControlEvents:UIControlEventTouchUpInside];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationForLightOn) name:@"lightOn" object:nil];

            }
    
    return self;
}
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected=isSelected;
    if (isSelected) {
        self.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    else{
        self.layer.borderColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.2].CGColor;

    }
}
//是否被选中
-(void)toggleSelected{
    NSDictionary * info;
   // NSNumber*isSelected=@0;
    NSNumber *  index=[[NSNumber alloc] initWithInteger:self.tag];
    
    if(_isSelected){
        //isSelected=@0;
                self.isSelected=NO;
    }
    else{
         //isSelected=@1;
        self.isSelected=YES;
        
    }
    
   // info=NSDictionaryOfVariableBindings(index,isSelected);
    info=[NSDictionary dictionaryWithObjectsAndKeys:index,@"index",[NSNumber numberWithBool:_isSelected],@"isSelected", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cjx" object:self userInfo:info];
}

//不管发送什么全部重置成未选中状态
-(void)receiveNotificationForLightOn{
    self.isSelected=false;

}

@end
