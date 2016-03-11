//
//  MyAlertViewDelegate.h
//  face plus
//
//  Created by linxudong on 1/19/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//
typedef void(^MyCustomBlockType)(void);
#import <Foundation/Foundation.h>

@class UIView,ViewController;
@interface MyAlertViewDelegate : NSObject
@property (weak,nonatomic)ViewController*controller;
@property (weak)UIView* contentView;

@property (nonatomic,copy)MyCustomBlockType executeBlock;
-(instancetype)initWithController:(ViewController*)controller;
-(void)appearWithBlock:(MyCustomBlockType)block;
@end
