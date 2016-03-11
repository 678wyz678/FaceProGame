//
//  BaseEntity.h
//  face plus
//
//  Created by linxudong on 14/11/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
@class DPI300Node;
@interface BaseEntity : NSObject<NSCoding>
@property NSString* selfFileName;
@property NSString* selfShadowFileName;
@property NSString* selfPairFileName;
@property NSString* selfMaskFileName;

@property NSString* indexFileName;
@property NSString* updatedForFreeIndexFileName;
-(instancetype)init:(NSString*)textureName;
-(instancetype)initWithShadow:(NSString*) selfFileName shadowFile:(NSString*) selfShadowFileName;
-(instancetype)initWithPair:(NSString*) selfFileName pairFile:(NSString*) selfPairFileName;
-(instancetype)initWithMask:(NSString*) selfFileName maskFile:(NSString*) selfMaskFileName;

@end
