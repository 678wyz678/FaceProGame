//
//  DownToUpFocusDelegateProtocol.h
//  face plus
//
//  Created by linxudong on 14/11/7.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseEntity;
@protocol DownToUpFocusDelegateProtocol <NSObject>

-(void)updateFocus:(BaseEntity*) entity;
-(UIImage*)captureSKView;
-(void)changeColor:(UIColor*)color;
@end
