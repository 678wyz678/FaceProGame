//
//  NoseNode.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "NoseNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"


@implementation NoseNode
@synthesize curAngle;
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= noseLayerName  ;
        self.zPosition=102;
        self.tag=@"鼻子";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=7;
        self.selectedPriority=10;
        [self calculateExifWithFileName:name ];
     
//        

    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
    
}
-(void)drag:(NSValue*)dest{
    MyScene* scene=[SKSceneCache singleton].scene ;
    
    FaceNode* face=(FaceNode*)[scene childNodeWithName:faceLayerName];
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y-dest.CGPointValue.y/12 );
    
    
    CGPoint coordinateInScene= [scene convertPoint:finalPosition fromNode:face];
    
    CGFloat yLimit=scene.size.height/2.0;
    CGFloat xLimit=scene.size.width/2.0;
    
    if (coordinateInScene.y <yLimit && coordinateInScene.y>(-yLimit)) {
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
    }
    if(coordinateInScene.x>-xLimit&&coordinateInScene.x<xLimit){
        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
    }

    
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    if(scaleFactor.floatValue*curScaleFactor
       <=2.4&&scaleFactor.floatValue*curScaleFactor
       >=0.3){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}





//不带png后缀的参数
-(void)calculateExifWithFileName:(NSString*)imageName{
    [self setScale:1.0f];

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
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:imageName];
    
    CGSize size=[Pixel2Point pixel2point:texture.size];
    self.size=CGSizeMake(size.width*scaleData, size.height*scaleData);
    self.anchorPoint=anchorData;
    
    
    
}
-(void)calculateExif:(BaseEntity*)entity{
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    [self calculateExifWithFileName:imageFileWithOutExtension];
}



//鼻子特殊：改变时候尺寸顾虑高度不管宽度
-(BOOL)changeTexture:(BaseEntity *)entity{
    
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
    
    
   
    if (![self hasActions]) {
        SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
        
        CGSize size=[Pixel2Point pixel2point:texture.size];

        
        
        
        SKTextureAtlas *bearAnimatedAtlas = [SKTextureAtlas atlasNamed:@"Bomb"];
        NSMutableArray *walkFrames=[[NSMutableArray alloc]init];
        int numImages = 38;
        for (int i=26; i <= numImages; i++) {
            NSString *textureName = [NSString stringWithFormat:@"bomb_%d", i];
            SKTexture *temp = [bearAnimatedAtlas textureNamed:textureName];
            
            [walkFrames addObject:temp];
        }
        self.texture=texture;
        SKAction* animation=[SKAction animateWithTextures:walkFrames timePerFrame:0.022 resize:NO restore:YES];
        //animation.timingMode=SKActionTimingEaseOut;
        [self runAction:animation completion:^{
            
            self.size=CGSizeMake(size.width*scaleData, size.height*scaleData);
            //[self setScale:scaleData];
            self.anchorPoint=anchorData;

           
            
        }];
        self.currentEntity=entity;
        
        
        
        return YES;
    }
   
return NO;

    
    }





//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    
}
-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}
@end
