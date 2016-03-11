//
//  FaceMeasure.m
//  face plus
//
//  Created by linxudong on 14/11/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "FaceMeasure.h"
#import "FeaturePosition.h"
#import "Pixel2Point.h"
#import <SpriteKit/SpriteKit.h>
#import "SKSceneCache.h"
#import "MyScene.h"
#import "FeatureLayer.h"
#import "FaceNode.h"
#import "DPI300Node.h"
#import "BrowLeftNode.h"
@implementation FaceMeasure
//通过face texture来确定各个五官的位置
+(FeaturePosition*)measure:(SKTexture*)faceTexture {
    CGSize faceSize=[Pixel2Point pixel2point:faceTexture.size] ;
    FeaturePosition* position=[FeaturePosition singleton];
    //眉毛位置为半圆下方

    position.browLeftPosition=CGPointMake(-faceSize.width*0.35,-faceSize.height*0.383);
    position.browRightPosition=CGPointMake(faceSize.width*0.085,-faceSize.height*0.383);

   //鼻子位置(锚点:1,1)
    position.nosePosition=CGPointMake(-faceSize.width*0.13,-faceSize.height*0.5822);
    //嘴巴位置(锚点 0.5，0.5)
    position.mouthPosition=CGPointMake(-faceSize.width*0.122,-faceSize.height*0.8465);

    
    //眼睛(锚点 上方中心)
    position.leftEyePosition=CGPointMake(-faceSize.width*0.35, -faceSize.height*0.5416);
    position.rightEyePosition=CGPointMake(faceSize.width*0.085,-faceSize.height*0.5416);
    //头发
    position.hairPosition=CGPointMake(0, 0);
    //耳朵
    position.earPosition=CGPointMake(faceSize.width*0.46, -faceSize.height*0.6622);
    //脖子位置
    position.neckPosition=CGPointMake(faceSize.width*0.3, -faceSize.height*1.12);

    return position;
}


@end
