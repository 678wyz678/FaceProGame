//
//  GirlHairEntity.m
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "GirlHairEntity.h"

@implementation GirlHairEntity
-(instancetype)initWithGirlBehindHair:(NSString*) selfFileName behindHair:(NSString*)behindHair{
    if(self=[super init:selfFileName]){
        self.behindGirlHair=behindHair;
    }
    return self;
}



-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.behindGirlHair forKey:@"behindGirlHair"];
  
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.behindGirlHair=[aDecoder decodeObjectForKey:@"behindGirlHair"];
    }
    return self;
}
@end
