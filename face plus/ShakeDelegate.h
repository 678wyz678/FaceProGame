//
//  ShakeDelegate.h
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface ShakeDelegate : NSObject
@property (assign,nonatomic)BOOL isEnbledForShaking;

@property(weak,nonatomic)ViewController* controller;
-(void)shake;
-(instancetype)initWithController:(ViewController*)controller;
@end
