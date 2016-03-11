//
//  ReLayout.h
//  face plus
//
//  Created by linxudong on 14/11/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SKScene;
@interface ReLayout : NSObject
+(void)layout:(SKScene*)scene;
+(void)adjustScale:(SKScene*)scene;
+(void)adjustFacePosition:(SKScene*)scene ratio:(NSNumber*  )textureRatio;
@end
