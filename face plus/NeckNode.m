//
//  NeckNode.m
//  face plus
//
//  Created by linxudong on 14/12/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "NeckNode.h"
#import "GlobalVariable.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GaussianBlurNode.h"
#define defaultSkinColor {0xfaebd9,0xbf9f86,0x93765f}
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation NeckNode
@synthesize curScaleFactor,curAngle;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= neckLayerName  ;
        self.zPosition=-2;
        self.tag=@"脖子";
        self.anchorPoint=CGPointMake(1, 0);
        self.order=15;
        self.selectedPriority=6;
        self.color=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"SkinColor" object:nil];
        
        int a[3]=defaultSkinColor;
        //背景设置
        int lowerBound = 0;
        int upperBound = 2;
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        self.color=UIColorFromRGB(a[rndValue]);
        
        

        
        GaussianBlurNode* blurNode=[[GaussianBlurNode alloc]initWithParentNode:self];
         blurNode.position=CGPointMake(0, 0);
        [self addChild:blurNode];
        

    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;

}

-(void)setSize:(CGSize)size{
    [super setSize:size];
    GaussianBlurNode* blurNode=(GaussianBlurNode*)[self childNodeWithName:gaussianBlurLayerName];
    if (blurNode) {
        [blurNode reSizeBlur:[NSValue valueWithCGSize:CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale)]];
    }
}
-(void)drag:(NSValue*)dest{
   // FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
  //  CGSize point=[Pixel2Point pixel2point:face.texture.size];
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y /6);
   // if ((finalPosition.y+self.size.height)<0&&finalPosition.y>-point.height) {

    [self setPosition:finalPosition];
    //}
    
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    if(scaleFactor.floatValue*curScaleFactor
       <=4&&scaleFactor.floatValue*curScaleFactor
       >=0.5){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
    
}
-(BOOL)changeTexture:(BaseEntity *)entity{
    FaceNode*face=(FaceNode*)[self.scene childNodeWithName:faceLayerName];
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(face.size.width/face.xScale*0.18, face.size.width/face.xScale*0.18*ratio);
    
    self.texture=texture;
    self.size=size;
    
      
    self.currentEntity=entity;
    return YES;
}

-(void)receiveColorNotification:(NSNotification*)notification{
    UIColor* color=[notification.userInfo objectForKey:@"color"];
    if (color) {
        self.color=color;
    }
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    NSDictionary* dict=NSDictionaryOfVariableBindings(color);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SkinColor" object:self userInfo:dict];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"SkinColor" object:nil];
    }
    return self;
}


-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}
@end
