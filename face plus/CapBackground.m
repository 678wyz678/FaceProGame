//
//  CapBackground.m
//  face plus
//
//  Created by linxudong on 1/10/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "CapBackground.h"
#import "CapNode.h"
#import "CapWithBackgroundEntity.h"
@implementation CapBackground
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        
        self=[super initWithImageNamed:name];    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= capBackgroundLayerName  ;
        self.zPosition=-132;
        self.tag=@"帽子background";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.position=CGPointZero;
        self.blendMode=SKBlendModeAlpha;
        self.selectable=NO;
        self.dontRandomColor=YES;
    }
    return self;
}
-(instancetype) initWithEntity:(CapWithBackgroundEntity *)entity{
    self=[self initWithImageNamed:entity.backgroundFileName];
    self.currentEntity=entity;
    return self;
}
//切换素材
-(BOOL)changeTexture:(CapWithBackgroundEntity *)entity{
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.backgroundFileName];
    //与父层同大
    CapNode* parent= ((CapNode*)[self parent]);
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.currentEntity=entity;
return YES;
}
@end
