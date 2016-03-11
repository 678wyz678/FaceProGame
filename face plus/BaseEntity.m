//
//  BaseEntity.m
//  face plus
//
//  Created by linxudong on 14/11/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "BaseEntity.h"
#import <SpriteKit/SpriteKit.h>
#import "ImportAllEntity.h"
@implementation BaseEntity
-(instancetype)init:(NSString*)textureName{
    return [self initWithShadow:textureName shadowFile:nil];
}
-(instancetype)initWithPair:(NSString*) selfFileName pairFile:(NSString *)selfPairFileName{
    self=[super init];
    if (self) {
        if (selfFileName!=nil) {
            self.selfFileName=selfFileName;
        }
        if (selfPairFileName!=nil) {
            self.selfPairFileName=selfPairFileName;
        }
    }    return self;
}

-(instancetype)initWithShadow:(NSString *)selfFileName shadowFile:(NSString *)selfShadowFileName{
    
    self=[super init];
    if (self) {
        if (selfFileName!=nil) {
            self.selfFileName=selfFileName;
        }
        if (selfShadowFileName!=nil) {
            self.selfShadowFileName=selfShadowFileName;
        }
    }
    return self;
}
-(instancetype)initWithMask:(NSString*) selfFileName maskFile:(NSString*) selfMaskFileName{
    self=[super init];
    if (self) {
        if (selfFileName!=nil) {
            self.selfFileName=selfFileName;
        }
        if (selfMaskFileName!=nil) {
            self.selfMaskFileName=selfMaskFileName;
        }
    }
    return self;
}

//超类，无需super传递
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.selfFileName forKey:@"selfFileName"];
    [aCoder encodeObject:self.selfShadowFileName forKey:@"selfShadowFileName"];
    [aCoder encodeObject:self.selfPairFileName forKey:@"selfPairFileName"];
    [aCoder encodeObject:self.selfMaskFileName forKey:@"selfMaskFileName"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        self.selfFileName=[aDecoder decodeObjectForKey:@"selfFileName"];
        self.selfShadowFileName=[aDecoder decodeObjectForKey:@"selfShadowFileName"];
        self.selfPairFileName=[aDecoder decodeObjectForKey:@"selfPairFileName"];
        self.selfMaskFileName=[aDecoder decodeObjectForKey:@"selfMaskFileName"];
    }
    return self;
}


-(BOOL)isEqual:(id)object{
    if ((![object isKindOfClass:[BaseEntity class]])||[self class]!=[object class]) {
        return NO;
    }

    else  if ([object isKindOfClass:[DoubleEyeEntity class]]) {
        DoubleEyeEntity* selfEntity=(DoubleEyeEntity*)self;
        DoubleEyeEntity* otherEntity=(DoubleEyeEntity*)object;

        if ([selfEntity.selfBigFile isEqualToString:otherEntity.selfBigFile]) {
            return YES;
        }
        return NO;
    }
    else{
        BaseEntity* otherEntity=(BaseEntity*)object;
        if ([self.selfFileName isEqualToString:otherEntity.selfFileName]) {
            return YES;
        }
        return NO;
    }
}
@end
