//
//  HeadDecorationNode.m
//  face plus
//
//  Created by linxudong on 1/16/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "HeadDecorationNode.h"
#import "Pixel2Point.h"
@implementation HeadDecorationNode
@synthesize curPosition;
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= headDecoLayerName;
        self.zPosition=12;
        self.tag=@"头饰";
        self.blendMode=SKBlendModeAlpha;
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=16;//素材列表位置
        
        self.selectedPriority=13;
        [self calculateExifWithFileName:name];
    }
    return self;
}
-(instancetype) initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    
    return self;
}
-(void)drag:(NSValue*)dest{
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );
    [self setPosition:finalPosition];
    
}

-(void)changeTexture:(BaseEntity *)entity{
    [self setScale:1.0f];
    
    
    //读取exif数据
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone"];
    NSURL* url=[NSURL fileURLWithPath:
                [[NSBundle mainBundle] pathForResource:imageFileWithOutExtension ofType:@"png"]];
    
    
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
    //读取完毕
    
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    //    CGFloat ratio=texture.size.height/texture.size.width;
    //    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    CGSize size=[Pixel2Point pixel2point:texture.size];
    
    self.size=CGSizeMake(size.width/scaleData, size.height/scaleData);
    self.anchorPoint=anchorData;
    self.position=CGPointZero;//重新排头发位置
    
    
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    
}
-(void)color:(UIColor *)color{
    self.color=color;
}


//不带png后缀的参数
-(void)calculateExifWithFileName:(NSString*)imageName{
    //读取exif数据
    NSString* actualName=[NSString stringWithFormat:@"%@%@",[imageName stringByReplacingOccurrencesOfString:@".png" withString:@""],@"@2x~iphone"];
    NSURL* url=[NSURL fileURLWithPath:
                [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"]];
    
    
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
@end
