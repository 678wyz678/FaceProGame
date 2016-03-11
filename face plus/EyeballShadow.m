//
//  EyeballShadow.m
//  face plus
//
//  Created by linxudong on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EyeballShadow.h"
#import "EyeBallNode.h"
#import "GlobalVariable.h"
#import <UIKit/UIKit.h>
@implementation EyeballShadow
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        
        self=[super initWithImageNamed:name];    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= eyeballShadowLayerName  ;
        self.zPosition=-1;
        self.tag=@"眼球shadow";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.position=CGPointZero;
        self.blendMode=SKBlendModeAlpha;
        self.selectable=NO;
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfShadowFileName];
    self.currentEntity=entity;
    return self;
    
}
//切换素材
-(BOOL)changeTexture:(BaseEntity *)entity{
    
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];

    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //与父层同大
    EyeBallNode* parent= ((EyeBallNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.currentEntity=entity;
    return YES;
}

@end
