//
//  BlushNode.m
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "AccessoryLeftNode.h"
#import "AccessoryRightNode.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "MyScene.h"
#import "SKSceneCache.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation AccessoryLeftNode
@synthesize curPosition;
@synthesize curAngle;
@synthesize curScaleFactor;
@synthesize bindActionNode;

-(instancetype) initWithImageNamed:(NSString *)name{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= accessoryLeftLayerName  ;
        self.zPosition=-6;
        self.tag=@"左附件（脸外）";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=12;
        self.selectedPriority=9;
        [self calculateExifWithFileName:name];
    
    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    if (self) {
        AccessoryRecordObject*object=[[AccessoryRecordObject alloc]initWithNodeAndImageFile:self currentEntity:entity];
        NSDictionary*dict=[NSDictionary dictionaryWithObject:object forKey:@"RECORD_OBJECT"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_RECORDS_OF_ACCESSORY" object:self userInfo:dict];
        self.currentEntity=entity;

    }
    return self;
}
-(void)syncRotate:(NSNumber*)angle{
    AccessoryRightNode* rightNode=(AccessoryRightNode*)self.bindActionNode;
    SKAction * action=[SKAction rotateToAngle:self.curAngle+angle.floatValue duration:0];
    SKAction * reverse=[SKAction rotateToAngle:rightNode.curAngle-angle.floatValue duration:0];
    [self runAction:action];
    [rightNode runAction:reverse];
}

-(void)syncDrag:(NSValue *)dest{
    AccessoryRightNode* pair=(AccessoryRightNode*)[self bindActionNode];
    
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    CGPoint pairPosition=CGPointMake(pair.curPosition.x+dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    
        
        [self setPosition:finalPosition];
        //如果pair node不nil
            [pair setPosition:pairPosition];
     
    
}

-(void)drag:(NSValue*)dest{
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    DPI300Node* pair=(DPI300Node*)[self bindActionNode];
    CGPoint pairPosition=CGPointMake(pair.curPosition.x-dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
           [self setPosition:finalPosition];
        //如果pair node不nil
            [pair setPosition:pairPosition];
    
    
}


//-(BOOL)changeTexture:(BaseEntity *)entity{
//
//}

-(void)zoom:(NSNumber*)scaleFactor{
//    CGSize faceTextureSize;
//    BOOL flag=true;
//    SKNode* parent=self;
//    while (flag) {
//        parent=parent.parent;
//        if ([parent.name isEqualToString:faceLayerName]) {
//            flag=NO;
//        }
//    }

   
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
    
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
    self.bindActionNode.color=color;
//    if (self.bindActionNode&&[self.bindActionNode conformsToProtocol:@protocol(P_Colorable)]) {
//        id<P_Colorable> bind=(id<P_Colorable>)self.bindActionNode;
//        [bind color:color];
//    }
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
    
    NSArray*tempColorStringArray = [scaleAndAnchor componentsSeparatedByString:@"%"];
    NSString*colorString=@"0x000000";
    if (tempColorStringArray.count>1) {
        colorString=tempColorStringArray[1];
        scaleAndAnchor=tempColorStringArray[0];
    }
    
    int number = (int)strtol(colorString.UTF8String, NULL, 0);
    self.color=UIColorFromRGB(number);
    
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
    self.position=CGPointMake(self.position.x+ size.width*anchorData.x,self.position.y+ size.height*anchorData.y);
    
    
}
-(void)calculateExif:(BaseEntity*)entity{
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    [self calculateExifWithFileName:imageFileWithOutExtension];
}






@end
