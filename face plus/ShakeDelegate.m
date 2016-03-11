//
//  ShakeDelegate.m
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ShakeDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>
#import "IconButton.h"
#import "ShakeOption.h"
#import "MyScene.h"
@implementation ShakeDelegate
-(instancetype)initWithController:(ViewController*)controller{
    if (self=[super init]) {
        _isEnbledForShaking=false;
        self.controller=controller;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startShakeMode) name:@"RESET_ICONBUTTON" object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(endShakeMode) name:@"QUIT_SHAKE" object:nil];
    }
    return self;
}

//开启摇一摇（震动一次）
-(void)startShakeMode{
    _isEnbledForShaking=true;
    [_controller.skScene setCaptureMask];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void)endShakeMode{
    [_controller.skScene setCaptureMask];
    _isEnbledForShaking=false;
}

-(void)shake{
    
    if (self.isEnbledForShaking){
        
    //&&[[ShakeOption singleton] readyForNextShake]) {
//        [[ShakeOption singleton] setReadyForNextShake:NO];
//        int numOfSelected=0;
//        
//        UIView*iconWrapper=[self.controller iconScrollViewContent];
//        
//        for (UIView*icon in iconWrapper.subviews) {
//            if ([icon isKindOfClass:[IconButton class]]) {
//                IconButton* iconButton=(IconButton*)icon;
//                if (iconButton.isSelected) {
//                    numOfSelected++;
//                }
//            }
//        }
//        
//        [[ShakeOption singleton] setNumOfSelectedIcons:numOfSelected];
//        
//        
        [self randomChangeTexture];
    }
}



-(void)randomChangeTexture{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RANDOM_TEXTURE" object:self];
    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"shake", @"SOUND_KEY",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_SOUND" object:self userInfo:dict];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end

