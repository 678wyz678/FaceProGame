//
//  OperationStack.h
//  face plus
//
//  Created by linxudong on 14/11/27.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseEntity,ViewController;
@interface OperationStack : NSObject
@property NSMutableArray* previousStack;
@property NSMutableArray* nextStack;
@property (weak)ViewController* controller;
@property (nonatomic,assign)BOOL randomColor;

-(void)newOperation:(BaseEntity*)entity;
//-(void)backwardOperation;
//-(void)forwardOperation;
-(void)changeTexture:(BaseEntity*)entity;

//
-(void)removeNode:(BaseEntity*)entity;
@end
