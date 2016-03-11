//
//  ShakeModeDelegate.h
//  face plus
//
//  Created by linxudong on 14/12/2.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShakeModeDelegateProtocol.h"
@class ViewController ;
@interface ShakeModeDelegate : NSObject<ShakeModeDelegateProtocol>
@property (weak)ViewController* controller;
@property NSMutableSet* indexForRandom;

-(void)makeARandom;
@end
