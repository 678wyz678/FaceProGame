//
//  FirstScreenScene.m
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "FirstScreenScene.h"
#import "Pixel2Point.h"
@interface SmileNode : SKSpriteNode

@end

@implementation SmileNode
-(instancetype)initWithImageNamed:(NSString *)name{
    if (self=[super initWithImageNamed:name]) {
        CGSize screenSize=[UIScreen mainScreen].bounds.size;
        self.colorBlendFactor=1.0;
        self.color=[UIColor colorWithRed:0xe1/255.0f green:0xe8/255.0f blue:0xf6/255.0f alpha:1];
        self.size=CGSizeMake(screenSize.width*0.718, self.texture.size.height/self.texture.size.width*screenSize.width*0.718);
        self.anchorPoint=CGPointMake(0.5, 0.75);
    }
    return self;
}
@end


@interface RightEye : SKSpriteNode

@end

@implementation RightEye
-(instancetype)initWithImageNamed:(NSString *)name{
    if (self=[super initWithImageNamed:name]) {
        SKAction * action1=[SKAction scaleTo:0.8 duration:3];
        SKAction * action2=[SKAction scaleTo:0.92 duration:3];
        SKAction* series=[SKAction sequence:@[action1,action2] ];
        SKAction * repeat=[SKAction repeatActionForever:series];
        [self runAction:repeat];
    }
    return self;
}
@end


@interface Nose : SKSpriteNode

@end

@implementation Nose
-(instancetype)initWithImageNamed:(NSString *)name{
    if (self=[super initWithImageNamed:name]) {
       
    }
    return self;
}
@end


@interface LeftEye : SKSpriteNode

@end

@implementation LeftEye
-(instancetype)initWithImageNamed:(NSString *)name{
    if (self=[super initWithImageNamed:name]) {
        self.name=@"FirstScreenGoShake";
        SKAction * action1=[SKAction scaleTo:0.82 duration:3];
        SKAction * action2=[SKAction scaleTo:0.58 duration:3];
        SKAction* series=[SKAction sequence:@[action1,action2] ];
        SKAction * repeat=[SKAction repeatActionForever:series];
        [self runAction:repeat];
    }
    return self;
}
@end





@interface FirstScreenScene()
@property SmileNode* smailNode;
@end
@implementation FirstScreenScene
-(instancetype)initWithSize:(CGSize)size{
    self=[super initWithSize:size];
    if (self) {
        [self.view setFrameInterval:20];
        ////建立缓存
        //设立锚点
        self.anchorPoint=CGPointMake(0.5, 0.58);
        self.scaleMode=SKSceneScaleModeAspectFill;
        self.physicsWorld.gravity=CGVectorMake(0, 0);
        
        //加载笑脸
        _smailNode=[[SmileNode alloc]initWithImageNamed:@"FirstScreenSmile"];
        [_smailNode runAction:[SKAction moveBy:CGVectorMake(20, -85) duration:0]];
        [_smailNode setScale:1.36];
        
          //在笑脸上加眼睛
        RightEye*rightEye=[[RightEye alloc]initWithImageNamed:@"FirstScreenStart"];
        rightEye.name=@"Start";
        rightEye.size=CGSizeMake(_smailNode.size.width*0.38/_smailNode.xScale, _smailNode.size.width*0.38/_smailNode.yScale);
        rightEye.anchorPoint=CGPointMake(0.5, 1);
        rightEye.position=CGPointMake(_smailNode.size.width*0.05, _smailNode.size.height*0.054);
        [_smailNode addChild:rightEye];
        
        LeftEye* leftEye=[[LeftEye alloc]initWithImageNamed:@"FirstScreenStore"];
        [leftEye setScale:0.68];
        leftEye.anchorPoint=CGPointMake(0.5, 1);
        leftEye.position=CGPointMake(-_smailNode.size.width*0.222,- _smailNode.size.height*0.05);
        [_smailNode addChild:leftEye];
 
        SKSpriteNode* mouth=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenMouth"];
        mouth.size=CGSizeMake(118, 37.92);
        mouth.position=CGPointMake(-_smailNode.size.width*0.023, -_smailNode.size.height*0.224);
        [_smailNode addChild:mouth];
        
        
        SKCropNode* mouthCrop=[[SKCropNode alloc]init];
        SKSpriteNode* mouthCopy=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenMouth"];
        mouthCopy.size=CGSizeMake(118, 37.92);
        mouthCopy.position=CGPointZero;
        mouthCrop.maskNode=mouthCopy;
        [mouth addChild:mouthCrop];
    
        
        
                SKSpriteNode*settingToothNode=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenSetting"];
                settingToothNode.position=CGPointMake(-mouth.size.width*0.336,6);
        settingToothNode.size=CGSizeMake(26.5, 26.5);
                [settingToothNode setName:@"setting"];
                [mouthCrop addChild:settingToothNode];

                SKSpriteNode*galleryToothNode=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenTeam"];
                galleryToothNode.position=CGPointMake(-mouth.size.width*0.114,-1);
        galleryToothNode.size=CGSizeMake(26.5, 26.5);

                [galleryToothNode setName:@"team"];
                [mouthCrop addChild:galleryToothNode];
        
        SKSpriteNode*TeamToothNode=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenHistory"];
        TeamToothNode.position=CGPointMake(mouth.size.width*0.112,0);
        TeamToothNode.size=CGSizeMake(26.5, 26.5);
        
        [TeamToothNode setName:@"gallery"];
        [mouthCrop addChild:TeamToothNode];
        
        SKSpriteNode*StoreToothNode=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenStore2"];
        StoreToothNode.position=CGPointMake(mouth.size.width*0.33,7);
        StoreToothNode.size=CGSizeMake(26.5, 26.5);
        
        [StoreToothNode setName:@"store"];
        [mouthCrop addChild:StoreToothNode];
        
        
        
        
        SKSpriteNode* mouthMask=[SKSpriteNode spriteNodeWithImageNamed:@"FirstScreenMouthShadow0"];
        mouthMask.size=CGSizeMake(118, 37.92);
        mouthMask.position=CGPointMake(-_smailNode.size.width*0.023, -_smailNode.size.height*0.224);
        [_smailNode addChild:mouthMask];
        

//        

        [self addChild:_smailNode];
        
        
        
           }
    return self;
}

-(void)reset{
//    SKNode* settingNode=[_smailNode childNodeWithName:@"setting"];
//    settingNode.position=CGPointMake(-_smailNode.size.width*0.185,-_smailNode.size.height*0.262);
//    settingNode.physicsBody.dynamic=NO;
//    
//    SKNode* galleryNode=[_smailNode childNodeWithName:@"gallery"];
//   galleryNode.position=CGPointMake(-_smailNode.size.width*0.097,-_smailNode.size.height*0.286);
//    galleryNode.physicsBody.dynamic=NO;
//
//    
//    SKNode* teamNode=[_smailNode childNodeWithName:@"team"];
//    teamNode.position=CGPointMake(-_smailNode.size.width*0.006,-_smailNode.size.height*0.289);
//   teamNode.physicsBody.dynamic=NO;

}

@end

