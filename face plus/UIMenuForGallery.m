//
//  UIMenuForGallery.m
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "UIMenuForGallery.h"

@implementation UIMenuForGallery
-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(gallery) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)gallery{
    NSString*Controller=@"Gallery_Controller";
    NSString*Storyboard=@"Main";
    NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
}
@end
