//
//  DoubleEyeEntity.m
//  face plus
//
//  Created by linxudong on 12/23/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "DoubleEyeEntity.h"

@implementation DoubleEyeEntity
-(instancetype)initWithSelf:(NSString*)selfFile selfBigFile:(NSString*)selfBigFile pairSmallFile:(NSString*)pairSmallFile  pairBigFile:(NSString*)pairBigFile{
    if (self=[super init]) {
        self.selfSmallFile=selfFile;
        self.selfBigFile=selfBigFile;
        self.pairBigFile=pairBigFile;
        self.pairSmallFile=pairSmallFile;
                
    }

    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.pairBigFile forKey:@"pairBigFile"];
    [aCoder encodeObject:self.pairSmallFile forKey:@"pairSmallFile"];
    [aCoder encodeObject:self.selfBigFile forKey:@"selfBigFile"];
    [aCoder encodeObject:self.selfSmallFile forKey:@"selfSmallFile"];

    
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.pairBigFile=[aDecoder decodeObjectForKey:@"pairBigFile"];
        self.pairSmallFile=[aDecoder decodeObjectForKey:@"pairSmallFile"];
        self.selfBigFile=[aDecoder decodeObjectForKey:@"selfBigFile"];
        self.selfSmallFile=[aDecoder decodeObjectForKey:@"selfSmallFile"];

    }
    return self;
}
@end
