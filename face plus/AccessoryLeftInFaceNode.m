//
//  AccessoryLeftInFaceNode.m
//  face plus
//
//  Created by linxudong on 15/1/28.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "AccessoryLeftInFaceNode.h"
#import "AccessoryRecordObject.h"
@implementation AccessoryLeftInFaceNode
-(instancetype) initWithImageNamed:(NSString *)name{
 
    
    self=[super initWithImageNamed:name];
    
    if (self!=nil) {
        self.name= accessoryLeftInFaceLayerName  ;
        self.tag=@"左附件（脸内）";
        self.zPosition=89;

    }
    return self;
}

-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfFileName];
    if (self) {
        AccessoryRecordObject*object=[[AccessoryRecordObject alloc]initWithNodeAndImageFile:self currentEntity:entity];
        NSDictionary*dict=[NSDictionary dictionaryWithObject:object forKey:@"RECORD_OBJECT"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_RECORDS_OF_ACCESSORY" object:self userInfo:dict];
        self.currentEntity=entity;

    }
    return self;
}
@end
