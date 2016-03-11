//
//  PresentMiddleObject.m
//  face plus
//
//  Created by linxudong on 15/2/13.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "PresentMiddleObject.h"
static PresentMiddleObject *instance;
@implementation PresentMiddleObject
+(instancetype)singleton{
    if (!instance) {
        instance=[[PresentMiddleObject alloc]init];
    }
    return instance;
}
@end
