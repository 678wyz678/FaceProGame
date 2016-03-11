//
//  Pixel2Point.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "Pixel2Point.h"

@implementation Pixel2Point
+(CGSize)pixel2point:(CGSize)size{
    return CGSizeMake(size.width*72/300, size.height*72/300);
}
@end
