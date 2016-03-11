//
//  CreateDirIfNotExist.m
//  face plus
//
//  Created by linxudong on 12/6/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "CreateDirIfNotExist.h"

@implementation CreateDirIfNotExist
+(void)createDirIfNotExist:(NSString*)dirName{
    NSString *docDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *dir = [docDir stringByAppendingPathComponent:dirName];
    BOOL isDir;
    NSFileManager *fm = [NSFileManager defaultManager];
    if(![fm fileExistsAtPath:dir isDirectory:&isDir])
    {
        if([fm createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:nil])
            NSLog(@"Directory Created");
        else
            NSLog(@"Directory Creation Failed");
    }
    else
        NSLog(@"Directory Already Exist");
}
@end
