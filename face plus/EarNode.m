//
//  EarNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EarNode.h"
#import "FeatureLayer.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "GlobalVariable.h"
#import <UIKit/UIKit.h>
#import "GaussianBlurNode.h"
#define defaultSkinColor {0xfaebd9,0xbf9f86,0x93765f}
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation EarNode
@synthesize curPosition,curScaleFactor,curAngle;

-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= earLayerName ;
        self.zPosition=-1;
        self.tag=@"耳朵";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=11;
        self.selectedPriority=6;
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
-(void)drag:(NSValue*)dest{
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y-dest.CGPointValue.y/12 );
    [self setPosition:finalPosition];
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    if(scaleFactor.floatValue*curScaleFactor
       <=2.6&&scaleFactor.floatValue*curScaleFactor
       >=0.5){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}

-(void)setSize:(CGSize)size{
    [super setSize:size];
    GaussianBlurNode* blurNode=(GaussianBlurNode*)[self childNodeWithName:gaussianBlurLayerName];
    if (blurNode) {
        [blurNode reSizeBlur:[NSValue valueWithCGSize:CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale)]];
    }
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    if (![self hasActions]) {
       
        SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
        
        CGFloat ratio=texture.size.height/texture.size.width;
        CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
        
        
        
        SKTextureAtlas *bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Bomb"];
        NSMutableArray *walkFrames=[[NSMutableArray alloc]init];
        int numImages = 38;
        for (int i=26; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"bomb_%d", i];
            SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
            
            [walkFrames addObject:temp];
        }
        self.texture=texture;
        SKAction* animation=[SKAction animateWithTextures:walkFrames timePerFrame:0.022 resize:NO restore:YES];
        animation.timingMode=SKActionTimingEaseOut;
        [self runAction:animation completion:^{
            
            //self.texture=texture;
            self.size=size;
            GaussianBlurNode* blurNode=(GaussianBlurNode*)[self childNodeWithName:gaussianBlurLayerName];
            if (blurNode) {
                [blurNode changeTexture:entity.selfFileName];
            }
            
        }];
        self.currentEntity=entity;
return YES;
    }


    return NO;
   
}


-(void)receiveColorNotification:(NSNotification*)notification{
    UIColor* color=[notification.userInfo objectForKey:@"color"];
    if (color) {
        self.color=color;
    }
}
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
