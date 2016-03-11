//
//  RightBrowLikeSmallBeard.m
//  face plus
//
//  Created by linxudong on 15/1/26.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "RightBrowLikeSmallBeard.h"
#import "BaseEntity.h"
#import "Pixel2Point.h"
#import "RightBrowLikeSmallBeard.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"

@implementation RightBrowLikeSmallBeard
@synthesize bindActionNode;
@synthesize curAngle;
@synthesize curScaleFactor;
@synthesize curPosition;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= rightBrowLikeSmallBeardLayerName  ;
        self.zPosition=100;
        self.tag=@"右小胡子(可旋转)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=9;
        self.selectedPriority=10;
        self.color=[UIColor blackColor];
        self.isViceSir=YES;
    }
    return self;
}
-(BOOL)changeTexture:(BaseEntity *)entity{
    [self setScale:1.f];

    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfPairFileName];
    self.texture=texture;
    [self calculateExifWithFileName:entity.selfFileName];

    self.currentEntity=entity;
    [self calculateExifWithFileName:entity.selfPairFileName];
return YES;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfPairFileName];
    [self calculateExifWithFileName:entity.selfPairFileName];

    return self;
}
-(void)color:(UIColor *)color{
    self.color=color;
}


//不带png后缀的参数
-(void)calculateExifWithFileName:(NSString*)imageName{
    
    
    CGSize faceTextureSize;
    FaceNode*faceNode= (FaceNode*)  [[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    
    faceTextureSize=[Pixel2Point pixel2point:((FaceNode*)faceNode).texture.size];
    
    //读取exif数据
    NSString* actualName=[NSString stringWithFormat:@"%@%@",[imageName stringByReplacingOccurrencesOfString:@".png" withString:@""],@"@2x~iphone"];
    NSString*path= [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
    //说明是推送的素材来自update文件夹
    if (path==nil)
    {
        path=imageName;
    }
    NSURL* url=[NSURL fileURLWithPath:path];
    
    BOOL isUP=YES;
    NSString*scaleAndAnchor= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    CGFloat scaleData=1.0;
    CGPoint anchorData=CGPointMake(0.5, 1.0);
    
    
    if (scaleAndAnchor) {
        isUP=[[scaleAndAnchor componentsSeparatedByString:@"~"][0] intValue];
        
        NSString*anchorString=[[scaleAndAnchor componentsSeparatedByString:@"~"][1]componentsSeparatedByString:@":"][0] ;
        anchorData=CGPointMake(
                               [[anchorString componentsSeparatedByString:@","][0] floatValue],
                               [[anchorString componentsSeparatedByString:@","][1] floatValue]
                               );
        
        scaleData=[[[scaleAndAnchor componentsSeparatedByString:@"~"][1]componentsSeparatedByString:@":"][1] floatValue];
    }
    
    if (!isUP) {
        //SKAction *moveDown=[SKAction moveBy:CGVectorMake(0, -faceTextureSize.height) duration:0];
        [self setPosition:CGPointMake(0, -faceTextureSize.height)];
    }
    
    CGSize size=[Pixel2Point pixel2point:self.texture.size];
    
    self.size=CGSizeMake(size.width*scaleData, size.height*scaleData);
    self.position=CGPointMake(self.position.x+ size.width*anchorData.x,self.position.y+ size.height*anchorData.y*1.12);
    
    
}
-(void)calculateExif:(BaseEntity*)entity{
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    [self calculateExifWithFileName:imageFileWithOutExtension];
}



@end
