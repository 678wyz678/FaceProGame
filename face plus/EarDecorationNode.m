//
//  EarDecorationNode.m
//  face plus
//
//  Created by linxudong on 1/16/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "EarDecorationNode.h"
#import "Pixel2Point.h"
#import "EarDecorationShadowNode.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation EarDecorationNode
@synthesize curPosition;
@synthesize curScaleFactor,curAngle;

-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= earDecoLayerName;
        self.zPosition=10;
        self.tag=@"耳饰";
        self.blendMode=SKBlendModeAlpha;
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=12;//素材列表位置
        self.selectedPriority=13;
    }
    return self;
}
-(instancetype) initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
   
    EarDecorationShadowNode*shadow=[[EarDecorationShadowNode alloc]initWithEntity:entity];
    shadow.size=shadow.size;
    [self addChild:shadow];
    self.currentEntity=entity;
    
    [self calculateExifWithFileName:entity.selfFileName];
    
    return self;
}
-(void)setSize:(CGSize)size{
    
    [super setSize:size];
    EarDecorationShadowNode*shadow=(EarDecorationShadowNode*)[self childNodeWithName:earDecoShadowLayerName];
    if (shadow) {
        shadow.size=size;
    }
  
}
-(void)drag:(NSValue*)dest{
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );
    [self setPosition:finalPosition];
    
}

-(BOOL)changeTexture:(BaseEntity *)entity{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    DPI300Node*parent=(DPI300Node*)self.parent;
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGSize size= [Pixel2Point pixel2point:texture.size];
    //转换历史scale后的大小
 self.size=CGSizeMake(parent.size.height/parent.yScale*0.6*size.width/size.height, parent.size.height/parent.yScale*0.6);
    
    self.texture=texture;
    EarDecorationShadowNode*shadow=(EarDecorationShadowNode*)[self childNodeWithName:earDecoShadowLayerName];
    if (shadow) {
        [shadow changeTexture:entity];
    }
    self.currentEntity=entity;
    [self calculateExifWithFileName:entity.selfFileName];

return YES;

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
    
    
    NSString*colorString= [(NSDictionary*)[[CIImage imageWithContentsOfURL:url].properties objectForKey:@"{TIFF}"] objectForKey:@"Software"] ;
    if ([colorString isEqualToString:@"Adobe ImageReady"]) {
        colorString=@"0x000000";
    }
    int number = (int)strtol(colorString.UTF8String, NULL, 0);
    self.color=UIColorFromRGB(number);

}



-(void)zoom:(NSNumber*)scaleFactor{
    
    
    [self setScale:scaleFactor.floatValue*self.curScaleFactor];
    
    
}
-(void)color:(UIColor *)color{
    self.color=color;
}

-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}
@end
