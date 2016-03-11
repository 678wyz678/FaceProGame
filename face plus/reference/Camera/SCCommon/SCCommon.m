//
//  SCCommon.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-19.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "SCCommon.h"
#import "SCDefines.h"
#import <QuartzCore/QuartzCore.h>
#import "ALAssetsLibrary+CustomPhotoAlbum.h"

@implementation SCCommon


/**
 *  UIColor生成UIImage
 *
 *  @param color     生成的颜色
 *  @param imageSize 生成的图片大小
 *
 *  @return 生成后的图片
 */
+ (UIImage*)createImageWithColor:(UIColor*)color size:(CGSize)imageSize {
    CGRect rect=CGRectMake(0.0f, 0.0f, imageSize.width, imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//画一条线
+ (void)drawALineWithFrame:(CGRect)frame andColor:(UIColor*)color inLayer:(CALayer*)parentLayer {
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [parentLayer addSublayer:layer];
}

#pragma mark -------------save image to local---------------
//保存照片至本机
+ (void)saveImageToPhotoAlbum:(UIImage*)image {
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

+ (void)saveImageToCustomAlbum:(UIImage *)image
                 withAlbumName:(NSString *)albumName {
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  [library saveImage:image
             toAlbum:albumName
          completion:^(NSURL *assetURL, NSError *error) {
            NSLog(@"save image success = %@", assetURL);
          } failure:^(NSError *error) {
            NSLog(@"save image failed = %@", error);
          }];
}

+ (void)saveVideoToCustomAlbum:(NSURL *)videoUrl
                 withAlbumName:(NSString *)albumName {
  ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
  [library saveVideo:videoUrl
             toAlbum:albumName
          completion:^(NSURL *assetURL, NSError *error) {
            NSLog(@"save video success = %@", assetURL);
          } failure:^(NSError *error) {
            NSLog(@"save video failed = %@", error);
          }];
}

+ (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error != NULL) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error occurs during saving!" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        SCDLog(@"Saved");
    }
}

@end