//
//  GaussianBlurNode.h
//  face plus
//
//  Created by linxudong on 12/19/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@class DPI300Node;
@interface GaussianBlurNode : SKEffectNode
-(instancetype)initWithParentNode:(DPI300Node*)parentNode ;
-(BOOL)changeTexture:(NSString*)textureName;

-(void)reSizeBlur:(NSValue*)size;

@end
