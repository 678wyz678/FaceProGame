//
//  DownToUpDelegate.h
//  face plus
//
//  Created by linxudong on 14/11/7.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DownToUpFocusDelegateProtocol.h"

@class BaseEntity,ViewController;
@interface DownToUpDelegate : NSObject<DownToUpFocusDelegateProtocol>{
@public Byte currentState;
}
-(void)updateFocus:(BaseEntity*)entity setCurrentNode:(BOOL)notSetCurrentNode;
+(instancetype)singleton;
-(void)ListUpAndDown:(UIPanGestureRecognizer*)gestureRecognizer;
-(void)updateIconScrollViewOffset:(NSInteger) index;
//dragbutton的点击处理事件
-(void)dragButtonHandler;
-(UIImage*)captureSKView;
-(void)changeColorForBackgroundGrid:(UIColor*)color;


//指向View Controller的若引用
@property (weak,nonatomic)ViewController* viewController;


@end
