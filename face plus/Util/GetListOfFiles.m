//
//  GetListOfFiles.m
//  face plus
//
//  Created by linxudong on 12/6/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "GetListOfFiles.h"

@implementation GetListOfFiles
+(NSArray*)getListOfFiles:(NSString*)path{
  
        //-----> LIST ALL FILES <-----//
     //   NSLog(@"LISTING ALL FILES FOUND");
        
       // int count;
        
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
//        for (count = 0; count < (int)[directoryContent count]; count++)
//        {
//            NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
//        }
        return directoryContent;
    
}
@end
