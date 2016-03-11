//
//  MyShareDelegate.h
//  face plus
//
//  Created by linxudong on 15/1/26.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface MyShareDelegate : NSObject
@property (weak,nonatomic)ViewController*controller;
- (void) sendWeixinImageContent:(UIImage*)images;
- (void) sendWeixinImageContentInTiemLine:(UIImage*)images;
-(instancetype)initWithController:(ViewController*)controller;
-(void)shareSinaWeibo:(UIImage*)image;
-(void)shareTwitter:(UIImage *)image;
-(void)shareFaceBook:(UIImage *)image;
-(BOOL)addAddition;
@end
