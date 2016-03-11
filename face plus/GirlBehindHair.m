//
//  GirlBehindHair.m
//  face plus
//
//  Created by linxudong on 12/15/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "GirlBehindHair.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "GlobalVariable.h"
#import "GirlHairEntity.h"
@implementation GirlBehindHair
-(instancetype) initWithImageNamed:(NSString *)name{
    
    SKTexture* texture=[SKTexture textureWithImageNamed:name];
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.name= girlBehindHairLayerName  ;
        self.zPosition=-106;
        self.tag=@"女发后发";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.order=2;
        self.position=CGPointZero;
        self.selectable=NO;
      
        
    }
    return self;
}

-(instancetype) initWithEntity:(GirlHairEntity *)entity{
    
    self=[self initWithImageNamed:entity.behindGirlHair];
    self.currentEntity=entity;
    return self;
}

-(void)updateHairColor:(NSNotification*)sender{
    UIColor * color=[sender.userInfo objectForKey:@"Color"];
    self.color=color;
}

-(BOOL)changeTexture:(GirlHairEntity *)entity{
    //self.xScale=1.0;
    //self.yScale=1.0;
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.behindGirlHair];
   // CGFloat ratio=texture.size.height/texture.size.width;
    //CGSize size=CGSizeMake(self.size.width, self.size.width*ratio);
    
    self.texture=texture;
    self.position=CGPointZero;
    self.currentEntity=entity;
return YES;
    
}
//换颜色
-(void)color:(UIColor *)color{
        self.color=color;
    
}
@end
