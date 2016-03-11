//
//  RightBigEyeNode.m
//  face plus
//
//  Created by linxudong on 12/23/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "RightBigEyeNode.h"
#import "ImportAllEntity.h"
@implementation RightBigEyeNode
-(instancetype) initWithImageNamed:(NSString *)name{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.tag=@"右大睛";
        self.zPosition=3;
        self.name=rightBigEyeLayerName;
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
}

-(BOOL)changeTexture:(DoubleEyeEntity *)entity{
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.pairBigFile];
   
    self.texture=texture;
    self.currentEntity=entity;
   return YES;
}
@end
