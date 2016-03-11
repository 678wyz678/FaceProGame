//
//  UnderEyeNode.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "UnderEyeNode.h"
#import "FeatureLayer.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "MyScene.h"
#import "SKSceneCache.h"
#import "GlobalVariable.h"
@implementation UnderEyeNode
@synthesize curScaleFactor;
@synthesize curAngle;

-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
       // self.name= underEyeLayerName ;
        self.zPosition=-2;
        self.tag=@"眼影";
        self.anchorPoint=CGPointMake(0.5,0.75);
        self.order=12;
        self.selectedPriority=10;
        self.color=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
      
    }
    return self;
}


//空，子类覆写
-(void)drag:(NSValue*)dest{
   }

-(void)color:(UIColor *)color{
    self.color=color;
}

//
-(void)zoom:(NSNumber *)scaleFactor{
}




@end
