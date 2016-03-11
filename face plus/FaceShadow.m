//
//  FaceShadow.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "FaceShadow.h"
#import "FaceNode.h"
#import "GlobalVariable.h"
@implementation FaceShadow

-(instancetype)init{
    return  [self initWithImageNamed:nil];
    
}


-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        SKTexture * texture=[SKTexture textureWithImageNamed:name] ;
        self=[super initWithTexture:texture];
    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= faceShadowLayerName  ;
        self.zPosition=1;
        self.tag=@"脸部阴影";
        self.anchorPoint=CGPointMake(0, 1);
        self.position=CGPointZero;
    }
    return self;
}

//注意父层锚点(0,0)
-(void)changeTexture:(BaseEntity *)entity{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //重置scale
    self.xScale=1.0;
    self.yScale=1.0;
    //与父层同大
    FaceNode* parent= ((FaceNode*)[self parent]);
   self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;

}
@end
