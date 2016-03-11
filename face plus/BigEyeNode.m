//
//  BigEyeNode.m
//  face plus
//
//  Created by linxudong on 12/23/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "BigEyeNode.h"
#import "ImportAllEntity.h"
@implementation BigEyeNode
-(instancetype) initWithImageNamed:(NSString *)name{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.zPosition=2;
        self.tag=@"大睛";
        self.name=leftBigEyeLayerName;
        self.anchorPoint=CGPointMake(0.5, 0.5);
    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
}

-(BOOL)changeTexture:(DoubleEyeEntity *)entity{
  
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfBigFile];
    
    self.texture=texture;
    CGSize parentSize=[self.parent calculateAccumulatedFrame].size;
    self.size=CGSizeMake(parentSize.width/self.parent.xScale, parentSize.height/self.parent.yScale);
    self.currentEntity=entity;
    return YES;
}

@end
