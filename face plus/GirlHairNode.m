//
//  GirlHairNode.m
//  face plus
//
//  Created by linxudong on 12/15/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "GirlHairNode.h"
#import "FeatureLayer.h"
#import "Pixel2Point.h"
#import "FaceNode.h"
#import "GirlBehindHair.h"
#import "GlobalVariable.h"
#import <UIKit/UIKit.h>
#import "GirlHairEntity.h"
#import "GirlBehindHair.h"
@implementation GirlHairNode
-(instancetype) initWithImageNamed:(NSString *)name{
    
    self=[super initWithImageNamed:name];
    
    if (self!=nil) {
        
        self.tag=@"女发";
        GirlBehindHair* behindHair=[[GirlBehindHair alloc]initWithImageNamed:@"girl_behind_hair_1"];
        behindHair.size=self.size;
        [self addChild:behindHair];
    }
    return self;
}

-(instancetype) initWithEntity:(GirlHairEntity *)entity{
    
    self=[super initWithImageNamed:entity.selfFileName];
    
    if (self!=nil) {
        
        self.tag=@"女发";
        GirlBehindHair* behindHair=[[GirlBehindHair alloc]initWithImageNamed:entity.behindGirlHair];
        behindHair.size=self.size;
        [self addChild:behindHair];
    }
    return self;
}
-(void)changeTexture:(GirlHairEntity *)entity{

    [super changeTexture:entity];
    
}

-(void)color:(UIColor *)color{
    [super color:color];
   
}
@end
