//
//  HairShadow.m
//  face plus
//
//  Created by linxudong on 14/11/16.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "HairShadow.h"
#import "GlobalVariable.h"
#import "HairNode.h"
@implementation HairShadow
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= hairShadowLayerName  ;
        self.zPosition=0;
        self.tag=@"头发阴影";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.position=CGPointZero;
      //  self.blendMode=SKBlendModeMultiply;
    }
    return self;
}

//切换素材
-(void)changeTexture:(BaseEntity *)entity{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //重置scale
    // self.xScale=1.0;
    //self.yScale=1.0;
    //与父层同大
    HairNode* parent= ((HairNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    
}
@end
