//
//  MouthMask.m
//  face plus
//
//  Created by linxudong on 14/11/10.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "MouthMask.h"
#import "Pixel2Point.h"

@implementation MouthMask
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        self=[super initWithImageNamed:name];
    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= mouthMaskLayerName  ;
        self.zPosition=1;
        self.tag=@"嘴巴mask";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.position=CGPointZero;
        self.selectable=NO;
        self.dontRandomColor=YES;
    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfShadowFileName];
    self.currentEntity=entity;
    return self;
    
}
//切换素材
-(BOOL)changeTexture:(BaseEntity *)entity{
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfShadowFileName];
    //与父层同大
    DPI300Node* parent= ((DPI300Node*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.currentEntity=entity;
return YES;
}
-(void)color:(UIColor *)color{
    self.color=color;
}
@end
