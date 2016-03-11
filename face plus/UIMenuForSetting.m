//
//  UIMenuForSetting.m
//  face plus
//
//  Created by linxudong on 1/4/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "UIMenuForSetting.h"
#import "SettingTableViewController.h"

@implementation UIMenuForSetting
-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)setting{
    NSString*Controller=@"GlobalSetting";
    NSString*Storyboard=@"Main";
    NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
    }
@end
