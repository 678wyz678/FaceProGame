//
//  AccessoryRightInFaceNode.m
//  face plus
//
//  Created by linxudong on 15/1/28.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "AccessoryRightInFaceNode.h"

@implementation AccessoryRightInFaceNode
-(instancetype) initWithImageNamed:(NSString *)name{
   
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.name= accessoryRightInFaceLayerName  ;

        self.tag=@"右附件（脸内）";
        self.zPosition=89;

    }
    return self;
}
-(instancetype)initWithEntity:(BaseEntity *)entity{
    self=[self initWithImageNamed:entity.selfPairFileName];
    self.currentEntity=entity;

    return self;
}
@end
