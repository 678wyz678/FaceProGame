//
//  ReLayout.m
//  face plus
//
//  Created by linxudong on 14/11/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ReLayout.h"
#import "FaceNode.h"
#import "NoseNode.h"
#import "MouthNode.h"
#import "EyeLeftNode.h"
#import "EyeRightNode.h"
#import "BrowLeftNode.h"
#import "BrowRightNode.h"
#import "HairNode.h"
#import "EarNode.h"
#import <SpriteKit/SpriteKit.h>
#import "FeaturePosition.h"
#import "Pixel2Point.h"
#import "EyeLeftNode.h"
#import "NoseShadowNode.h"
#import "HairNode.h"
#import "EyeballCropNode.h"
#import "EyeBallNode.h"
#import "EyeRightNode.h"
#import "EyeballShadow.h"
#import "NeckNode.h"
#import "GaussianBlurNode.h"
@implementation ReLayout
+(void)layout:(SKScene*)scene{
    FeaturePosition* position=[FeaturePosition singleton];
    
    
    
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    EyeLeftNode* eyeLeft=(EyeLeftNode*)[face childNodeWithName:eyeLeftLayerName];
    EyeRightNode* eyeRight=(EyeRightNode*)[face childNodeWithName:eyeRightLayerName];
    BrowLeftNode* browLeft=(BrowLeftNode*)[face childNodeWithName:browLeftLayerName];
    BrowRightNode* browRight=(BrowRightNode*)[face childNodeWithName:browRightLayerName];
    MouthNode* mouth=(MouthNode*)[face childNodeWithName:mouthLayerName];
    NoseNode* nose=(NoseNode*)[face childNodeWithName:noseLayerName];
    
    HairNode *hair=(HairNode*)[face childNodeWithName:hairLayerName];
    EarNode * ear=(EarNode*)[face childNodeWithName:earLayerName];
    NeckNode *neck=(NeckNode*)[face childNodeWithName:neckLayerName];
    
    eyeLeft.position=position.leftEyePosition;
    eyeRight.position=position.rightEyePosition;
    mouth.position=position.mouthPosition;
    nose.position=position.nosePosition;
    browLeft.position=position.browLeftPosition;
    browRight.position=position.browRightPosition;
   hair.position=position.hairPosition;
    ear.position=position.earPosition;
    ear.position=position.earPosition;
    neck.position=position.neckPosition;
    //因为face的大小不一定是320px宽，要做scale调整(注意face的scale会继承给下层)
    [self adjustScale:scene];
    
}


//因为face的大小不一定是320px宽，要做scale调整(注意face的scale会继承给下层)
+(void)adjustScale:(SKScene*)scene{
    
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];
    //CGSize screen_size=[UIScreen mainScreen].bounds.size;
    NSArray* children=[face children];
    if (children&&children.count>0) {
        [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[DPI300Node class]]) {
                DPI300Node* node=(DPI300Node*)obj;
                
                if ([node.name isEqualToString:hairLayerName]) {
                    node.size=CGSizeMake(faceSize.width, node.size.height/node.size.width*faceSize.width);
                }

                //左眼左眉毛
              else  if ([node.name isEqualToString:browLeftLayerName]) {
                  CGFloat height=faceSize.height*0.100201;
                  node.size=CGSizeMake(node.size.width/node.size.height*height,height);
                 }
                
              else  if ([node.name isEqualToString:eyeLeftLayerName]) {
                  CGFloat height=faceSize.height*0.2232;
                  node.size=CGSizeMake(node.size.width/node.size.height*height/0.97,height);

                  EyeballCropNode* cropNode=(EyeballCropNode*)[node childNodeWithName:eyeballCropLayerName];
                  if (cropNode) {
                      EyeBallNode* eyeball=  (EyeBallNode*) [cropNode childNodeWithName:eyeballLayerName];
                    EyeLeftNode* mask=(EyeLeftNode*) cropNode.maskNode;
                      mask.size=node.size;
                      CGFloat eyeballWidth=5;
                      eyeball.size=CGSizeMake(eyeballWidth, eyeball.size.height/eyeball.size.width*eyeballWidth);
                      EyeballShadow* eyeballShadow=(EyeballShadow*)[eyeball childNodeWithName:eyeballShadowLayerName];
                      eyeballShadow.size=eyeball.size;
                      
                      eyeball.position=CGPointMake(eyeballWidth*0.4, 0);

                      
                  }
                  
              }
                //右眼右眉毛
              else  if ([node.name isEqualToString:browRightLayerName]) {
                  CGFloat height=faceSize.height*0.100201;
                  node.size=CGSizeMake(node.size.width/node.size.height*height,height);

              }
              else  if ([node.name isEqualToString:eyeRightLayerName]) {
                  CGFloat height=faceSize.height*0.230201;
                  node.size=CGSizeMake(node.size.width/node.size.height*height,height);
                  EyeballCropNode* cropNode=(EyeballCropNode*)[node childNodeWithName:eyeballRightCropLayerName];
                  if (cropNode) {
                      EyeBallNode* eyeball=  (EyeBallNode*) [cropNode childNodeWithName:eyeballLayerName];
                      EyeRightNode* mask=(EyeRightNode*) cropNode.maskNode;
                      mask.size=node.size;
                      
                      
                      CGFloat eyeballWidth=5;
                      eyeball.size=CGSizeMake(eyeballWidth, eyeball.size.height/eyeball.size.width*eyeballWidth);
                      EyeballShadow* eyeballShadow=(EyeballShadow*)[eyeball childNodeWithName:eyeballShadowLayerName];
                      eyeballShadow.size=eyeball.size;
                      
                      eyeball.position=CGPointMake(eyeballWidth*0.4, 0);

                  }
              }
                //鼻子
              else  if ([node.name isEqualToString:noseLayerName]) {
                  CGFloat width=faceSize.width*0.4;
                  node.size=CGSizeMake(width, node.size.height/node.size.width*width);
                  NoseShadowNode* shadow=(NoseShadowNode*)[node childNodeWithName:noseShadowLayerName];
                  if (shadow) {
                      shadow.size=node.size;
                  }
              }
                //嘴巴
              else  if ([node.name isEqualToString:mouthLayerName]) {
                  CGFloat width=faceSize.width*0.38;
                  node.size=CGSizeMake(width, node.size.height/node.size.width*width);
                  MouthNode* mouthShadow=(MouthNode*)[node childNodeWithName:mouthMaskLayerName];
                  if (mouthShadow) {
                      mouthShadow.size=node.size;
                  }
              }
                //耳朵
              else  if ([node.name isEqualToString:earLayerName]) {
                  CGFloat width=faceSize.width*0.23;
                  node.size=CGSizeMake(width, node.size.height/node.size.width*width);
              }
                
                //脖子
              else  if ([node.name isEqualToString:neckLayerName]) {
                  CGFloat width=faceSize.width*0.23;
                  node.size=CGSizeMake(width, node.size.height/node.size.width*width);
              
              }
                
                

            }
        }];
        
    }
    
}



+(void)adjustFacePosition:(SKScene*)scene ratio:(NSNumber*)textureRatio{
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
 
    [self backupPosition:face ratio:textureRatio];

}



+(void)backupPosition:(SKNode*)node ratio:(NSNumber*)textureRatio{
    
    NSArray* children=[node children];
    if (children&&children.count>0) {
        [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            DPI300Node* temp=(DPI300Node*)obj;
            temp.position=[self pointMutiply:temp.position multiply:textureRatio.floatValue];
        }];
        
    }
    
}


+(CGPoint)pointMutiply:(CGPoint)point multiply:(CGFloat)num{
    CGPoint result=CGPointMake(point.x*num, point.y*num);
    return result;
}
@end
