//
//  FeatureArray.h
//  face plus
//
//  Created by linxudong on 14/11/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeatureArray : NSObject
@property NSMutableArray* faceArray;
@property NSMutableArray* mouthArray;
@property NSMutableArray* noseArray;
@property NSMutableArray* earArray;
@property NSMutableArray* eyeArray;
@property NSMutableArray* browArray;
@property NSMutableArray* hairArray;
@property NSMutableArray* frontHairArray;
@property NSMutableArray* behindHairArray;

@property NSMutableArray* eyeballArray;
@property NSMutableArray* whelkArray;
@property NSMutableArray* glassArray;
@property NSMutableArray* neckArray;
@property NSMutableArray* capArray;
@property NSMutableArray* backgroundArray;

@property NSMutableArray* beardArray;
//@property NSMutableArray* tattooArray;
//@property NSMutableArray* underEyeArray;

@property NSMutableArray* fontArray;
@property NSMutableArray* whiskerArray;

+(instancetype)singleton;
@end
