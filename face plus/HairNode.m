//
//  HairNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "HairNode.h"
#import "Pixel2Point.h"
#import "HairShadow.h"
#import "GlobalVariable.h"
#import "FaceNode.h"
#import "GirlBehindHair.h"
#import "ImportAllEntity.h"
#define CURRENT_SIZE 640
#define HISTORY_SIZE 320
#define defaultHairColor {0xe5c688,0x480600,0x1e1e1e}
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation HairNode
@synthesize curScaleFactor,curAngle;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= hairLayerName;
        self.zPosition=99;
        self.tag=@"头发";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.color=[UIColor grayColor];
        self.order=1;//素材列表位置
        self.selectedPriority=5;
        int a[3]=defaultHairColor;
        //背景设置
        int lowerBound = 0;
        int upperBound = 2;
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        self.color=UIColorFromRGB(a[rndValue]);
        
        [self calculateExifWithFileName:name];
        
    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
}

//不带png后缀的参数
-(void)calculateExifWithFileName:(NSString*)imageName{
    
    
    //读取exif数据
    NSString* actualName=[NSString stringWithFormat:@"%@%@",[imageName stringByReplacingOccurrencesOfString:@".png" withString:@""],@"@2x~iphone"];
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
-(void)calculateExif:(BaseEntity*)entity{
     NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    [self calculateExifWithFileName:imageFileWithOutExtension];
}


-(void)drag:(NSValue*)dest{
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );
    [self setPosition:finalPosition];
}
-(void)color:(UIColor *)color{
    self.color=color;
    GirlBehindHair*behind=  (GirlBehindHair*)  [self childNodeWithName:girlBehindHairLayerName];
    if(behind)
    {behind.color=color;}
    
    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:@"Color"];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Update_hair_color" object:self userInfo:dict];
}
-(BOOL)changeTexture:(BaseEntity *)entity{
    
    
    //CGFloat curScale=self.xScale;
    [self setScale:1.0f];
    
    
    //读取exif数据
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone"];
    NSString*path= [[NSBundle mainBundle] pathForResource:imageFileWithOutExtension ofType:@"png"];
    //说明是推送的素材来自update文件夹
    if (path==nil)
    {
        path=entity.selfFileName;
    }
    NSURL* url=[NSURL fileURLWithPath:path];
    
  
    NSString*scaleAndAnchor= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    CGFloat scaleData=1.0;
    CGPoint anchorData=CGPointMake(0.5, 1.0);
    
    if (scaleAndAnchor.length>1&&![scaleAndAnchor isEqualToString:@"Adobe ImageReady"]) {
        NSString*anchorString=[scaleAndAnchor componentsSeparatedByString:@":"][0] ;
        
        anchorData=CGPointMake(
                               [[anchorString componentsSeparatedByString:@","][0] floatValue],
                               [[anchorString componentsSeparatedByString:@","][1] floatValue]
                               );
        scaleData=[[scaleAndAnchor componentsSeparatedByString:@":"][1] floatValue];
    }
   //读取完毕
    
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
//    CGFloat ratio=texture.size.height/texture.size.width;
//    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    CGSize size=[Pixel2Point pixel2point:texture.size];
    
    self.size=CGSizeMake(size.width/scaleData/(CURRENT_SIZE/HISTORY_SIZE), size.height/scaleData/(CURRENT_SIZE/HISTORY_SIZE));
    self.anchorPoint=anchorData;
    self.position=CGPointZero;//重新排头发位置
    if ([self childNodeWithName:girlBehindHairLayerName]) {
       GirlBehindHair*behindHair=(GirlBehindHair*) [self childNodeWithName:girlBehindHairLayerName];
        behindHair.anchorPoint=anchorData;
    }
    
    if ([entity isKindOfClass:[GirlHairEntity class]]) {
        GirlBehindHair* behindHair=(GirlBehindHair*)[self childNodeWithName:girlBehindHairLayerName];
        if (behindHair) {
            [behindHair changeTexture:entity];
            behindHair.color=self.color;
            behindHair.size=CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale);
            behindHair.position=CGPointZero;
        }
    }
    [self setZRotation:0];
    self.currentEntity=entity;
    return YES;
}

-(void)setSize:(CGSize)size{
    [super setSize:size];
    GirlBehindHair* behindHair=(GirlBehindHair*)[self childNodeWithName:girlBehindHairLayerName];
    [behindHair setSize:CGSizeMake(size.width/self.xScale, size.height/self.yScale)];

}



-(void)zoom:(NSNumber*)scaleFactor{

   // FaceNode* faceNode=(FaceNode*)[self.scene childNodeWithName:faceLayerName];
    //宽和高同时小于指定边界
    if(scaleFactor.floatValue*curScaleFactor
       <=1.8&&scaleFactor.floatValue*curScaleFactor
       >=0.3){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
   }
    
 

}

-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}
@end
