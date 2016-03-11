//
//  CapShadow.m
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "CapShadow.h"
#import "CapNode.h"
@implementation CapShadow
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        
        self=[super initWithImageNamed:name];    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= capShadowLayerName  ;
        self.zPosition=0;
        self.tag=@"帽子shadow";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.position=CGPointZero;
        self.blendMode=SKBlendModeAlpha;
        self.selectable=NO;
        self.dontRandomColor=YES;
        
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
    CapNode* parent= ((CapNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.currentEntity=entity;
return YES;
}
@end
