//
//  EyelashLeftNode.m
//  face plus
//
//  Created by linxudong on 12/19/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "EyelashLeftNode.h"
#import "EyelashRightNode.h"

@implementation EyelashLeftNode
@synthesize curAngle,curScaleFactor,bindActionNode;
-(instancetype) initWithImageNamed:(NSString *)name{
    // SKTextureAtlas * main=[SKTextureAtlas atlasNamed:sucaiAtlas ];
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= eyelashLeftLayerName;
    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;
    return self;
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

-(void)syncRotate:(NSNumber*)angle{
    EyelashRightNode* pair=(EyelashRightNode*)[self bindActionNode];
    [self setZRotation:self.curAngle+angle.floatValue];
    [pair setZRotation:pair.curAngle-angle.floatValue];
    
    
    
}

-(void)zoom:(NSNumber*)scaleFactor{
 
        
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];
        [self.bindActionNode setScale:scaleFactor.floatValue*self.curScaleFactor];
  
}

-(void)syncDrag:(NSValue *)dest{
    
    DPI300Node* parent=(DPI300Node*)[self parent];
    CGFloat angle=parent.zRotation;
    
    CGPoint pariPosition=CGPointMake(
                                     dest.CGPointValue.x*cos(angle)+dest.CGPointValue.y*sin(angle),
                                     -dest.CGPointValue.x*sin(angle)+dest.CGPointValue.y*cos(angle)
                                     );
    
    CGPoint actualPosition=CGPointZero;
    
    //显然成立
    angle=-angle;
    actualPosition=CGPointMake(
                               dest.CGPointValue.x*cos(angle)+dest.CGPointValue.y*sin(angle),
                               -dest.CGPointValue.x*sin(angle)+dest.CGPointValue.y*cos(angle)
                               );
    
    
    
    //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+actualPosition.x/12.0,self.curPosition.y-actualPosition.y/12.0 );
    
    self.position=finalPosition;
    
    self.bindActionNode.position=CGPointMake(self.bindActionNode.curPosition.x+pariPosition.x/12.0,self.bindActionNode.curPosition.y-pariPosition.y/12.0 );
}

@end
