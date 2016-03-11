//
//  DefaultEntity.m
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "DefaultEntity.h"
static DefaultEntity* instance;
@implementation DefaultEntity
+(instancetype)singleton{
    if (!instance) {
        instance=[[DefaultEntity alloc]init];
    }
    return instance;
}
@end
