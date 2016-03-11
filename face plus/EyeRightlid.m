//
//  BrowRightNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "EyeRightlid.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "Pixel2Point.h"
#import "GlobalVariable.h"
#import "EyeLeftlid.h"
#import "EyeRightNode.h"
@implementation EyeRightlid
@synthesize curAngle;
@synthesize curScaleFactor;
@synthesize bindActionNode;
@synthesize curPosition;
-(instancetype) initWithImageNamed:(NSString *)name{
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= rightEyelidLayerName  ;
        self.zPosition=88;
        self.tag=@"双眼皮(右)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=12;
        self.selectedPriority=10;
        self.color=[UIColor grayColor];
        self.isViceSir=YES;
        
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfPairFileName];
    self.currentEntity=entity;
    SKScene* scene= [SKSceneCache singleton].scene;
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    EyeRightNode*eyeRight=(EyeRightNode*)[face childNodeWithName:eyeRightLayerName];
    self.size=CGSizeMake(eyeRight.size.width, self.size.height/self.size.width*eyeRight.size.width);
    self.position=CGPointMake(eyeRight.position.x, eyeRight.position.y+eyeRight.size.height/2.1f);
    return self;
    
}

-(void)setAnchorPoint:(CGPoint)anchorPoint{
    [super setAnchorPoint:anchorPoint];
}
-(void)syncRotate:(NSNumber *)angle{
}

-(void)drag:(NSValue*)dest{

}

-(BOOL)changeTexture:(BaseEntity *)entity{

    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfPairFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    self.currentEntity=entity;
    return YES;
}

-(void)zoom:(NSNumber*)scaleFactor{
 
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    
}

@end
