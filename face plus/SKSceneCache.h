//
//  SKSceneCache.h
//  face plus
//
//  Created by linxudong on 14/11/7.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MyScene;
@interface SKSceneCache : NSObject
@property(nonatomic)MyScene* scene;
+(instancetype)singleton;
+(void)changeInstance:(MyScene*)scene;
+(BOOL)instanceIsNil;
@end
