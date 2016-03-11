//
//  SmallBeard.m
//  face plus
//
//  Created by linxudong on 15/1/26.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "SmallBeard.h"
#import "BeardNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "FaceCropNode.h"
#import "MyScene.h"
#import "SKSceneCache.h"
@implementation SmallBeard
@synthesize curScaleFactor,curAngle;
-(instancetype) initWithImageNamed:(NSString *)name{
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= smallBeardLayerName  ;
        self.zPosition=100;
        self.tag=@"小胡子（不旋转）";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=9;
        self.selectedPriority=3;
        self.color=[UIColor blackColor];

    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    [self calculateExifWithFileName:entity.selfFileName];
    return self;
}

-(void)drag:(NSValue*)dest{
    
    //FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y-dest.CGPointValue.y/12 );
    
    
    [self setPosition:CGPointMake(finalPosition.x, finalPosition.y)];
    
    
    
}

-(void)zoom:(NSNumber*)scaleFactor{
    if(scaleFactor.floatValue*curScaleFactor
       <=1.8f&&scaleFactor.floatValue*curScaleFactor
       >=0.3){
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
        
    }
}
-(BOOL)changeTexture:(BaseEntity *)entity{
    [self setScale:1.f];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    //CGFloat ratio=texture.size.height/texture.size.width;
    //CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    self.texture=texture;
    //self.size=size;
    [self calculateExifWithFileName:entity.selfFileName];
    self.currentEntity=entity;
return YES;
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    
}

-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
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
    self.position=CGPointMake(self.position.x+size.width*anchorData.x,self.position.y+ size.height*anchorData.y);
    
}
@end
