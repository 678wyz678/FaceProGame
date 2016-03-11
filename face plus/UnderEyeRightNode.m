//
//  UnderEyeRightNode.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "UnderEyeRightNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "EyeRightNode.h"
#import "MyScene.h"
#import "SKSceneCache.h"
@implementation UnderEyeRightNode
@synthesize bindActionNode;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= underEyeRightLayerName ;
        self.tag=@"右眼影";
        self.dontRandomColor=YES;
    }
    return self;
}

-(instancetype) initWithEntity:(BaseEntity *)entity{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    self=[self initWithImageNamed:entity.selfPairFileName];
    self.isViceSir=YES;
    self.currentEntity=entity;
    
    
    SKScene* scene= [SKSceneCache singleton].scene;
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    EyeRightNode*eyeRight=(EyeRightNode*)[face childNodeWithName:eyeRightLayerName];
    self.size=CGSizeMake(eyeRight.size.width*1.2, self.size.height/self.size.width*eyeRight.size.width*1.2);
    self.position=eyeRight.position;

    return self;
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    //self.xScale=1.0;
    //self.yScale=1.0;
    
    //  SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfPairFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    self.currentEntity=entity;
return YES;
    
}
-(void)color:(UIColor *)color{
    self.color=color;
}


@end
