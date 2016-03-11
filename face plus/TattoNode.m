//
//  TattoNode.m
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "TattoNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
@implementation TattoNode
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= tattooLayerName;
        self.zPosition=1;
        self.tag=@"纹身";
        self.blendMode=SKBlendModeAlpha;
        self.alpha=0.1;
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=16;//素材列表位置
        self.selectedPriority=12;
        FaceNode*face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
        
        CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];
        if (face) {
            self.position=CGPointMake(faceSize.width/2, -faceSize.width/2);
        }
        
    
        
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
    
}
-(void)drag:(NSValue*)dest{
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );
    [self setPosition:finalPosition];
    
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGSize size= [Pixel2Point pixel2point:texture.size];
    //转换历史scale后的大小
    self.size=CGSizeMake(size.width*self.xScale, size.height*self.yScale);
    self.texture=texture;
    
    self.currentEntity=entity;

   return YES;
}

-(void)zoom:(NSNumber*)scaleFactor{
    CGSize faceTextureSize=[Pixel2Point pixel2point:((FaceNode*)self.parent.parent).texture.size];
    
    //宽和高同时小于指定边界
    if(self.size.width*scaleFactor.floatValue*curScaleFactor
       <=faceTextureSize.width*1.5&&self.size.height*scaleFactor.floatValue*curScaleFactor
       <=faceTextureSize.width*1.5
       &&self.size.width*scaleFactor.floatValue*curScaleFactor
       >=faceTextureSize.width*0.1&&self.size.height*scaleFactor.floatValue*curScaleFactor
       >=faceTextureSize.width*0.1){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}
-(void)color:(UIColor *)color{
    self.color=color;
}
@end
