//
//  GetTime.m
//  face plus
//
//  Created by linxudong on 12/6/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "GetTime.h"

@implementation GetTime

+(NSString*)getTimeString{
    NSDate * now = [NSDate date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *newDateString = [outputFormatter stringFromDate:now];
    return newDateString;
}

@end
