//
//  SaveImageToFolder.h
//  face plus
//
//  Created by linxudong on 12/6/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RWImageToFolder : NSObject
+(NSString*)save:(UIImage*)image;
+(UIImage*)readImage:(NSString*)fileName;

+(void)removeImage:(NSString*)fileName;
+(NSString*)saveWithName:(UIImage*)image fileName:(NSString*)fileName;
@end
