//
//  FeaturePackageArray.m
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "FeaturePackageArray.h"
static FeaturePackageArray* instance=nil;

@implementation FeaturePackageArray
+(instancetype)singleton{
    if (!instance) {
        instance=[[FeaturePackageArray alloc] init];
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

        
        instance.beardArray=[[NSMutableArray alloc]init];
        instance.whiskerArray=[[NSMutableArray alloc]init];

        instance.fontArray=[[NSMutableArray alloc]init];
    }
    return instance;
}

+(void)reset{
   
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
    
    
    instance.beardArray=[[NSMutableArray alloc]init];
    instance.whiskerArray=[[NSMutableArray alloc]init];

    instance.fontArray=[[NSMutableArray alloc]init];
}

@end
