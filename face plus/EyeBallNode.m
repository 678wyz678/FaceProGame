//
//  EyeBallNode.m
//  face plus
//
//  Created by linxudong on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EyeBallNode.h"
#import "EyeballShadow.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"
#import "EyeballCropNode.h"
#import "RightEyeballCropNode.h"
@implementation EyeBallNode
@synthesize curAngle;
@synthesize curScaleFactor;
@synthesize bindActionNode;
-(instancetype) initWithImageNamed:(NSString *)name{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= eyeballLayerName;
        self.zPosition=1;
        self.tag=@"眼珠子";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.size=CGSizeMake(32, 32);
        self.order=5;
        self.selectedPriority=12;
        self.blendMode=SKBlendModeAlpha;
        self.dontRandomColor=YES;
        
        
     
    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    
    EyeballShadow* shadow=[[EyeballShadow alloc]initWithImageNamed:entity.selfShadowFileName];
    shadow.color=[UIColor blackColor];
    [self addChild:shadow];
    shadow.size=self.size;
    shadow.position=self.position;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"EyeballColor" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReverseRotationNotification:) name:@"Reverse_Rotation_Of_Eyeball" object:nil];

    self.currentEntity=entity;
    return self;
    
}


-(BOOL) changeTexture:(BaseEntity *)entity{
    [self setScale:1.f];
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    EyeballShadow*shadow=(EyeballShadow*)[self childNodeWithName:eyeballShadowLayerName];
    [shadow changeTexture:entity];
    self.currentEntity=entity;
return YES;
}
-(void)receiveColorNotification:(NSNotification*)notification{
    UIColor* color=[notification.userInfo objectForKey:@"color"];
    if (color) {
      EyeballShadow* eyeballShadow= (EyeballShadow*) [self childNodeWithName:eyeballShadowLayerName];
        eyeballShadow.color=color;
    }
}

-(void)color:(UIColor *)color{
    NSDictionary* dict=NSDictionaryOfVariableBindings(color);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EyeballColor" object:self userInfo:dict];
}


-(void)setSize:(CGSize)size{
    [super setSize:size];
    
}
-(void)setPosition:(CGPoint)position{
    [super setPosition:position];
    }

-(void)drag:(NSValue*)dest{
    
   
   
    
    DPI300Node* parent=(DPI300Node*)[self parent].parent;
    CGFloat angle=parent.zRotation;
    
    CGPoint pariPosition=CGPointMake(
                -dest.CGPointValue.x*cos(angle)+dest.CGPointValue.y*sin(angle),
                dest.CGPointValue.x*sin(angle)+dest.CGPointValue.y*cos(angle)
                );
    
    CGPoint actualPosition=CGPointZero;
    
    //显然成立
        angle=-angle;
         actualPosition=CGPointMake(
                                           dest.CGPointValue.x*cos(angle)+dest.CGPointValue.y*sin(angle),
                                           -dest.CGPointValue.x*sin(angle)+dest.CGPointValue.y*cos(angle)
                                           );
    
    

    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+actualPosition.x/12.0,self.curPosition.y-actualPosition.y/12.0 );
    
    self.position=finalPosition;
    
//    CGPoint tempPoint=[self.scene convertPoint:finalPosition fromNode:self.parent.parent];
//    CGPoint pariPoint=[self.scene convertPoint:tempPoint toNode:self.bindActionNode.parent.parent];

    self.bindActionNode.position=CGPointMake(self.bindActionNode.curPosition.x+pariPosition.x/12.0,self.bindActionNode.curPosition.y-pariPosition.y/12.0 );
    
    }

    


-(void)zoom:(NSNumber*)scaleFactor{

    //宽和高同时小于指定边界
   
        

    if(scaleFactor.floatValue*curScaleFactor
       <=3.4&&scaleFactor.floatValue*curScaleFactor
       >=0.25){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        if (self.bindActionNode) {
            [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
        }
    }
}


-(void)receiveReverseRotationNotification:(NSNotification*)sender{

    NSNumber* angle=((NSNumber*)[sender.userInfo objectForKey:@"reverseAngle"]);
    CGPoint recoveryPosition=((NSValue*)[sender.userInfo objectForKey:@"backUpPosition"]).CGPointValue;

    if ([self.parent isKindOfClass:[RightEyeballCropNode class]]) {
        angle=[NSNumber numberWithFloat:-angle.floatValue];
        NSLog(@"右眼旋转恢复位置");
        recoveryPosition=((NSValue*)[sender.userInfo objectForKey:@"backupRightPosition"]).CGPointValue;
    }
    
    [self rotateMyself:angle];
    [self setPosition: [self.parent.parent convertPoint:recoveryPosition fromNode:(self.scene)]];
}

-(void)rotateMyself:(NSNumber *)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
    EyeBallNode* pair=(EyeBallNode*)self.bindActionNode;

    if (pair) {
        [pair setZRotation:pair.curAngle-angle.floatValue];
    }
}

//-(void)syncRotate:(NSNumber*)angle{
//    EyeBallNode* pair=(EyeBallNode*)self.bindActionNode;
//    [self setZRotation:self.curAngle+angle.floatValue];
//    [pair setZRotation:pair.curAngle-angle.floatValue];
//}

-(void)syncDrag:(NSValue *)dest{
    
    DPI300Node* parent=(DPI300Node*)[self parent].parent;
    CGFloat angle=parent.zRotation;
    
    CGPoint pariPosition=CGPointMake(
                                     dest.CGPointValue.x*cos(angle)+dest.CGPointValue.y*sin(angle),
                                     -dest.CGPointValue.x*sin(angle)+dest.CGPointValue.y*cos(angle)
                                     );
    
    CGPoint actualPosition=CGPointZero;
    
    //显然成立
    angle=-angle;
    actualPosition=CGPointMake(
                               dest.CGPointValue.x*cos(angle)+dest.CGPointValue.y*sin(angle),
                               -dest.CGPointValue.x*sin(angle)+dest.CGPointValue.y*cos(angle)
                               );
    
    
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+actualPosition.x/12.0,self.curPosition.y-actualPosition.y/12.0 );
    
    self.position=finalPosition;
    
    self.bindActionNode.position=CGPointMake(self.bindActionNode.curPosition.x+pariPosition.x/12.0,self.bindActionNode.curPosition.y-pariPosition.y/12.0 );
}




-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self=  [super initWithCoder:aDecoder]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"EyeballColor" object:nil];
      //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveReverseRotationNotification:) name:@"Reverse_Rotation_Of_Eyeball" object:nil];
    }
    
    return self;
}

-(void)dealloc{
    NSLog(@"eyeball dealloc");
}
@end
