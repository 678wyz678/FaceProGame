//
//  PackageIndexArray.h
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageIndexArray : NSObject
//存储的都是图片路径
@property NSMutableArray* zombieIndexFiles;
@property NSMutableArray* futureIndexFiles;

@property NSMutableArray* animalIndexFiles;
@property NSMutableArray* rockIndexFiles;
@property NSMutableArray* bodyIndexFiles;

+(instancetype)singleton;
@end
