//
//  DetectFeatureKind.h
//  face plus
//
//  Created by linxudong on 14/11/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImportAllEntity.h"
#import "FeatureArray.h"

@interface DetectFeatureKind : NSObject
+(void)detectFeatureAndAddToCache:(NSString*)featureName indexFilePath:(NSString*)indexFilePath;
@end
