//
//  ShakeOption.m
//  face plus
//
//  Created by linxudong on 2/27/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ShakeOption.h"
static ShakeOption* instance;
@implementation ShakeOption
+(instancetype)singleton{
    if (!instance) {
        instance=[[ShakeOption alloc]init];
        instance.readyForNextShake=YES;
    }
    return instance;
}
@end
