//
//  RemovePostFix.m
//  face plus
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "RemovePostFix.h"

@implementation RemovePostFix
+(NSString*)removePostFix:(NSString*)sourceString{
    NSString *test=@".png$";
    NSError* error=nil;
    NSRegularExpression *reg=[[NSRegularExpression alloc]initWithPattern:test options:NSRegularExpressionCaseInsensitive error:&error];

    if([reg matchesInString:sourceString options:0 range:NSMakeRange(0, sourceString.length)].count){
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[reg matchesInString:sourceString options:0 range:NSMakeRange(0, sourceString.length)] objectAtIndex:0];
        NSString* resultString=[[NSString alloc]initWithFormat:@"%@",[sourceString substringWithRange:NSMakeRange(0,sourceString.length-4)]];
        return resultString;
    }
    return sourceString;
}
@end
