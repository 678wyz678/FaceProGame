//
//  FromFileToUIImage.m
//  face plus
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "FromFileToUIImage.h"
//#import "GPUImageiOSBlurFilter.h"
//#import "GPUImageFilter.h"
@implementation FromFileToUIImage
//+(UIImage*)fromFileToUIImage:(NSString*)fileName{
//    GPUImageiOSBlurFilter * blurFilter = [GPUImageiOSBlurFilter new];
//    UIImage* image=[[UIImage alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]];
//  //  blurFilter.blurRadiusInPixels=2.0;
//    // Apply filter.
//    
//    UIImage *blurredSnapshotImage = [blurFilter imageByFilteringImage:image];
//   
//    return blurredSnapshotImage;
//    
//}
//+ (UIImage *)imageWithColor:(UIColor *)color imageSize:(CGSize)size{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    rect.size=size;
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return image;
//}
//
//+(UIImage*)BlurFromUIImageToUIImage:(UIImage*)image{
//    GPUImageiOSBlurFilter * blurFilter = [GPUImageiOSBlurFilter new];
//    blurFilter.blurRadiusInPixels=10;
//    
//    UIImage *blurredSnapshotImage = [blurFilter imageByFilteringImage:image];
//    
//    return blurredSnapshotImage;
//    
//}

@end
