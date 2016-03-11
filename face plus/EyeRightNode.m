//
//  EyeRightNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EyeRightNode.h"
#import "Pixel2Point.h"
#import "EyeLeftNode.h"
#import "FaceNode.h"
#import "RightEyeballCropNode.h"
#import "SKSceneCache.h"
#import "Pixel2Point.h"
#import "MyScene.h"
#import "GlobalVariable.h"
#import "ImportAllEntity.h"
#import "RightBigEyeNode.h"
#import "RightEyeballCropNode.h"

@implementation EyeRightNode
@synthesize curScaleFactor;
@synthesize bindActionNode;
@synthesize curPosition;
@synthesize curAngle;

-(void)syncRotate:(NSNumber *)angle{
}

-(instancetype)initWithEntity:(DoubleEyeEntity *)entity{
    self=[super initWithImageNamed:entity.pairSmallFile];
    
    if (self!=nil) {
        self.name= eyeRightLayerName  ;
        self.zPosition=95;
        self.tag=@"眼睛(右)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=4;
        self.selectedPriority=11;
        
        
        
        RightBigEyeNode*  bigEyeNode=[[RightBigEyeNode alloc]initWithImageNamed:entity.pairBigFile];
        bigEyeNode.size=self.size;
        [self addChild:bigEyeNode];
        
        RightEyeballCropNode* crop=[[RightEyeballCropNode alloc]initWithEyeballName:@"eyeball_3" textureOfParent:self];
        
        
        [self addChild:crop];
        
    }
    self.currentEntity=entity;
    return self;
    
}
-(void)setSize:(CGSize)size{
    [super setSize:size];
    BigEyeNode* bigNode=(BigEyeNode*)[self childNodeWithName:rightBigEyeLayerName];
    bigNode.size=CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale);
}

-(void)rotateMyself:(NSNumber*)angle{
//    EyeLeftNode* leftNode=(EyeLeftNode*)self.bindActionNode;
//    SKAction * action=[SKAction rotateToAngle:self.curAngle+angle.floatValue duration:0];
//    SKAction * reverse=[SKAction rotateToAngle:leftNode.curAngle-angle.floatValue duration:0];
//    [self runAction:action]; 
//    [leftNode runAction:reverse];
}

-(void)drag:(NSValue*)dest{

}
-(void)syncDrag:(NSValue *)dest{
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    //锁死动画
    if (![self hasActions]) {
        NSString* file=entity.selfPairFileName;
        if ([entity isKindOfClass:[DoubleEyeEntity class]]) {
            DoubleEyeEntity* finalEntity=(DoubleEyeEntity*)entity;
            file=finalEntity.pairSmallFile;
        }
        
        SKTexture* texture=[SKTexture textureWithImageNamed:file];
        
        CGFloat ratio=texture.size.height/texture.size.width;
        CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
        self.texture=texture;
        
        SKTextureAtlas *bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Blink"];
        NSMutableArray *walkFrames=[[NSMutableArray alloc]init];
        int numImages = 8;
        for (int i=0; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"e%d", i];
            SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
            [walkFrames addObject:temp];
        }
        
        if ([entity isKindOfClass:[DoubleEyeEntity class]]){
            BigEyeNode*bigEyeNode=(BigEyeNode*)[self childNodeWithName:rightBigEyeLayerName];
            if (bigEyeNode) {
                [bigEyeNode setHidden:YES];
            }
        }
        
        SKAction* animation=[SKAction animateWithTextures:walkFrames timePerFrame:0.018 resize:NO restore:YES];
        animation.timingMode=SKActionTimingEaseOut;
        
        
        RightEyeballCropNode* crop=(RightEyeballCropNode*)[self childNodeWithName:eyeballRightCropLayerName];
        NSTimer*timer1;
        if (crop) {
            __weak typeof(self) weakSelf=self;
            __weak typeof(crop) weakCrop=crop;

            timer1=[NSTimer timerWithTimeInterval:0.007 target:weakCrop selector:@selector(calculateBoundaryWithTimer:) userInfo:@{@"Parent_Node":weakSelf} repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:timer1 forMode:NSRunLoopCommonModes];
        }

        
        [self runAction:animation completion:^{
            self.size=size;
            if (timer1) {
                [timer1 invalidate];
            }
            
            
            RightEyeballCropNode* crop=(RightEyeballCropNode*)[self childNodeWithName:eyeballRightCropLayerName];
            if (crop) {
                [crop calculateBoundary:self];
            }
            if ([entity isKindOfClass:[DoubleEyeEntity class]]){
                RightBigEyeNode*bigEyeNode=(RightBigEyeNode*)[self childNodeWithName:rightBigEyeLayerName];
                if (bigEyeNode) {
                    [bigEyeNode setHidden:NO];
                }
            }
            
        }];

        
        
        if ([entity isKindOfClass:[EyeEntity class]]) {
            if ([self childNodeWithName:rightBigEyeLayerName]) {
                [[self childNodeWithName:rightBigEyeLayerName] removeFromParent];
            }
            [self childNodeWithName:eyeballRightCropLayerName].hidden=YES;
        }
        
        else if ([entity isKindOfClass:[DoubleEyeEntity class]]){
            DoubleEyeEntity*finalEntity=(DoubleEyeEntity*)entity;
            RightBigEyeNode*bigEyeNode=(RightBigEyeNode*)[self childNodeWithName:rightBigEyeLayerName];
            [self childNodeWithName:eyeballRightCropLayerName].hidden=NO;

            if (bigEyeNode) {
                [bigEyeNode changeTexture:entity];
            }
            else{
                bigEyeNode=[[RightBigEyeNode alloc]initWithImageNamed:finalEntity.pairBigFile];
                  bigEyeNode.size=self.size;
                [self addChild:bigEyeNode];
            }
        }
    
        self.currentEntity=entity;
return YES;
    }
   return NO;
}

-(void)zoom:(NSNumber*)scaleFactor{
    CGSize faceTextureSize=[Pixel2Point pixel2point:((FaceNode*)self.parent).texture.size];

    //宽和高同时小于指定边界
    if(self.size.width*scaleFactor.floatValue*curScaleFactor
       <=faceTextureSize.width*0.5&&self.size.height*scaleFactor.floatValue*curScaleFactor
       <=faceTextureSize.width*0.5
       &&self.size.width*scaleFactor.floatValue*curScaleFactor
       >=faceTextureSize.width*0.05&&self.size.height*scaleFactor.floatValue*curScaleFactor
       >=faceTextureSize.width*0.05){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
    }
}
-(void)color:(UIColor *)color{
    self.color=color;
}

-(void)setColor:(UIColor *)color{
    [super setColor:color];
}

@end
 