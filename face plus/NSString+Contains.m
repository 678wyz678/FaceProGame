//
//  NSString+Contains.m
//  face plus
//
//  Created by linxudong on 4/3/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "NSString+Contains.h"

@implementation NSString (Contains)
- (BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end
