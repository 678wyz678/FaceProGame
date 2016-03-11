//
//  NoseShadowNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "NoseShadowNode.h"
#import "NoseNode.h"
#import "GlobalVariable.h"
@implementation NoseShadowNode
////不需要实际实现zoom，因为是作为鼻子的委托，操作的事鼻子本身
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= noseShadowLayerName  ;
        self.zPosition=1;
        self.tag=@"鼻子阴影";
        self.anchorPoint=CGPointMake(0.5, 0);
    }
    return self;
}

//切换素材
-(void)changeTexture:(BaseEntity *)entity{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];

    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //重置scale
   // self.xScale=1.0;
    //self.yScale=1.0;
    //与父层同大
    NoseNode* parent= ((NoseNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    
}

@end
