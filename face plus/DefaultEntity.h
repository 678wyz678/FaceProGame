//
//  DefaultEntity.h
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseEntity.h"
@interface DefaultEntity : NSObject
@property BaseEntity* faceEntity;
@property BaseEntity* mouthEntity;
@property BaseEntity* noseEntity;
@property BaseEntity* earEntity;
@property BaseEntity* eyeEntity;
@property BaseEntity* hairEntity;
@property BaseEntity* neckEntity;
@property BaseEntity* browEntity;
@property BaseEntity*eyeballEntity;
+(instancetype)singleton;
@end
