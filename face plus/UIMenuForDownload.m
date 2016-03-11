//
//  UIMenuForDownload.m
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "UIMenuForDownload.h"
#import "GenerateGIF.h"

#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>

@implementation UIMenuForDownload

-(instancetype)init{
    if (self=[super init]) {
        [self addTarget:self action:@selector(download) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)download{
    //makeAnimatedGif();
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_PHOTO" object:self];
}



//static void makeAnimatedGif(void) {
//    static NSUInteger const kFrameCount = 16;
//    NSDictionary *fileProperties = @{
//                                     (__bridge id)kCGImagePropertyGIFDictionary: @{
//                                             (__bridge id)kCGImagePropertyGIFLoopCount: @0, // 0 means loop forever
//                                             }
//                                     };
//    NSDictionary *frameProperties = @{
//                                      (__bridge id)kCGImagePropertyGIFDictionary: @{
//                                              (__bridge id)kCGImagePropertyGIFDelayTime: @0.04f, // a float (not double!) in seconds, rounded to centiseconds in the GIF data
//                                              }
//                                      };
//    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:@"animated.gif"];
//    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
//    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
//    
//    for (NSUInteger i = 30; i <= 45; i++) {
//        @autoreleasepool {
//            UIImage *image = frameImage(i);
//            CGImageDestinationAddImage(destination, image.CGImage, (__bridge CFDictionaryRef)frameProperties);
//        }
//    }
//    if (!CGImageDestinationFinalize(destination)) {
//        NSLog(@"failed to finalize image destination");
//    }
//    CFRelease(destination);
//    
//    NSLog(@"url=%@", fileURL);
//}
//
//
//static UIImage *frameImage(NSUInteger index){
//    NSString*bundle=[[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"/bodyFrame/run_%lu",index] ofType:@"png"];
//    UIImage* image=[UIImage imageWithContentsOfFile:bundle];
//    //NSLog(@"image:%@",image);
//    return image;
//}
@end
