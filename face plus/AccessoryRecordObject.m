//
//  AccessoryRecordObject.m
//  face plus
//
//  Created by linxudong on 15/1/28.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "AccessoryRecordObject.h"


@implementation AccessoryRecordObject
-(instancetype)initWithNodeAndImageFile:(SKNode*)node currentEntity:(BaseEntity*)currentEntity{
if(self=[super init]){
        self.node=node;
        self.currentEntity=currentEntity;
    }
    return self;
}



-(void)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.node forKey:@"node"];
    [encoder encodeObject:self.currentEntity forKey:@"currentEntity"];
}


- (instancetype)initWithCoder:(NSCoder *)decoder {
    self=[super init];
    self.node = [decoder decodeObjectForKey:@"node"];
    self.currentEntity = [decoder decodeObjectForKey:@"currentEntity"];
    return self;

}
@end