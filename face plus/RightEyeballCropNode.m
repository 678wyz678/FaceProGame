//
//  RightEyeballCropNode.m
//  face plus
//
//  Created by linxudong on 1/17/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "RightEyeballCropNode.h"

@implementation RightEyeballCropNode
-(instancetype) initWithEyeballName:(NSString*)eyeballName textureOfParent:(DPI300Node*)parentNode{
    self=[super initWithEyeballName:eyeballName textureOfParent:parentNode];
    if (self!=nil) {
        self.name=eyeballRightCropLayerName;
    }
    return self;
}

@end
