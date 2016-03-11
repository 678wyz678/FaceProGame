//
//  GlassNode.m
//  face plus
//
//  Created by linxudong on 14/11/17.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "GlassNode.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "FaceNode.h"
#import "GlobalVariable.h"
#import "Pixel2Point.h"
#import "GlassEntity.h"
#import "GlassShadow.h"
#import "SingleGlassEntity.h"
@interface GlassNode()
@property (assign,nonatomic)BOOL isDoubleGlass;
@end
@implementation GlassNode
@synthesize curScaleFactor,curAngle;
-(instancetype) initWithImageNamed:(NSString *)name{
    //SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= glassLayerName;
        self.zPosition=101;
        self.tag=@"眼镜";
        self.anchorPoint=CGPointMake(0.5, 1);
        self.order=13;//素材列表位置
        self.color=[UIColor blackColor];
        self.selectedPriority=12;
        FaceNode*face=(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
        
        CGSize faceSize=[Pixel2Point pixel2point:face.texture.size];
        if (face) {
            self.position=CGPointMake(faceSize.width/2, -faceSize.width/2);
        }

        
        CGFloat ratio=self.texture.size.height/self.texture.size.width;
        self.size=CGSizeMake(faceSize.width,faceSize.width*ratio);
  
   
    }
    return self;
}
-(instancetype) initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    if (self) {
        //添加阴影
        if (entity.selfShadowFileName) {
            GlassShadow* shadow=[[GlassShadow alloc]initWithImageNamed:entity.selfShadowFileName];
            shadow.size=self.size;
            [self addChild:shadow];
            _isDoubleGlass=YES;
        }
       
        self.currentEntity=entity;
    }
    return self;
}
-(void)drag:(NSValue*)dest{
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/6,self.curPosition.y-dest.CGPointValue.y/6 );

    [self setPosition:finalPosition];
}



//有单双眼镜模式
-(BOOL)changeTexture:(BaseEntity *)entity{
    
    
    
    SKTexture* texture=[SKTexture textureWithImageNamed:entity.selfFileName];
    CGSize size= [Pixel2Point pixel2point:texture.size];
    //转换历史scale后的大小
    self.size=CGSizeMake(size.width*self.xScale, size.height*self.yScale);
    self.texture=texture;
    
    BOOL isDoubleGlassEntity=[entity isKindOfClass:[GlassEntity class]];
    BOOL isSingleGlassEntity=[entity isKindOfClass: [SingleGlassEntity class]];
    
    if (isDoubleGlassEntity) {
        self.isDoubleGlass=YES;
        if ([self childNodeWithName:glassShadowLayerName]) {
            GlassShadow* glassShadow=(GlassShadow*)[self childNodeWithName:glassShadowLayerName];
            [glassShadow changeTexture:entity];
        }
        else{
            GlassShadow* glassShadow=[[GlassShadow alloc]initWithImageNamed:entity.selfShadowFileName];
            [self addChild:glassShadow];
        }
    }
    if (isSingleGlassEntity){
        self.isDoubleGlass=NO;
        if ([self childNodeWithName:glassShadowLayerName]) {
            [[self childNodeWithName:glassShadowLayerName] removeFromParent];
        }
    }
    
    self.currentEntity=entity;
    return YES;
    
    

}

-(void)zoom:(NSNumber*)scaleFactor{
    
    if(scaleFactor.floatValue*curScaleFactor
       <=1.6&&scaleFactor.floatValue*curScaleFactor
       >=0.5){
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        
    }
}
-(void)color:(UIColor *)color{
    if (_isDoubleGlass) {
        self.color=color;
    }
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        _isDoubleGlass = ((NSNumber*)[aDecoder decodeObjectForKey:@"isDoubleGlass"]).boolValue;
    }
    return self;
}


-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isDoubleGlass] forKey:@"isDoubleGlass"];
   }
@end
