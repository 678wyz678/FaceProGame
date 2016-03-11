//
//  Color2Image.h
//  face plus
//
//  Created by linxudong on 12/22/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Color2Image : NSObject
+(UIImage *)imageWithColor:(UIColor *)color ;
+(UIColor*)random;

+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)x andY:(int)y count:(int)count;

@end
