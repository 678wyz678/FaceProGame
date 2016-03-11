//
//  UnderEyeLeftNode.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "UnderEyeLeftNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "UnderEyeRightNode.h"
#import "SKSceneCache.h"
#import "EyeLeftNode.h"
#import "MyScene.h"
@implementation UnderEyeLeftNode
@synthesize bindActionNode;
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    self=[super initWithImageNamed:name];
    if (self!=nil) {
         self.name= underEyeLeftLayerName ;
        self.tag=@"左眼影";
           }
    return self;
}
-(instancetype) initWithEntity:(BaseEntity *)entity{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    self=[super initWithImageNamed:entity.selfFileName];
    if (self!=nil) {
        self.name= underEyeLeftLayerName ;
        self.tag=@"左眼影";
        self.currentEntity=entity;
    }
    
    SKScene* scene= [SKSceneCache singleton].scene;
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    EyeLeftNode*eyeLeft=(EyeLeftNode*)[face childNodeWithName:eyeLeftLayerName];
    self.size=CGSizeMake(eyeLeft.size.width*1.2, self.size.height/self.size.width*eyeLeft.size.width*1.2);
    self.position=eyeLeft.position;
    
    return self;
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    //self.xScale=1.0;
    //self.yScale=1.0;
    
    //  SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    self.currentEntity=entity;
return YES;
}


-(void)zoom:(NSNumber*)scaleFactor{

    
    
    if(scaleFactor.floatValue*curScaleFactor
       <=2.4&&scaleFactor.floatValue*curScaleFactor
       >=0.3){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
    }
}




-(void)syncRotate:(NSNumber*)angle{
    UnderEyeRightNode* pair=(UnderEyeRightNode*)[self bindActionNode];
    [self setZRotation:self.curAngle+angle.floatValue];
    [pair setZRotation:pair.curAngle-angle.floatValue];
}
-(void)syncDrag:(NSValue *)dest{
    UnderEyeRightNode* pair=(UnderEyeRightNode*)[self bindActionNode];
    
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    CGPoint pairPosition=CGPointMake(pair.curPosition.x+dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    
        [self setPosition:finalPosition];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:pairPosition];
        }
  
    
}



//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    self.bindActionNode.color=color;
}


-(void)drag:(NSValue*)dest{
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );
    DPI300Node*pair=self.bindActionNode;
     CGPoint pairPosition=CGPointMake(pair.curPosition.x-dest.CGPointValue.x/6, pair.curPosition.y-dest.CGPointValue.y/6);
    [self setPosition:finalPosition];
    [pair setPosition:pairPosition];
}


@end
