//
//  CapWithBackgroundEntity.m
//  face plus
//
//  Created by linxudong on 1/10/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "CapWithBackgroundEntity.h"

@implementation CapWithBackgroundEntity
-(instancetype)initWithBackgroundFile:(NSString*)selfFile shadowFile:(NSString*)shadowFile backgroundFile:(NSString*)backgroundFile{
    if (self=[super initWithShadow:selfFile shadowFile:shadowFile]) {
        self.backgroundFileName=backgroundFile;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.backgroundFileName forKey:@"backgroundFileName"];
    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.backgroundFileName=[aDecoder decodeObjectForKey:@"backgroundFileName"];
    }
    return self;
}
@end
