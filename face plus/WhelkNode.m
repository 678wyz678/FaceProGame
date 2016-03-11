//
//  WhelkNode.m
//  face plus
//
//  Created by linxudong on 14/11/16.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "WhelkNode.h"
#import "GlobalVariable.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "MyScene.h"
#import "SKSceneCache.h"
@implementation WhelkNode
-(instancetype) initWithImageNamed:(NSString *)name{
   // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    
    if (self!=nil) {
        self.name= whelkLayerName  ;
        self.zPosition=10;
        self.tag=@"whelk痘痘";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.order=16;
        self.selectedPriority=11;
        
        FaceNode*face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
        CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];
        if (face) {
            self.position=CGPointMake(faceSize.width/2, -faceSize.width/2);
        }
        
        [[WhelkNode multipleNodeStack] addObject:self];
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
    
}
-(void)drag:(NSValue*)dest{
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/12.0,self.curPosition.y-dest.CGPointValue.y/12.0 );
    [self setPosition:finalPosition];
}

+(NSMutableArray*) multipleNodeStack{
    static NSMutableArray* array = nil;
    
    if (array == nil)
    {
        array=[[NSMutableArray alloc]init];
    }
    
    return array;

}
@end
