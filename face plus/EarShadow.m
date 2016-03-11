//
//  EarShadow.m
//  face plus
//
//  Created by linxudong on 12/8/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "EarShadow.h"
#import "GlobalVariable.h"
#import "EarNode.h"

@implementation EarShadow
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
        
        SKTexture* texture=[SKTexture textureWithImageNamed:name];
        self=[super initWithTexture:texture];
    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= earShadowLayerName  ;
        self.zPosition=0;
        self.tag=@"耳朵阴影";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.position=CGPointZero;
    }
    return self;
}

//注意父层锚点(0,0)
-(void)changeTexture:(BaseEntity *)entity{
 //   SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //重置scale
    self.xScale=1.0;
    self.yScale=1.0;
    //与父层同大
    EarNode* parent= ((EarNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.position=CGPointZero;

    
}
@end
