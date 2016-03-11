//
//  BrowLikeSmallBeard.m
//  face plus
//
//  Created by linxudong on 15/1/26.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "BrowLikeSmallBeard.h"
#import "Pixel2Point.h"
#import "RightBrowLikeSmallBeard.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"
#import "BrowEntity.h"
#import "BrowShadow.h"
@implementation BrowLikeSmallBeard
@synthesize curAngle;
@synthesize bindActionNode;
@synthesize curPosition;
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= browLikeSmallBeardLayerName  ;
        self.zPosition=100;
        self.tag=@"小胡子(可旋转)";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=9;
        self.selectedPriority=10;
        self.color=[UIColor blackColor];
    }
    return self;
}
-(void)rotateMyself:(NSNumber*)angle{
  
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    [self calculateExifWithFileName:entity.selfFileName];

    return self;
}

-(void)syncRotate:(NSNumber*)angle{
    RightBrowLikeSmallBeard* rightNode=(RightBrowLikeSmallBeard*)self.bindActionNode;
    SKAction * action=[SKAction rotateToAngle:self.curAngle+angle.floatValue duration:0];
    SKAction * reverse=[SKAction rotateToAngle:rightNode.curAngle-angle.floatValue duration:0];
    [self runAction:action];
    [rightNode runAction:reverse];
}

-(void)syncDrag:(NSValue *)dest{
    RightBrowLikeSmallBeard* pair=(RightBrowLikeSmallBeard*)[self bindActionNode];
    
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    CGPoint pairPosition=CGPointMake(pair.curPosition.x+dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    
        [self setPosition:finalPosition];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:pairPosition];
        }

}

-(void)drag:(NSValue*)dest{
    FaceNode* face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12,self.curPosition.y -dest.CGPointValue.y/12);
    DPI300Node* pair=(DPI300Node*)[self bindActionNode];
    CGPoint pairPosition=CGPointMake(pair.curPosition.x-dest.CGPointValue.x/12, pair.curPosition.y-dest.CGPointValue.y/12);
    
    if (finalPosition.y<0&&finalPosition.y>=-[Pixel2Point pixel2point:face.texture.size].height) {
        
        
        [self setPosition:CGPointMake(self.position.x, finalPosition.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pair.position.x, pairPosition.y)];
        }
    }
    
    if ( (finalPosition.x-pairPosition.x)<0&&finalPosition.x>-[Pixel2Point pixel2point:face.texture.size].width/2.0f) {
        
        
        [self setPosition:CGPointMake(finalPosition.x, self.position.y)];
        //如果pair node不nil
        if (pair) {
            [pair setPosition:CGPointMake(pairPosition.x, pair.position.y)];
        }
    }
    
    
}


-(BOOL)changeTexture:(BrowEntity *)entity{
    [self setScale:1.f];
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    
    self.texture=texture;

    [self calculateExifWithFileName:entity.selfFileName];

    self.currentEntity=entity;
    
    [self calculateExifWithFileName:entity.selfFileName];
return YES;
}

-(void)zoom:(NSNumber*)scaleFactor{
//    if(scaleFactor.floatValue*curScaleFactor
//       <=100&&scaleFactor.floatValue*curScaleFactor
//       >=0.9){
    
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];

   // }
    
}
//换颜色
-(void)color:(UIColor *)color{
    self.color=color;
//    if (self.bindActionNode&&[self.bindActionNode conformsToProtocol:@protocol(P_Colorable)]) {
//        id<P_Colorable> bind=(id<P_Colorable>)self.bindActionNode;
//        [bind color:color];
//    }
    self.bindActionNode.color=color;
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

    //NSLog(@"browlike:position:%@",NSStringFromCGPoint(self.position));

}
-(void)calculateExif:(BaseEntity*)entity{
    NSString*imageFileWithOutExtension=  [entity.selfFileName stringByReplacingOccurrencesOfString:@".png" withString:@""];
    [self calculateExifWithFileName:imageFileWithOutExtension];
}



@end

