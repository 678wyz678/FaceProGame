//
//  CapNode.m
//  face plus
//
//  Created by linxudong on 12/7/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "CapNode.h"
#import "FaceNode.h"
#import "MyScene.h"
#import "SKSceneCache.h"
#import "Pixel2Point.h"
#import "CapShadow.h"
#import "GlobalVariable.h"
#import <UIKit/UIKit.h>
#import "CapBackground.h"
#import "CapWithBackgroundEntity.h"
#define HISTORY_SIZE 320.0
#define CURRENT_SIZE 640.0
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation CapNode
@synthesize curScaleFactor,curAngle;
-(instancetype) initWithImageNamed:(NSString *)name{
  //  SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= capLayerName;
        self.zPosition=126;
        self.tag=@"帽子";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.order=14;//素材列表位置
        self.selectedPriority=6;
        self.color=[UIColor redColor];
       // FaceNode*face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
        
//        CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];
//        if (face) {
//            self.position=CGPointMake(faceSize.width/2, 0);
//        }
        
        
        //CGFloat ratio=self.texture.size.height/self.texture.size.width;
       // self.size=CGSizeMake(faceSize.width*1.3,1.3*faceSize.width*ratio);
        
    }
    return self;
}

-(instancetype) initWithEntity:(BaseEntity *)entity{
    //  SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    if (self=[self initWithImageNamed:entity.selfFileName]) {
        
        //添加阴影
        CapShadow* shadow=[[CapShadow alloc]initWithImageNamed:entity.selfShadowFileName];
        shadow.size=CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale);
        [self addChild:shadow];
        
        [self dealWithBackgroundEntity:entity];
        
        [self calculateExifWithFileName:entity.selfFileName];
        self.currentEntity=entity;
    }
    
    return self;
}

-(void)drag:(NSValue*)dest{
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );
    [self setPosition:finalPosition];
    
}

-(BOOL)changeTexture:(BaseEntity *)entity{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    
    //CGFloat curScale=self.xScale;
    self.xScale=1.0;
    self.yScale=1.0;
    [self setZRotation:0.f];
    
    //读取exif数据
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone"];
    
    
    
    NSURL* url=[NSURL fileURLWithPath:
                [[NSBundle mainBundle] pathForResource:imageFileWithOutExtension ofType:@"png"]];
    
    NSString*scaleAndAnchor= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    CGFloat scaleData=1.0;
    CGPoint anchorData=CGPointMake(0.5, 1.0);
    
    NSArray*tempColorStringArray = [scaleAndAnchor componentsSeparatedByString:@"%"];
    NSString*colorString=@"0x000000";
    if (tempColorStringArray.count>1) {
        colorString=tempColorStringArray[1];
        scaleAndAnchor=tempColorStringArray[0];
    }
    int number = (int)strtol(colorString.UTF8String, NULL, 0);
    self.color=UIColorFromRGB(number);
    
    
    if (scaleAndAnchor) {
        NSString*anchorString=[scaleAndAnchor componentsSeparatedByString:@":"][0] ;
        anchorData=CGPointMake(
                               [[anchorString componentsSeparatedByString:@","][0] floatValue],
                               [[anchorString componentsSeparatedByString:@","][1] floatValue]
                               );
        scaleData=[[scaleAndAnchor componentsSeparatedByString:@":"][1] floatValue];
    }
    //读取完毕

    
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGSize size= [Pixel2Point pixel2point:texture.size];
    //转换历史scale后的大小
    self.texture=texture;
    self.size=CGSizeMake(size.width/scaleData/(CURRENT_SIZE/HISTORY_SIZE), size.height/scaleData/(CURRENT_SIZE/HISTORY_SIZE));
    self.anchorPoint=anchorData;
    self.position=CGPointZero;//重新排头发位置
    [[self children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       DPI300Node*child=(DPI300Node*)obj ;
        child.anchorPoint=anchorData;
    }];
    
    
    
    if (entity.selfShadowFileName) {
        if ([self childNodeWithName:capShadowLayerName]) {
            CapShadow* capShadow=(CapShadow*)[self childNodeWithName:capShadowLayerName];
            [capShadow changeTexture:entity];
        }
        else{
            CapShadow* capShadow=[[CapShadow alloc]initWithImageNamed:entity.selfShadowFileName];
            [self addChild:capShadow];
        }
    }
    else{
        if ([self childNodeWithName:capShadowLayerName]) {
            [[self childNodeWithName:capShadowLayerName] removeFromParent];
        }
    }
    
    [self dealWithBackgroundEntity:entity];
    
    self.currentEntity=entity;
return YES;
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    if(scaleFactor.floatValue*curScaleFactor
       <=1.8&&scaleFactor.floatValue*curScaleFactor
       >=0.3){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}
-(void)color:(UIColor *)color{
    self.color=color;
}



//不带png后缀的参数
-(void)calculateExifWithFileName:(NSString*)imageName{
    //读取exif数据
    NSString* actualName=[[NSString stringWithFormat:@"%@%@",imageName,@"@2x~iphone"] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSString*path= [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
    //说明是推送的素材来自update文件夹
    if (path==nil)
    {
        path=imageName;
    }
    NSURL* url=[NSURL fileURLWithPath:path];
    
    
    NSString*scaleAndAnchor= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    CGFloat scaleData=1.0;
    CGPoint anchorData=CGPointMake(0.5, 1.0);
    
    NSArray*tempColorStringArray = [scaleAndAnchor componentsSeparatedByString:@"%"];
    NSString*colorString=@"0x000000";
    if (tempColorStringArray.count>1) {
        colorString=tempColorStringArray[1];
        scaleAndAnchor=tempColorStringArray[0];
    }
    int number = (int)strtol(colorString.UTF8String, NULL, 0);
    self.color=UIColorFromRGB(number);
    
    
    if (scaleAndAnchor) {
        NSString*anchorString=[scaleAndAnchor componentsSeparatedByString:@":"][0] ;
        
        anchorData=CGPointMake(
                               [[anchorString componentsSeparatedByString:@","][0] floatValue],
                               [[anchorString componentsSeparatedByString:@","][1] floatValue]
                               );
        scaleData=[[scaleAndAnchor componentsSeparatedByString:@":"][1] floatValue];
    }
    
    
    CGSize size=[Pixel2Point pixel2point:self.texture.size];
    
    self.size=CGSizeMake(size.width/scaleData/(CURRENT_SIZE/HISTORY_SIZE), size.height/scaleData/(CURRENT_SIZE/HISTORY_SIZE));
    self.anchorPoint=anchorData;
}


-(void)dealWithBackgroundEntity:(BaseEntity*)entity{
    //看看是否为特殊的有背景的帽子，是则添加背景，不是则去掉（不管之前有没有）
    if ([entity isKindOfClass:[CapWithBackgroundEntity class]]) {
        if ([self childNodeWithName:capBackgroundLayerName]) {
            CapBackground* capBackground=(CapBackground*)[self childNodeWithName:capBackgroundLayerName];
            [capBackground changeTexture:entity];
        }
        else{
            CapBackground* capBackground=[[CapBackground alloc]initWithEntity:entity];
            capBackground.size=self.size;
            [self addChild:capBackground];
        }
    }
    else{//不是特殊帽子就移除掉背景（不管是否有）
        CapBackground* capBackground=(CapBackground*)[self childNodeWithName:capBackgroundLayerName];
        
        [capBackground removeFromParent];
    }
}

-(void)setAnchorPoint:(CGPoint)anchorPoint{
    [super setAnchorPoint:anchorPoint];
    if ([self childNodeWithName:capBackgroundLayerName]) {
        CapBackground* capBackground=(CapBackground*)[self childNodeWithName:capBackgroundLayerName];
        [capBackground setAnchorPoint:anchorPoint];
    }
    if ([self childNodeWithName:capShadowLayerName]) {
        CapShadow* shadow=(CapShadow*)[self childNodeWithName:capShadowLayerName];
        [shadow setAnchorPoint:anchorPoint];
    }

}

-(void)setSize:(CGSize)size{
    [super setSize:size];
    if ([self childNodeWithName:capBackgroundLayerName]) {
        CapBackground* capBackground=(CapBackground*)[self childNodeWithName:capBackgroundLayerName];
        [capBackground setSize:size];
    }
    if ([self childNodeWithName:capShadowLayerName]) {
        CapShadow* shadow=(CapShadow*)[self childNodeWithName:capShadowLayerName];
        [shadow setSize:size];
    }
    
}

-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}
@end
