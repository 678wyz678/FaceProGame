//
//  SmartSelectionDelegate.h
//  face plus
//
//  Created by linxudong on 12/28/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewController,SKNode,SelectTempNodeObject;
@interface SmartSelectionDelegate : NSObject
@property NSMutableArray* curSelectionArray;
@property(nonatomic) SelectTempNodeObject* currentObject;
@property (weak)ViewController* controller;


-(void)select:(NSArray*)array;
@end
