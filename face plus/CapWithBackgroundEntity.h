//
//  CapWithBackgroundEntity.h
//  face plus
//
//  Created by linxudong on 1/10/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "BaseEntity.h"

@interface CapWithBackgroundEntity : BaseEntity
@property NSString* backgroundFileName;
-(instancetype)initWithBackgroundFile:(NSString*)selfFile shadowFile:(NSString*)shadowFile backgroundFile:(NSString*)backgroundFile;
@end
