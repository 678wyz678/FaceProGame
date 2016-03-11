//
//  ShakeModeDelegate.m
//  face plus
//
//  Created by linxudong on 14/12/2.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ShakeModeDelegate.h"
#import "ViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "BottomPagerController.h"
#import "ViewControllerSource.h"
#import "OperationStack.h"
@implementation ShakeModeDelegate

@synthesize isInMode=_isInMode;
-(instancetype)init{
    self=[super init];
    if (self) {
        _indexForRandom=[[NSMutableSet alloc]init];
        _isInMode=false;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationOfShakeSelection:) name:@"cjx" object:nil];
    }
    return self;
}
-(void)shakeTheDevice{
    //如果没有摇一摇模式就进入摇一摇mode
    if (!_isInMode) {
       
    }
    //如果已经在摇一摇模式了直接make a random
    else{
        [self makeARandom];
    }
}


-(void)toggleMode{
    //如果没有摇一摇模式就进入摇一摇mode
    if (!_isInMode) {
        [self startMode];
    }
    //否则退出摇一摇
    else{
        [self stopMode];
        
    }
}

-(void)startMode{
    //iconScrollView可交互并且可滑动
    
//    _controller.iconScrollView.userInteractionEnabled=YES;
//    _controller.iconScrollView.scrollEnabled=YES;
    
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//     NSArray* array=@[[_controller.pageViewController.source viewControllerAtIndex:200 storyboard:[_controller storyboard]]];
//    [_controller.pageViewController switchPageController:array];
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"lightOn" object:self];
    
    _isInMode=true;
}
-(void)stopMode{
            //_controller.iconScrollView.userInteractionEnabled=NO;
            //_controller.iconScrollView.scrollEnabled=NO;
 
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"lightOn" object:self];
//            _isInMode=false;
}

-(void) receiveNotificationOfShakeSelection:(NSNotification *) notification{
    NSNumber* index= [notification.userInfo objectForKey:@"index"];
    NSNumber* isSelected= [notification.userInfo objectForKey:@"isSelected"];
    
    if ([isSelected boolValue]>0) {
        
        [self.indexForRandom addObject:index];
    }
    else{
        
        [self.indexForRandom removeObject:index];
    }
}
-(void)makeARandom{

 ViewControllerSource* source = [_controller.pageViewController dataSource];
    [_indexForRandom enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSArray* array=[source.pageData objectForKey:obj];//取出对应素材类型的所有素材的数组
        NSUInteger randomIndex = arc4random() % [array count];
        [_controller.operationStackDelegate newOperation:[array objectAtIndex:randomIndex]];
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
