//
//  FeaturePosition.h
//  face plus
//
//  Created by linxudong on 14/11/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface FeaturePosition : NSObject
@property CGPoint leftEyePosition;
@property CGPoint rightEyePosition;
@property CGPoint earPosition;
@property CGPoint nosePosition;
@property CGPoint mouthPosition;
@property CGPoint browLeftPosition;
@property CGPoint browRightPosition;
@property CGPoint hairPosition;
@property CGPoint neckPosition;
+(instancetype)singleton;
@end
