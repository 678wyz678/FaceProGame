//
//  UIMenuForShare.m
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "UIMenuForShare.h"

@implementation UIMenuForShare
-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)share{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHARE_PHOTO" object:self];
}
@end
