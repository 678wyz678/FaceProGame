//
//  BrowRightNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "BrowRightNode.h"
#import "Pixel2Point.h"
#import "BrowLeftNode.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "Pixel2Point.h"
#import "GlobalVariable.h"
#import "BrowShadow.h"
#import "BrowEntity.h"
@implementation BrowRightNode
@synthesize curAngle;
@synthesize curScaleFactor;
@synthesize bindActionNode;
@synthesize curPosition;
-(instancetype) initWithImageNamed:(NSString *)name{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= browRightLayerName  ;
        self.zPosition=98;
        self.tag=@"眉毛(右)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=6;
        self.selectedPriority=10;
        self.color=[UIColor grayColor];

    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfPairFileName];
    self.currentEntity=entity;
    return self;
    
}
-(void)syncRotate:(NSNumber *)angle{
}

-(void)drag:(NSValue*)dest{
    BrowLeftNode* pair=(BrowLeftNode*)[self bindActionNode];
    CGPoint point=CGPointMake(dest.CGPointValue.x*-1, dest.CGPointValue.y);
    [pair drag:[NSValue valueWithCGPoint:point]];
}

-(BOOL)changeTexture:(BrowEntity *)entity{
   // self.xScale=1.0;
   // self.yScale=1.0;
    
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfPairFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    self.currentEntity=entity;
return YES;
}

-(void)zoom:(NSNumber*)scaleFactor{
    CGSize faceTextureSize=[Pixel2Point pixel2point:((FaceNode*)self.parent).texture.size];

    //宽和高同时小于指定边界
    if(self.size.width*scaleFactor.floatValue*curScaleFactor
       <=faceTextureSize.width*0.6&&self.size.height*scaleFactor.floatValue*curScaleFactor
       <=faceTextureSize.width*0.6
       &&self.size.width*scaleFactor.floatValue*curScaleFactor
       >=faceTextureSize.width*0.06&&self.size.height*scaleFactor.floatValue*curScaleFactor
       >=faceTextureSize.width*0.06){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
    }
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;

}

@end
