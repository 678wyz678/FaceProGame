//
//  BodyShadowNode.m
//  face plus
//
//  Created by linxudong on 15/2/2.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "BodyShadowNode.h"
#import "Pixel2Point.h"

@implementation BodyShadowNode
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        self=[super initWithImageNamed:name];
    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= bodyShadowLayerName  ;
        self.zPosition=1;
        self.tag=@"身体shadow";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.position=CGPointZero;
        self.selectable=NO;
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

