//
//  BrowShadow.m
//  face plus
//
//  Created by linxudong on 12/12/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "BrowShadow.h"
#import "BrowLeftNode.h"
#import "BrowRightNode.h"
#import "BrowEntity.h"
@implementation BrowShadow
-(instancetype) initWithImageNamed:(NSString *)name{
    if (name) {
        //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
        
        SKTexture* texture=[SKTexture textureWithImageNamed:name];
        self=[super initWithTexture:texture];
    }
    else{
        self=[super init];
    }
    if (self!=nil) {
        self.name= browShadowLayerName  ;
        self.zPosition=0;
        self.tag=@"眉毛阴影";
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.position=CGPointZero;
    }
    return self;
}

//注意父层锚点(0,0)
-(void)changeTexture:(BrowEntity *)entity{
    NSString *shadow=nil;
    DPI300Node* parent= ((DPI300Node*)[self parent]);
    //是左边的眉毛的话，加载left眉毛shadow
    if ([parent isKindOfClass:[BrowLeftNode class]]) {
        shadow=entity.leftShadowFile;
    }
    else if([parent isKindOfClass:[BrowRightNode class]]){
        shadow=entity.rightShadowFile;
    }
    SKTexture* texture=[SKTexture textureWithImageNamed:shadow];
    //重置scale
    self.xScale=1.0;
    self.yScale=1.0;
    //与父层同大
    
    
    self.size=CGSizeMake(parent.size.width/parent.xScale, parent.size.height/parent.yScale);
    self.texture=texture;
    self.position=CGPointZero;
    
    
}
@end
