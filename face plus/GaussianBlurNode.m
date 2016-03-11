//
//  GaussianBlurNode.m
//  face plus
//
//  Created by linxudong on 12/19/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "GaussianBlurNode.h"
#import "FeatureLayer.h"
#import "DPI300Node.h"
@interface GaussianBlurNode()
@property (weak)DPI300Node* parentNode;
@property SKSpriteNode* shadowNode;
@end

@implementation GaussianBlurNode

-(instancetype)initWithParentNode:(DPI300Node*)parentNode {
    if (self=[super init]) {
        self.shouldEnableEffects = YES;
        self.name=gaussianBlurLayerName;
        self.position = CGPointMake(0.75, -0.74);
        self.zPosition = self.zPosition-130;
        
        self.parentNode=parentNode;
        
        
        _shadowNode=[[SKSpriteNode alloc]initWithTexture:parentNode.texture];
        _shadowNode.color=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        _shadowNode.position=CGPointMake(0,0);
        _shadowNode.zPosition=10;
        _shadowNode.name=@"blur";
        _shadowNode.size=parentNode.size;
        _shadowNode.blendMode=SKBlendModeAlpha;
        _shadowNode.colorBlendFactor=1.0;
        _shadowNode.anchorPoint=parentNode.anchorPoint;
        [self addChild:_shadowNode];
        CIFilter * filter=[CIFilter filterWithName:@"CIGaussianBlur"];
        [filter setDefaults];
        [filter setValue: @2.6 forKey:@"inputRadius"];
        
        self.filter = filter;

    }
    
        return self;
}


-(void)reSizeBlur:(NSValue*)size{
SKSpriteNode*blur=(SKSpriteNode*)[self childNodeWithName:@"blur"];
    [blur setSize:size.CGSizeValue];
}

-(BOOL)changeTexture:(NSString*)textureName{
    SKSpriteNode*blur=(SKSpriteNode*)[self childNodeWithName:@"blur"];
    if (blur) {
        SKTexture* texture=[SKTexture textureWithImageNamed:textureName];
        CGFloat ratio=texture.size.height/texture.size.width;
        CGSize size=CGSizeMake(blur.size.width, blur.size.width*ratio);
        blur.texture=texture;
        blur.anchorPoint=_parentNode.anchorPoint;
        blur.size=size;
        return YES;
    }
    return NO;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.shouldEnableEffects=YES;
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
}
@end
