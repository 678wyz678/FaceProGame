//
//  EarDecorationShadowNode.m
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "EarDecorationShadowNode.h"
#import "EarDecorationNode.h"
@implementation EarDecorationShadowNode
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        
        self=[super initWithImageNamed:name];    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= earDecoShadowLayerName  ;
        self.zPosition=0;
        self.tag=@"耳饰阴影";
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
    EarDecorationNode* parent= (EarDecorationNode*)[self parent];
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.currentEntity=entity;
return YES;
}

@end
