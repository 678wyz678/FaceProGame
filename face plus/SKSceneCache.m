//
//  SKSceneCache.m
//  face plus
//
//  Created by linxudong on 14/11/7.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "SKSceneCache.h"
#import "MyScene.h"
static SKSceneCache* instance=nil;

@implementation SKSceneCache
+(instancetype)singleton{
    if (!instance) {
        instance=[[super alloc ]init];
    }
    return instance;
}


//用来从encoder的来源
+(void)changeInstance:(MyScene*)scene{
    if (!instance) {
        instance=[[super alloc ]init];
    }
    instance.scene=scene;
}


//instance nil???
+(BOOL)instanceIsNil{
    if (instance) {
        return NO;
    }
    return YES;
}
@end
