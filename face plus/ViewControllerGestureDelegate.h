//
//  ViewControllerGestureDelegate.h
//  face plus
//
//  Created by linxudong on 1/14/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class ViewController;
@interface ViewControllerGestureDelegate : NSObject<UIGestureRecognizerDelegate>
@property(weak,nonatomic)ViewController* controller;

-(instancetype)initWithController:(ViewController*)controller;


- (void)panHandler:(UIPanGestureRecognizer *)sender ;
- (void)tapHandler:(UITapGestureRecognizer*)sender ;
- (void)SyncDragEyeAndBrow:(UIPanGestureRecognizer *)sender ;
- (void)rotate:(UIRotationGestureRecognizer *)sender ;
- (void)zoomHandler:(UIPinchGestureRecognizer*)sender ;
@end
