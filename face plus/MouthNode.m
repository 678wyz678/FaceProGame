//
//  MouthNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "MouthNode.h"
#import "Pixel2Point.h"
#import "MouthMask.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation MouthNode
@synthesize curAngle;
@synthesize  curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= mouthLayerName;
        self.zPosition=98;
        self.tag=@"嘴巴";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=8;
        self.selectedPriority=9;
        self.color=UIColorFromRGB(0xce7a89);
        MouthMask* mouthMask=[[MouthMask alloc]initWithImageNamed:@"mouth_shadow_4"];
        [self addChild:mouthMask];
    }
    return self;
}


-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
    
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    
    if(scaleFactor.floatValue*curScaleFactor
       <=2.4&&scaleFactor.floatValue*curScaleFactor
       >=0.3){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}

-(void)drag:(NSValue*)dest{
    MyScene* scene=[SKSceneCache singleton].scene ;
    
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
   // CGSize point=[Pixel2Point pixel2point:face.texture.size];
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y-dest.CGPointValue.y/12 );
    
    
    
   CGPoint coordinateInScene= [scene convertPoint:finalPosition fromNode:face];
    
    CGFloat yLimit=scene.size.height/2.0;
    CGFloat xLimit=scene.size.width/2.0;

    if (coordinateInScene.y <yLimit && coordinateInScene.y>(-yLimit)) {
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
    }
     if(coordinateInScene.x>-xLimit&&coordinateInScene.x<xLimit){
         [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
    }
    
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);

    self.texture=texture;
    self.size=size;
    
    if (entity.selfShadowFileName) {
        if ([self childNodeWithName:mouthMaskLayerName]) {
            MouthMask* mouthMask=(MouthMask*)[self childNodeWithName:mouthMaskLayerName];
            [mouthMask changeTexture:entity];
        }
        else{
            MouthMask* mouthMask=[[MouthMask alloc]initWithImageNamed:entity.selfShadowFileName];
            [self addChild:mouthMask];
        }
    }
    else{
        if ([self childNodeWithName:mouthMaskLayerName]) {
            [[self childNodeWithName:mouthMaskLayerName] removeFromParent];
        }
    }

    self.currentEntity=entity;
    return YES;
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
 
}
-(void)rotateMyself:(NSNumber*)angle{
          [self setZRotation:self.curAngle+angle.floatValue];
}

@end
