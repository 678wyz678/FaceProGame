//
//  FeaturePosition.m
//  face plus
//
//  Created by linxudong on 14/11/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "FeaturePosition.h"
static FeaturePosition* instance=nil;
@implementation FeaturePosition
+(instancetype)singleton{
    if (!instance) {
        instance=[[FeaturePosition alloc ]init];
    }
    return instance;
}

@end
