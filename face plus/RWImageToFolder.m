//
//  SaveImageToFolder.m
//  face plus
//
//  Created by linxudong on 12/6/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "RWImageToFolder.h"
#import "GetTime.h"
@implementation RWImageToFolder
+(NSString*)save:(UIImage*)image{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dir = [docDir stringByAppendingPathComponent:@"SavedImages"];
    
    NSString*fileName=[[GetTime getTimeString] stringByAppendingString:@".png"];
    NSString* path=[dir stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:path atomically:false];
    return fileName;
   
}


+(NSString*)saveWithName:(UIImage*)image fileName:(NSString*)fileName{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dir = [docDir stringByAppendingPathComponent:@"SavedImages"];
    
    NSString* path=[dir stringByAppendingPathComponent:fileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:path atomically:false];
    return fileName;
    
}


+(UIImage*)readImage:(NSString*)fileName{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dir = [docDir stringByAppendingPathComponent:@"SavedImages"];
    NSString *filePath=[dir stringByAppendingPathComponent:fileName];
    
    NSData *pngData = [NSData dataWithContentsOfFile:filePath];
    UIImage *image = [UIImage imageWithData:pngData];
    return image;
}

+(void)removeImage:(NSString*)fileName{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dir = [docDir stringByAppendingPathComponent:@"SavedImages"];
    NSString *filePath=[dir stringByAppendingPathComponent:fileName];
    
    
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:filePath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
  }
@end
