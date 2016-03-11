//
//  ShakeOption.h
//  face plus
//
//  Created by linxudong on 2/27/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShakeOption : NSObject
@property (nonatomic,assign)NSInteger numOfSelectedIcons;
@property (nonatomic,assign)BOOL readyForNextShake;

+(instancetype)singleton;
@end

