//
//  AccessoryRecordObject.h
//  face plus
//
//  Created by linxudong on 15/1/28.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "BaseEntity.h"
@interface AccessoryRecordObject : NSObject
@property (weak,nonatomic)SKNode* node;
@property (weak,nonatomic)BaseEntity* currentEntity;
-(instancetype)initWithNodeAndImageFile:(SKNode*)node currentEntity:(BaseEntity*)currentEntity;

@end
