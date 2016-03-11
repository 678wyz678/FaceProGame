//
//  FaceCropNode.m
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "FaceCropNode.h"
#import "FeatureLayer.h"
#import "DPI300Node.h"
@implementation FaceCropNode

-(instancetype) init{
    self=[super init];
    if (self!=nil) {
        self.name=faceCropLayerName;
    }
    return self;
}

-(void)calculateBoundary:(DPI300Node *)parentNode{
    SKSpriteNode*mask= [[SKSpriteNode alloc]initWithTexture:parentNode.texture];
    mask.size=CGSizeMake(parentNode.size.width/parentNode.xScale, parentNode.size.height/parentNode.yScale);
    self.maskNode=mask;
    mask.position=CGPointZero;
    mask.anchorPoint=parentNode.anchorPoint;
}
@end
