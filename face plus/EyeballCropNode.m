//
//  EyeballNode.m
//  face plus
//
//  Created by linxudong on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EyeballCropNode.h"
#import "EyeballNode.h"
#import <SpriteKit/SpriteKit.h>
#import "EyeballShadow.h"
#import "DefaultEntity.h"
@implementation EyeballCropNode

-(instancetype) initWithEyeballName:(NSString*)eyeballName textureOfParent:(DPI300Node*)parentNode{
    self=[super init];
    if (self!=nil) {
        self.name=eyeballCropLayerName;
        
        EyeBallNode* eyeball=[[EyeBallNode alloc]initWithEntity:[DefaultEntity singleton].eyeballEntity];
        SKSpriteNode* mask=[[SKSpriteNode alloc]initWithTexture:parentNode.texture];
        mask.anchorPoint=CGPointMake(0.5, 0.5);
        
        self.position=CGPointZero;
        self.maskNode=mask;
        [self addChild:eyeball];

        }
    return self;
}

-(void)calculateBoundaryWithTimer:(NSTimer*)timer{
    SKSpriteNode* parentNode=[timer.userInfo objectForKey:@"Parent_Node"];
    SKSpriteNode*mask= [[SKSpriteNode alloc]initWithTexture:parentNode.texture];
    mask.size=CGSizeMake(parentNode.size.width/parentNode.xScale, parentNode.size.height/parentNode.yScale);
    self.maskNode=mask;
    mask.anchorPoint=CGPointMake(0.5, 0.5);
    mask.position=CGPointZero;
}


-(void)calculateBoundary:(DPI300Node*)parentNode{
    SKSpriteNode*mask= [[SKSpriteNode alloc]initWithTexture:parentNode.texture];
    mask.size=CGSizeMake(parentNode.size.width/parentNode.xScale, parentNode.size.height/parentNode.yScale);
    self.maskNode=mask;
    mask.anchorPoint=CGPointMake(0.5, 0.5);
    mask.position=CGPointZero;
}
@end
