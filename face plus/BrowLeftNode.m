//
//  BrowLeftNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "BrowLeftNode.h"
#import "Pixel2Point.h"
#import "BrowRightNode.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"
#import "BrowEntity.h"
#import "BrowShadow.h"
@implementation BrowLeftNode
@synthesize curAngle;
@synthesize bindActionNode;
@synthesize curPosition;
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= browLeftLayerName  ;
        self.zPosition=98;
        self.tag=@"眉毛(左)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=6;
        self.selectedPriority=10;
        self.color=[UIColor grayColor];
        }
    return self;
}
-(void)rotateMyself:(NSNumber*)angle{

}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
    
}

-(void)syncRotate:(NSNumber*)angle{
    BrowRightNode* rightNode=(BrowRightNode*)self.bindActionNode;
    SKAction * action=[SKAction rotateToAngle:self.curAngle+angle.floatValue duration:0];
    SKAction * reverse=[SKAction rotateToAngle:rightNode.curAngle-angle.floatValue duration:0];
    [self runAction:action];
    [rightNode runAction:reverse];
}

-(void)syncDrag:(NSValue *)dest{
    BrowRightNode* pair=(BrowRightNode*)[self bindActionNode];
    
    FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    CGPoint pairPosition=CGPointMake(pair.curPosition.x+dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];

    if (finalPosition.y<0&&finalPosition.y>=-faceSize.height) {
        
        
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pair.position.x, pairPosition.y)];
        }
    }
    
    if ( (finalPosition.x-pairPosition.x)<0&&finalPosition.x>-faceSize.width/2.0f) {
        
        
        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pairPosition.x, pair.position.y)];
        }
    }
    
}

-(void)drag:(NSValue*)dest{
    FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
     DPI300Node* pair=(DPI300Node*)[self bindActionNode];
    CGPoint pairPosition=CGPointMake(pair.curPosition.x-dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    if (finalPosition.y<0&&finalPosition.y>=-[Pixel2Point pixel2point:face.texture.size].height) {
    
        
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pair.position.x, pairPosition.y)];
        }
    }
    
    if ( (finalPosition.x-pairPosition.x)<0&&finalPosition.x>-[Pixel2Point pixel2point:face.texture.size].width/2.0f) {
        
        
        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pairPosition.x, pair.position.y)];
        }
    }
    
  
}


-(BOOL)changeTexture:(BrowEntity *)entity{
    
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
       <=1.8&&scaleFactor.floatValue*curScaleFactor
       >=0.12){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
   // if (self.bindActionNode&&[self.bindActionNode conformsToProtocol:@protocol(P_Colorable)]) {
      //  id<P_Colorable> bind=(id<P_Colorable>)self.bindActionNode;
    self.bindActionNode.color=color;
    //}
}

@end
