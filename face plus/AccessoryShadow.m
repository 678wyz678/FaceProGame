//
//  AccessoryShadow.m
//  face plus
//
//  Created by linxudong on 15/1/28.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "AccessoryShadow.h"
#import "AccessoryNode.h"
@implementation AccessoryShadow
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        
        self=[super initWithImageNamed:name];    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= accessoryShadowLayerName  ;
        self.zPosition=0;
        self.tag=@"附件shadow";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.position=CGPointZero;
        self.blendMode=SKBlendModeAlpha;
        self.selectable=NO;
    }
    return self;
}


-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfShadowFileName];
    return self;
}


//切换素材
-(BOOL)changeTexture:(BaseEntity *)entity{
    
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //与父层同大
    AccessoryNode* parent= ((AccessoryNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    return YES;
}
@end

