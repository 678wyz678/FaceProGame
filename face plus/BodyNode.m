//
//  MouthNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "BodyNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"
#import "BodyShadowNode.h"
@implementation BodyNode
@synthesize curAngle;
@synthesize  curScaleFactor;



-(instancetype)initWithEntity:(BaseEntity *)entity{
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= bodyLayerName;
        self.zPosition=-2;
        self.tag=@"身体";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=15;
        self.selectedPriority=9;
        
        BodyShadowNode* shadow=[[BodyShadowNode alloc]initWithEntity:entity];
        shadow.size=CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale) ;
        [self addChild:shadow];
        [self calculateExifWithFileName:entity.selfFileName];
    }
    self.currentEntity=entity;
    return self;
    
}
//不带png后缀的参数
-(void)calculateExifWithFileName:(NSString*)imageName{

    MyScene*scene=[SKSceneCache singleton].scene;
    FaceNode*faceNode= (FaceNode*)[scene childNodeWithName:faceLayerName];
    CGSize faceSize=[Pixel2Point pixel2point:faceNode.texture.size];

    //读取exif数据
    NSString* actualName=[NSString stringWithFormat:@"%@%@",[imageName stringByReplacingOccurrencesOfString:@".png" withString:@""],@"@2x~iphone"];
    NSString*path= [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
    //说明是推送的素材来自update文件夹
    if (path==nil)
    {
        path=imageName;
    }
    NSURL* url=[NSURL fileURLWithPath:path];
    
    
    //读取exif数据

    
    NSString*anchorX= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    CGFloat xPoint=0.5f;
    if (![anchorX isEqualToString:@"Adobe ImageReady"]) {
        xPoint=[anchorX floatValue];
    }
    
    [self setAnchorPoint:CGPointMake(xPoint, 1)];
    
    [self setPosition:CGPointMake(0, -faceSize.height*0.88)];
    
    
    //读取完毕
    
    
}
-(void)setSize:(CGSize)size{
    [super setSize:size];
    BodyShadowNode* shadow=(BodyShadowNode*)[self childNodeWithName:bodyShadowLayerName];
    [shadow setSize:CGSizeMake(size.width/self.xScale, size.height/self.yScale)];

}

-(void)zoom:(NSNumber*)scaleFactor{
    
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
    
}

-(void)drag:(NSValue*)dest{
    //MyScene* scene=[SKSceneCache singleton].scene ;
    
    //FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    // CGSize point=[Pixel2Point pixel2point:face.texture.size];
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y-dest.CGPointValue.y/12 );
    
    
//    
//    CGPoint coordinateInScene= [scene convertPoint:finalPosition fromNode:face];
//    
//    CGFloat yLimit=scene.size.height/2.0;
//    CGFloat xLimit=scene.size.width/2.0;
//    
//    if (coordinateInScene.y <yLimit && coordinateInScene.y>(-yLimit)) {
        [self setPosition:finalPosition];
//    }
//    if(coordinateInScene.x>-xLimit&&coordinateInScene.x<xLimit){
//        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
//    }
//    
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    MyScene*scene=[SKSceneCache singleton].scene;
   FaceNode*faceNode= (FaceNode*)[scene childNodeWithName:faceLayerName];
    CGSize faceSize=[Pixel2Point pixel2point:faceNode.texture.size];
    
    //读取exif数据
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone"];
    NSString*path= [[NSBundle mainBundle] pathForResource:imageFileWithOutExtension ofType:@"png"];
    //说明是推送的素材来自update文件夹
    if (path==nil)
    {
        path=entity.selfFileName;
    }
    NSURL* url=[NSURL fileURLWithPath:path];
    
    
    NSString*anchorX= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    CGFloat xPoint=0.5f;
    if (![anchorX isEqualToString:@"Adobe ImageReady"]) {
        xPoint=[anchorX floatValue];
    }
    
    
    //读取完毕
    
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    
    if (entity.selfShadowFileName) {
        if ([self childNodeWithName:bodyShadowLayerName]) {
            BodyShadowNode* shadow=(BodyShadowNode*)[self childNodeWithName:bodyShadowLayerName];
            [shadow changeTexture:entity];
        }
        else{
            BodyShadowNode* shadow=[[BodyShadowNode alloc]initWithEntity:entity];
            [self addChild:shadow];
            shadow.size=CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale);
        }
    }
    else{
        if ([self childNodeWithName:bodyShadowLayerName]) {
            [[self childNodeWithName:bodyShadowLayerName] removeFromParent];
        }
    }
    
    [self setAnchorPoint:CGPointMake(xPoint, 1)];
    
    [self setPosition:CGPointMake(0, -faceSize.height *0.88)];

    self.currentEntity=entity;
    return YES;
}


-(void)setAnchorPoint:(CGPoint)anchorPoint{
    [super setAnchorPoint:anchorPoint];
    if ([self childNodeWithName:bodyShadowLayerName]) {
        [((DPI300Node*)[self childNodeWithName:bodyShadowLayerName]) setAnchorPoint:anchorPoint];
    }

}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    
}
-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}

@end
