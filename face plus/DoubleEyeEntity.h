//
//  DoubleEyeEntity.h
//  face plus
//
//  Created by linxudong on 12/23/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "BaseEntity.h"

@interface DoubleEyeEntity : BaseEntity
@property NSString* pairBigFile;
@property NSString* pairSmallFile;
@property NSString*  selfBigFile;
@property NSString* selfSmallFile;

-(instancetype)initWithSelf:(NSString*)selfFile selfBigFile:(NSString*)selfBigFile pairSmallFile:(NSString*)pairSmallFile  pairBigFile:(NSString*)pairBigFile;
@end
