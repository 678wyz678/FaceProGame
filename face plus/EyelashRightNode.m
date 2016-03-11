//
//  EyelashRightNode.m
//  face plus
//
//  Created by linxudong on 12/19/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "EyelashRightNode.h"

@implementation EyelashRightNode
@synthesize curAngle,curScaleFactor,bindActionNode;

-(instancetype) initWithImageNamed:(NSString *)name{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= eyelashRightLayerName;
        self.isViceSir=YES;
        self.dontRandomColor=YES;
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfPairFileName];
    self.currentEntity=entity;
    return self;
}
-(BOOL)changeTexture:(BaseEntity *)entity{
    
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfPairFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    self.currentEntity=entity;

    return YES;
    
}
@end
