//
//  EyelashNode.m
//  face plus
//
//  Created by linxudong on 12/8/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "EyelashNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "FaceNode.h"
#import "GlobalVariable.h"
#import "Pixel2Point.h"
@implementation EyelashNode
@synthesize curAngle;
@synthesize curScaleFactor;
-(instancetype) initWithImageNamed:(NSString *)name{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.zPosition=-1;
        self.tag=@"睫毛";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=12;//素材列表位置
        self.selectedPriority=12;
        self.color=[UIColor colorWithRed:0x16/255.f green:0x14/255.f blue:0x14/255.f alpha:1];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"EyelashOP" object:nil];
        

    }
    return self;
}

-(void)receiveColorNotification:(NSNotification*)notification{

    UIColor* color=[notification.userInfo objectForKey:@"color"];
    if (color) {
        self.color=color;
    }
    
    
  
 else   if ((NSValue*)[notification.userInfo objectForKey:@"dest"]) {
        CGPoint dest=((NSValue*)[notification.userInfo objectForKey:@"dest"]).CGPointValue;

        CGPoint finalPosition;
        if ([self.name isEqualToString:eyelashLeftLayerName]) {
            finalPosition=CGPointMake(self.curPosition.x+dest.x/6,self.curPosition.y -dest.y/6);
            
        }
        else{
            finalPosition=CGPointMake(self.curPosition.x-dest.x/6, self.curPosition.y-dest.y/6);
        }
        
        [self setPosition:finalPosition];
    }
    
   else if ([notification.userInfo objectForKey:@"scaleFactor"]) {
       CGFloat scaleFactor=((NSNumber*)[notification.userInfo objectForKey:@"scaleFactor"]).floatValue;
       CGSize faceTextureSize=[Pixel2Point pixel2point:[SKSceneCache singleton].scene.faceNode.texture.size];

       //宽和高同时小于指定边界
       if(self.size.width*scaleFactor*curScaleFactor
          <=faceTextureSize.width*1&&self.size.height*scaleFactor*curScaleFactor
          <=faceTextureSize.width*1
          &&self.size.width*scaleFactor*curScaleFactor
          >=faceTextureSize.width*0.1&&self.size.height*scaleFactor*curScaleFactor
          >=faceTextureSize.width*0.1){
           
           [self setXScale: scaleFactor*self.curScaleFactor ];
           [self setYScale: scaleFactor*self.curScaleFactor ];

       }

    }
    
   
    
}


-(void)drag:(NSValue*)dest{
    
   

    NSDictionary* dict=NSDictionaryOfVariableBindings(dest);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EyelashOP" object:self userInfo:dict];
    
}

-(void)zoom:(NSNumber*)scaleFactor{
    
    NSDictionary* dict=NSDictionaryOfVariableBindings(scaleFactor);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EyelashOP" object:self userInfo:dict];
    
    }
-(BOOL)changeTexture:(BaseEntity *)entity{
    
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGFloat ratio=texture.size.height/texture.size.width;
    CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.size=size;
    
    self.currentEntity=entity;

    return YES;
}

-(void)color:(UIColor*)color{
    NSDictionary* dict=NSDictionaryOfVariableBindings(color);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"EyelashOP" object:self userInfo:dict];
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveColorNotification:) name:@"EyelashOP" object:nil];
    }
    return self;
}
@end
