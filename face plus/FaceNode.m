//
//  face_node.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "FaceNode.h"
#import "Pixel2Point.h"
#import "FaceShadow.h"
#import "FaceMeasure.h"
#import "ReLayout.h"
#import "SKSceneCache.h"
#import "GlobalVariable.h"
#import "Pixel2Point.h"
#import "FaceCropNode.h"
#import "GaussianBlurNode.h"
#import <ImageIO/ImageIO.h>
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//用来保存之前一次的exif中的scale数据，以便在下一次换脸的时候读出并且处以它
@interface FaceNode ()
@property CGFloat beforeScaleNum;
@end

@implementation FaceNode 
-(instancetype) initWithImageNamed:(NSString *)name{
   // CGSize SCREEN_SIZE=[[UIScreen mainScreen]bounds].size;
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    if (name) {
      
        self=[super initWithTexture:texture];
    }
    else{
        self=[super init];
    }
    if (self) {
        self.beforeScaleNum=1.0f;
        self.name= faceLayerName  ;
        self.zPosition=100;
        self.tag=@"脸";
        self.color=[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.anchorPoint=CGPointMake(0.5, 1);

        
        GaussianBlurNode* blurNode=[[GaussianBlurNode alloc]initWithParentNode:self];
        
        [self addChild:blurNode];
        
        
        //调整大小
        [self adjustTotalScale:texture];
        
        //坐标设定
        [self centerPosition];
        self.order=0;
        self.selectedPriority=1;
        
        FaceCropNode * faceCrop=[[FaceCropNode alloc]init];
        SKSpriteNode*mask= [[SKSpriteNode alloc]initWithTexture:self.texture];
        mask.size=self.size;
        faceCrop.maskNode=mask;
        mask.anchorPoint=CGPointMake(0.5, 1);
        [self addChild:faceCrop];
        [faceCrop calculateBoundary:self];
        
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"SkinColor" object:nil];
       
        
       
        
        
    }
    
    return self;
    
}

-(instancetype)init{
   return  [self initWithImageNamed:nil];
    
}

-(void) adjustTotalScale:(SKTexture*)newTexture{
    CGSize screen=[[UIScreen mainScreen]bounds].size;
      
    CGSize size=[Pixel2Point pixel2point:newTexture.size];
    CGFloat ratio=screen.width/size.width*0.5;
    self.xScale=ratio;
    self.yScale=ratio;
    
    
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    
  NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone"];
    NSString*path= [[NSBundle mainBundle] pathForResource:imageFileWithOutExtension ofType:@"png"];
    //说明是推送的素材来自update文件夹
    if (path==nil)
    {
        path=entity.selfFileName;
    }
    NSURL* url=[NSURL fileURLWithPath:path];
    
    CGFloat scale=1.0;
    CGFloat anchorX=0.5;
   NSString*scaleAndAnchor= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    if (scaleAndAnchor) {
        scale=[[scaleAndAnchor componentsSeparatedByString:@","][0] floatValue];
        anchorX=[[scaleAndAnchor componentsSeparatedByString:@","][1] floatValue];
    }
    
    
    
    CGFloat currentWidth=self.size.width;
    
    CGFloat currentScale=self.xScale;
    
    
          self.xScale=1.0;
          self.yScale=1.0;
        
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
        CGFloat textureRatio=texture.size.width/self.texture.size.width;
        [self setTexture:texture];
    
        CGSize size=[Pixel2Point pixel2point:texture.size];
    
    
        self.size=CGSizeMake(currentWidth/currentScale*_beforeScaleNum/scale, currentWidth/currentScale*_beforeScaleNum/scale*size.height/size.width);
        self.anchorPoint=CGPointMake(anchorX, 1);
    _beforeScaleNum=scale;

   
    
    
        //坐标设定
        [self setScale:currentScale];
    
    
        [ReLayout adjustFacePosition:(SKScene*)[SKSceneCache singleton].scene ratio:[[NSNumber alloc]initWithFloat:textureRatio]];
    
    //重新计算crop区域
    FaceCropNode* crop=(FaceCropNode*)[self childNodeWithName:faceCropLayerName];
    if (crop) {
        [crop calculateBoundary:self];
    }
    
    
    GaussianBlurNode* blurNode=(GaussianBlurNode*)[self childNodeWithName:gaussianBlurLayerName];
    if (blurNode) {
        [blurNode changeTexture:entity.selfFileName];
    }
    
    return YES;
}


//-(void)setAnchorPoint:(CGPoint)anchorPoint{
//    [super setAnchorPoint:anchorPoint];
//  SKSpriteNode*cropMask= (SKSpriteNode*) [((FaceCropNode*) [self childNodeWithName:faceCropLayerName]) maskNode ];
//    cropMask.anchorPoint=anchorPoint;
//    NSLog(@"cropMask anchor:%@",NSStringFromCGPoint(cropMask.anchorPoint));
//
//}

//for initial Position
-(void)centerPosition{
    self.position=CGPointMake(0,[UIScreen mainScreen].bounds.size.height/5.0f);
}

-(void)correctPositionForScaleSlider:(NSNumber*)scaleSliderValue{
    self.position=CGPointMake(0,[UIScreen mainScreen].bounds.size.height/5.0f+(scaleSliderValue.floatValue-1)*self.size.width*0.1);
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

-(void)setSize:(CGSize)size{
    [super setSize:size];
    GaussianBlurNode* blurNode=(GaussianBlurNode*)[self childNodeWithName:gaussianBlurLayerName];
    if (blurNode) {
        [blurNode reSizeBlur:[NSValue valueWithCGSize:CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale)]];
    }
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        _beforeScaleNum = ((NSNumber*)[aDecoder decodeObjectForKey:@"beforeScaleNum"]).floatValue;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"SkinColor" object:nil];
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[NSNumber numberWithFloat:_beforeScaleNum] forKey:@"beforeScaleNum"];
}

-(void)dealloc{
    NSLog(@"face dealloc");
}
@end
 