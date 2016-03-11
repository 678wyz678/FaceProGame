//
//  PresentMiddleObject.h
//  face plus
//
//  Created by linxudong on 15/2/13.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PresentMiddleObject : NSObject
+(instancetype)singleton;
@property (assign,nonatomic)BOOL needPresent;
@end
