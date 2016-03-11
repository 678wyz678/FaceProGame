//
//  PackageIndexArray.m
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "PackageIndexArray.h"
static PackageIndexArray* instance;
@implementation PackageIndexArray
+(instancetype)singleton{
    if (!instance) {
        instance=[[PackageIndexArray alloc] init];
        instance.zombieIndexFiles=[NSMutableArray new];
        instance.futureIndexFiles=[NSMutableArray new];
        instance.animalIndexFiles=[NSMutableArray new];
        instance.rockIndexFiles=[NSMutableArray new];
        instance.bodyIndexFiles=[NSMutableArray new];
    }
    return instance;
}
@end
