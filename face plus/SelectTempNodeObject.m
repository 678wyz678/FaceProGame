//
//  SelectTempNodeObject.m
//  face plus
//
//  Created by linxudong on 15/2/11.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "SelectTempNodeObject.h"
#import <SpriteKit/SpriteKit.h>
@implementation SelectTempNodeObject

-(BOOL)isEqual:(id)object{
    if (![object isKindOfClass:[SelectTempNodeObject class]]) {
        return NO;
    }
    
    if ([self.node isEqual:((SelectTempNodeObject*)object).node ]) {
        return YES;
    }
    return NO;
}
@end
