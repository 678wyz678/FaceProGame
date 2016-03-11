//
//  EyeLeftNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EyeLeftNode.h"
#import "Pixel2Point.h"
#import "EyeRightNode.h"
#import "EyeballNode.h"
#import "EyeballCropNode.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "Pixel2Point.h"
#import "MyScene.h"
#import "EyeballShadow.h"
#import "ImportAllEntity.h"
#import "GlobalVariable.h"
#import "BigEyeNode.h"
#import "RightEyeballCropNode.h"
#import "EyeLeftlid.h"
#import "UnderEyeLeftNode.h"
#import "UnderEyeRightNode.h"
#import "EyeRightlid.h"
@implementation EyeLeftNode
@synthesize curAngle;
@synthesize curScaleFactor;
@synthesize bindActionNode;
@synthesize curPosition;



-(instancetype)initWithEntity:(DoubleEyeEntity *)entity{
    
    self=[super initWithImageNamed:entity.selfSmallFile];
    if (self!=nil) {
        self.zPosition=91;
        self.name= eyeLeftLayerName  ;
        self.tag=@"眼睛(左)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=4;
        self.selectedPriority=11;
        
        BigEyeNode*  bigEyeNode=[[BigEyeNode alloc]initWithImageNamed:entity.selfBigFile];
        [self addChild:bigEyeNode];
        
        EyeballCropNode* crop=[[EyeballCropNode alloc]initWithEyeballName:@"eyeball_3" textureOfParent:self];
        [self addChild:crop];
        
        //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backUpEyeBallPosition) name:@"START_GESTURE" object:nil];

    }

    self.currentEntity=entity;
    return self;
    
}

-(void)syncRotate:(NSNumber*)angle{
    
    EyeRightNode* rightNode=(EyeRightNode*)self.bindActionNode;

   
    
    //眼睛转动
    [self setZRotation:self.curAngle+angle.floatValue];
    [rightNode setZRotation:rightNode.curAngle-angle.floatValue];
    
    
    NSValue* backUpPosition=[NSValue valueWithCGPoint:_backUpLeftEyeballPosition];
    NSValue* backupRightPosition=[NSValue valueWithCGPoint:_backUpRightEyeballPosition];
    //眼球反转
    NSNumber*reverseAngle=[NSNumber numberWithFloat:-angle.floatValue];
    NSDictionary*dict=NSDictionaryOfVariableBindings(reverseAngle,backUpPosition,backupRightPosition);

    EyeBallNode*leftEyeball=(EyeBallNode*)[[self childNodeWithName:eyeballCropLayerName] childNodeWithName:eyeballLayerName];
    EyeBallNode*rightEyeball=(EyeBallNode*)[[rightNode childNodeWithName:eyeballRightCropLayerName] childNodeWithName:eyeballLayerName];
    
    [leftEyeball receiveReverseRotationNotification:[NSNotification notificationWithName:@"Nothing" object:self userInfo:dict]];
    [rightEyeball receiveReverseRotationNotification:[NSNotification notificationWithName:@"Nothing" object:self userInfo:dict]];
    
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"Reverse_Rotation_Of_Eyeball" object:self userInfo:dict];
}

-(void)drag:(NSValue*)dest{
    FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    DPI300Node* pair=(DPI300Node*)[self bindActionNode];
    CGPoint pairPosition=CGPointMake(pair.curPosition.x-dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    
    EyeLeftlid*leftLid=(EyeLeftlid*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:leftEyelidLayerName];
     EyeRightlid*rightLid=(EyeRightlid*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:rightEyelidLayerName];
    
    
    UnderEyeLeftNode*leftUnderEye=(UnderEyeLeftNode*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:underEyeLeftLayerName];
    UnderEyeRightNode*rightUnderEye=(UnderEyeRightNode*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:underEyeRightLayerName];
    
    if (finalPosition.y<0&&finalPosition.y>=-[Pixel2Point pixel2point:face.texture.size].height) {
        
        
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pair.position.x, pairPosition.y)];
        }
        
        if (leftLid) {
            leftLid.position=CGPointMake(leftLid.position.x, leftLid.curPosition.y-dest.CGPointValue.y/12);
        }
        if (rightLid) {
            rightLid.position=CGPointMake(rightLid.position.x, rightLid.curPosition.y-dest.CGPointValue.y/12);

        }
        
        if (leftUnderEye) {
            leftUnderEye.position=CGPointMake(leftUnderEye.position.x, leftUnderEye.curPosition.y-dest.CGPointValue.y/12);
        }
        if (rightUnderEye) {
            rightUnderEye.position=CGPointMake(rightUnderEye.position.x, rightUnderEye.curPosition.y-dest.CGPointValue.y/12);
            
        }
    }
    
    
    if ( (finalPosition.x-pairPosition.x)<0&&finalPosition.x>-[Pixel2Point pixel2point:face.texture.size].width/2.0f) {
        
        
        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pairPosition.x, pair.position.y)];
        }
        
        if (leftLid) {
            leftLid.position=CGPointMake(leftLid.curPosition.x+dest.CGPointValue.x/12, leftLid.position.y);
        }
        if (rightLid) {
            rightLid.position=CGPointMake(rightLid.curPosition.x-dest.CGPointValue.x/12, rightLid.position.y);
            
        }
        if (leftUnderEye) {
            leftUnderEye.position=CGPointMake(leftUnderEye.curPosition.x+dest.CGPointValue.x/12, leftUnderEye.position.y);
        }
        if (rightUnderEye) {
            rightUnderEye.position=CGPointMake(rightUnderEye.curPosition.x-dest.CGPointValue.x/12, rightUnderEye.position.y);
            
        }
    }
    
}
-(void)syncDrag:(NSValue *)dest{
    EyeRightNode* pair=(EyeRightNode*)[self bindActionNode];
  
    FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    CGPoint pairPosition=CGPointMake(pair.curPosition.x+dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];
    
    
    EyeLeftlid*leftLid=(EyeLeftlid*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:leftEyelidLayerName];
    EyeRightlid*rightLid=(EyeRightlid*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:rightEyelidLayerName];
    
    UnderEyeLeftNode*leftUnderEye=(UnderEyeLeftNode*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:underEyeLeftLayerName];
    UnderEyeRightNode*rightUnderEye=(UnderEyeRightNode*)[[face childNodeWithName:faceCropLayerName] childNodeWithName:underEyeRightLayerName];
    
    if (finalPosition.y<0&&finalPosition.y>=-faceSize.height) {
        
        
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pair.position.x, pairPosition.y)];
        }
        if (leftLid) {
            leftLid.position=CGPointMake(leftLid.position.x, leftLid.curPosition.y-dest.CGPointValue.y/12);
        }
        if (rightLid) {
            rightLid.position=CGPointMake(rightLid.position.x, rightLid.curPosition.y-dest.CGPointValue.y/12);
            
        }
        
        if (leftUnderEye) {
            leftUnderEye.position=CGPointMake(leftUnderEye.position.x, leftUnderEye.curPosition.y-dest.CGPointValue.y/12);
        }
        if (rightUnderEye) {
            rightUnderEye.position=CGPointMake(rightUnderEye.position.x, rightUnderEye.curPosition.y-dest.CGPointValue.y/12);
            
        }
    }
    
    if ( (finalPosition.x-pairPosition.x)<0&&finalPosition.x>-faceSize.width/2.0f) {
        
        
        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pairPosition.x, pair.position.y)];
        }
        
        if (leftLid) {
            leftLid.position=CGPointMake(leftLid.curPosition.x+dest.CGPointValue.x/12, leftLid.position.y);
        }
        if (rightLid) {
            rightLid.position=CGPointMake(rightLid.curPosition.x+dest.CGPointValue.x/12, rightLid.position.y);
            
        }
        if (leftUnderEye) {
            leftUnderEye.position=CGPointMake(leftUnderEye.curPosition.x+dest.CGPointValue.x/12, leftUnderEye.position.y);
        }
        if (rightUnderEye) {
            rightUnderEye.position=CGPointMake(rightUnderEye.curPosition.x+dest.CGPointValue.x/12, rightUnderEye.position.y);
            
        }
        
    }
    
  }


-(void)setSize:(CGSize)size{
    [super setSize:size];
    BigEyeNode* bigNode=(BigEyeNode*)[self childNodeWithName:leftBigEyeLayerName];
    bigNode.size=CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale);
}

-(BOOL)changeTexture:(BaseEntity *)entity{

    //锁死动画
    if (![self hasActions]) {
        
       
        
        NSString* file=entity.selfFileName;
        if ([entity isKindOfClass:[DoubleEyeEntity class]]) {
            DoubleEyeEntity* finalEntity=(DoubleEyeEntity*)entity;
            file=finalEntity.selfSmallFile;
        }
        SKTexture* texture=[SKTexture textureWithImageNamed:file];
        CGFloat ratio=texture.size.height/texture.size.width;
        CGSize size=CGSizeMake(self.size.width, self.size.width*ratio*0.97);
        
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
            BigEyeNode*bigEyeNode=(BigEyeNode*)[self childNodeWithName:leftBigEyeLayerName];
            if (bigEyeNode) {
                [bigEyeNode setHidden:YES];
            }
        }
    
        SKAction* animation=[SKAction animateWithTextures:walkFrames timePerFrame:0.018 resize:NO restore:YES];
        animation.timingMode=SKActionTimingEaseOut;
        
        EyeballCropNode* crop=(EyeballCropNode*)[self childNodeWithName:eyeballCropLayerName];
        NSTimer*timer1=nil;
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
            EyeballCropNode* crop=(EyeballCropNode*)[self childNodeWithName:eyeballCropLayerName];
            if (crop) {
                [crop calculateBoundary:self];
            }
            if ([entity isKindOfClass:[DoubleEyeEntity class]]){
                BigEyeNode*bigEyeNode=(BigEyeNode*)[self childNodeWithName:leftBigEyeLayerName];
                if (bigEyeNode) {
                    [bigEyeNode setHidden:NO];
                }
            }

        }];
        
        
        if ([entity isKindOfClass:[EyeEntity class]]) {
            if ([self childNodeWithName:leftBigEyeLayerName]) {
                [[self childNodeWithName:leftBigEyeLayerName] removeFromParent];
                [self childNodeWithName:eyeballCropLayerName].hidden=YES;
            }
        }

        
        else if ([entity isKindOfClass:[DoubleEyeEntity class]]){
            
            [self childNodeWithName:eyeballCropLayerName].hidden=NO;

            
            DoubleEyeEntity*finalEntity=(DoubleEyeEntity*)entity;
            BigEyeNode*bigEyeNode=(BigEyeNode*)[self childNodeWithName:leftBigEyeLayerName];
            if (bigEyeNode) {
                [bigEyeNode changeTexture:entity];
            }
            else{
           bigEyeNode=[[BigEyeNode alloc]initWithImageNamed:finalEntity.selfBigFile];
                bigEyeNode.size=self.size;
                [self addChild:bigEyeNode];
            }
            
            
        }
        self.currentEntity=entity;

        return YES;
    }
    return NO;
}


-(void)setTexture:(SKTexture *)texture{
    [super setTexture:texture];
}

-(void)zoom:(NSNumber*)scaleFactor{
    if(scaleFactor.floatValue*curScaleFactor
       <=1.8&&scaleFactor.floatValue*curScaleFactor
       >=0.12){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];

    }
}
-(void)color:(UIColor *)color{
    self.color=color;
    self.bindActionNode.color=color;
}
-(void)backUpEyeBallPosition{

    EyeballCropNode*leftCrop=(EyeballCropNode*)[self childNodeWithName:eyeballCropLayerName];
    EyeBallNode*leftEyeBall=(EyeBallNode*)[leftCrop childNodeWithName:eyeballLayerName];
    EyeBallNode*rightEyeBall=(EyeBallNode*)leftEyeBall.bindActionNode;

    MyScene*scene=[SKSceneCache singleton].scene;
    
    self.backUpRightEyeballPosition= [scene convertPoint:CGPointMake(rightEyeBall.position.x, rightEyeBall.position.y) fromNode:rightEyeBall.parent.parent];
    self.backUpLeftEyeballPosition= [scene convertPoint:leftEyeBall.position fromNode:self];

}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    if (self=[super initWithCoder:aDecoder]) {
      
        self.backUpLeftEyeballPosition=   ((NSValue*)[aDecoder decodeObjectForKey:@"backUpLeftEyeballPosition"]).CGPointValue;
        self.backUpRightEyeballPosition=   ((NSValue*)[aDecoder decodeObjectForKey:@"backUpRightEyeballPosition"]).CGPointValue;
          //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backUpEyeBallPosition) name:@"START_GESTURE" object:nil];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[NSValue valueWithCGPoint:_backUpLeftEyeballPosition] forKey:@"backUpLeftEyeballPosition"];
    [aCoder encodeObject:[NSValue valueWithCGPoint:_backUpRightEyeballPosition] forKey:@"backUpRightEyeballPosition"];

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
