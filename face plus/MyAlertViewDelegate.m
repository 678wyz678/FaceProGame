//
//  MyAlertViewDelegate.m
//  face plus
//
//  Created by linxudong on 1/19/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "MyAlertViewDelegate.h"
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "MyAlertView.h"
#import "AlertViewWrapper.h"
#import "BlurAlertViewWrapper.h"

@implementation MyAlertViewDelegate
-(instancetype)initWithController:(ViewController*)controller{
    if (self=[super init]) {
        _controller=controller;
        [self initView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveOperationYesOrNo:) name:@"ALERT_RESULT" object:nil];
    }
    return self;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)initView{
    UIView* alertView;
    UIView*superView=  _controller.view;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        
        
        alertView=[[UIView alloc]init];
        alertView.translatesAutoresizingMaskIntoConstraints=NO;
        alertView.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.78];
        
        [superView addSubview:alertView];
        _contentView=alertView;

    }
    else{
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];

        alertView=[[BlurAlertViewWrapper alloc]initWithEffect:blurEffect];
        alertView.translatesAutoresizingMaskIntoConstraints=NO;
        [superView addSubview:alertView];
        _contentView=((UIVisualEffectView*)alertView);
    }
    alertView.layer.cornerRadius=5.0f;
    alertView.clipsToBounds=YES;
    alertView.layer.borderColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3].CGColor;
    alertView.layer.borderWidth=2.0f;
    alertView.hidden=YES;
    
    NSLayoutConstraint* width2SuperViewRatio=[NSLayoutConstraint constraintWithItem:alertView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeWidth multiplier:0.618 constant:0];
    NSLayoutConstraint* horizontalCenter=[NSLayoutConstraint constraintWithItem:alertView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint* verticalCenter=[NSLayoutConstraint constraintWithItem:alertView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint*heightWidthRatioConstraint=[NSLayoutConstraint constraintWithItem:alertView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:alertView attribute:NSLayoutAttributeWidth multiplier:0.382 constant:0];
    [superView addConstraints:@[width2SuperViewRatio,horizontalCenter,heightWidthRatioConstraint,verticalCenter]];
    [self loadSubView];
}

-(void)loadSubView{
    MyAlertView* alertView=[[MyAlertView alloc]init];
    [_contentView addSubview:alertView];
    NSDictionary*dict=NSDictionaryOfVariableBindings(alertView);
    NSArray*hConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"|[alertView]|" options:0 metrics:nil views:dict];
    NSArray*vConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[alertView]|" options:0 metrics:nil views:dict];
    _contentView.translatesAutoresizingMaskIntoConstraints=NO;
    [_contentView addConstraints:hConstraints];
    [_contentView addConstraints:vConstraints];
}

-(void)appearWithBlock:(MyCustomBlockType)block{
    self.executeBlock=block;
    if (_contentView.hidden) {
        _contentView.hidden=NO;
    }
}

-(void)resetBlock{
    self.executeBlock=^(void) {
    };
}

-(void)submitOperation{
    //self.executeBlock();
    if (self.executeBlock) {
        self.executeBlock();
    }    _contentView.hidden=YES;
    [self resetBlock];
}

-(void)cancelOperation{
    _contentView.hidden=YES;
    [self resetBlock];
}

-(void)receiveOperationYesOrNo:(NSNotification*)sender{
    BOOL isYes=((NSNumber*)[sender.userInfo objectForKey:@"isYes"]).boolValue;
    if (isYes) {
        [self submitOperation];
    }
    else{
        [self cancelOperation];
    }
}

@end
