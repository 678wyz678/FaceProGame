//
//  FrontHairNode.m
//  face plus
//
//  Created by linxudong on 12/12/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "FrontHairNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "AccessoryRecordObject.h"

#define defaultHairColor {0xe5c688,0x480600,0x1e1e1e}
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@implementation FrontHairNode
@synthesize curScaleFactor;

@synthesize curPosition,curAngle;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= frontHairLayerName;
        self.zPosition=100;
        self.tag=@"前发";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.color=[UIColor grayColor];
        self.order=2;//素材列表位置
        self.selectedPriority=8;
        self.position=CGPointZero;
        [self calculateExifWithFileName:name];
        int a[3]=defaultHairColor;
//        //背景设置
//        int lowerBound = 0;
//        int upperBound = 2;
//        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        self.color=UIColorFromRGB(a[0]);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHairColor:) name:@"Update_hair_color" object:nil];
    }
    return self;
}

-(void)updateHairColor:(NSNotification*)sender{
    UIColor * color=[sender.userInfo objectForKey:@"Color"];
    self.color=color;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    AccessoryRecordObject*object=[[AccessoryRecordObject alloc]initWithNodeAndImageFile:self currentEntity:entity];
    NSDictionary*dict=[NSDictionary dictionaryWithObject:object forKey:@"RECORD_OBJECT"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_RECORDS_OF_FRONT_HAIR" object:self userInfo:dict];

    
    
    self.currentEntity=entity;
    return self;
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
    
    if (scaleAndAnchor) {
        NSString*anchorString=[scaleAndAnchor componentsSeparatedByString:@":"][0] ;
        
        anchorData=CGPointMake(
                               [[anchorString componentsSeparatedByString:@","][0] floatValue],
                               [[anchorString componentsSeparatedByString:@","][1] floatValue]
                               );
        scaleData=[[scaleAndAnchor componentsSeparatedByString:@":"][1] floatValue];
    }
    
    
    CGSize size=[Pixel2Point pixel2point:self.texture.size];
    
    self.size=CGSizeMake(size.width/scaleData, size.height/scaleData);
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
    
}
//-(BOOL)changeTexture:(BaseEntity *)entity{
//    self.xScale=1.0;
//    self.yScale=1.0;
//    
//    
//    //读取exif数据
//    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone"];
//    NSURL* url=[NSURL fileURLWithPath:
//                [[NSBundle mainBundle] pathForResource:imageFileWithOutExtension ofType:@"png"]];
//    
//    
//    NSString*scaleAndAnchor= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
//    CGFloat scaleData=1.0;
//    CGPoint anchorData=CGPointMake(0.5, 1.0);
//    
//    if (scaleAndAnchor) {
//        NSString*anchorString=[scaleAndAnchor componentsSeparatedByString:@":"][0] ;
//        
//        anchorData=CGPointMake(
//                               [[anchorString componentsSeparatedByString:@","][0] floatValue],
//                               [[anchorString componentsSeparatedByString:@","][1] floatValue]
//                               );
//        scaleData=[[scaleAndAnchor componentsSeparatedByString:@":"][1] floatValue];
//    }
//    //读取完毕
//    
//    
//    
 //   SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
//    //    CGFloat ratio=texture.size.height/texture.size.width;
//    //    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
//    
//    self.texture=texture;
//    CGSize size=[Pixel2Point pixel2point:texture.size];
//    
//    self.size=CGSizeMake(size.width/scaleData, size.height/scaleData);
//    self.anchorPoint=anchorData;
//    self.position=CGPointZero;//重新排头发位置
//    
//    self.currentEntity=entity;
//    [self setZRotation:0];
//
//return YES;
//}


-(void)zoom:(NSNumber*)scaleFactor{
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
