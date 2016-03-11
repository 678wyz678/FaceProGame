//
//  FeatureArray.m
//  face plus
//
//  Created by linxudong on 14/11/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "FeatureArray.h"
static FeatureArray* instance=nil;
@implementation FeatureArray
+(instancetype)singleton{
    if (!instance) {
        instance=[[FeatureArray alloc] init];
        instance.faceArray=[[NSMutableArray alloc]init];
        instance.mouthArray=[[NSMutableArray alloc]init];
        instance.noseArray=[[NSMutableArray alloc]init];
        instance.eyeArray=[[NSMutableArray alloc]init];
        instance.earArray=[[NSMutableArray alloc]init];
        instance.browArray=[[NSMutableArray alloc]init];
        instance.hairArray=[[NSMutableArray alloc]init];
        instance.frontHairArray=[[NSMutableArray alloc]init];
        instance.behindHairArray=[[NSMutableArray alloc]init];

        instance.eyeballArray=[[NSMutableArray alloc]init];
        instance.whelkArray=[[NSMutableArray alloc]init];
        instance.glassArray=[[NSMutableArray alloc]init];
        instance.neckArray=[[NSMutableArray alloc]init];
        instance.capArray=[[NSMutableArray alloc]init];
        instance.backgroundArray=[[NSMutableArray alloc]init];
        
        
                [instance.backgroundArray addObject:@"back_star"];
        [instance.backgroundArray addObject:@"back_skull"];
       // [instance.backgroundArray addObject:@"back_"];

        
        //小胡子
        instance.beardArray=[[NSMutableArray alloc]init];
        //大胡子
        instance.whiskerArray=[[NSMutableArray alloc]init];

        instance.fontArray=[[NSMutableArray alloc]init];
    }
    return instance;
}
@end
