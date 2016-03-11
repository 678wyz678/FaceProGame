//
//  FaceMeasure.h
//  face plus
//
//  Created by linxudong on 14/11/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FeaturePosition,SKTexture;
@interface FaceMeasure : NSObject
+(FeaturePosition*)measure:(SKTexture*)faceTexture;

@end
