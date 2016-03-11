//
//  MyAlertView.m
//  face plus
//
//  Created by linxudong on 1/19/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "MyAlertView.h"
#import "AlertNoButton.h"
#import "AlertYesButton.h"
@interface MyAlertView()
@property (weak)UILabel* infoLabel;
@end

@implementation MyAlertView
-(instancetype)init{
    if (self=[super init]) {
        self.translatesAutoresizingMaskIntoConstraints=NO;
        self.backgroundColor=[UIColor clearColor];
        [self initInfoLabel];
        [self initButton];
    }
    return self;
}


-(void)initInfoLabel{
//init info Label
    UILabel* tempInfoLabel=[[UILabel alloc]init];
    tempInfoLabel.translatesAutoresizingMaskIntoConstraints=NO;
    tempInfoLabel.text=@"Save to photo library.";
    tempInfoLabel.textColor=[UIColor whiteColor];
    tempInfoLabel.textAlignment=NSTextAlignmentCenter;
    [self addSubview:tempInfoLabel];
    _infoLabel=tempInfoLabel;
    NSDictionary*dict=NSDictionaryOfVariableBindings(tempInfoLabel);
    NSLayoutConstraint*heightConstraint= [NSLayoutConstraint constraintWithItem:tempInfoLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1/3.0f constant:0];
    NSArray* topAlign=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tempInfoLabel]" options:0 metrics:nil views:dict];
    NSLayoutConstraint* centerX=[NSLayoutConstraint constraintWithItem:tempInfoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [self addConstraint:heightConstraint];
    [self addConstraint:centerX];
    [self addConstraints:topAlign];

}

-(void)initButton{
    UIView*infoLabel=_infoLabel;
    //init info Label
    UIView* buttonWrapper=[[UIView alloc]init];
    buttonWrapper.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:buttonWrapper];
    NSDictionary*dict=NSDictionaryOfVariableBindings(buttonWrapper,infoLabel);
    NSLayoutConstraint*heightConstraint= [NSLayoutConstraint constraintWithItem:buttonWrapper attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1/3.0f constant:0];
    NSArray* topAlign=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[infoLabel]-0-[buttonWrapper]" options:0 metrics:nil views:dict];
    NSLayoutConstraint*widthConstriant=[NSLayoutConstraint constraintWithItem:buttonWrapper attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    NSLayoutConstraint*leftConstriant=[NSLayoutConstraint constraintWithItem:buttonWrapper attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    [self addConstraints:@[heightConstraint,widthConstriant,leftConstriant]];
    [self addConstraints:topAlign];
    
    
    
    AlertNoButton *buttonCancel=[[AlertNoButton alloc]init];
    [buttonCancel setTitle:@"No" forState:UIControlStateNormal];
    buttonCancel.translatesAutoresizingMaskIntoConstraints=NO;
    [buttonWrapper addSubview:buttonCancel];
    NSLayoutConstraint* hConstraint=[NSLayoutConstraint constraintWithItem:buttonCancel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0];
    NSLayoutConstraint* vConstraint=[NSLayoutConstraint constraintWithItem:buttonCancel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
    NSLayoutConstraint* leftConstraint=[NSLayoutConstraint constraintWithItem:buttonCancel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeLeading multiplier:1.0f constant:0];
    NSLayoutConstraint* topConstraint=[NSLayoutConstraint constraintWithItem:buttonCancel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    [buttonWrapper addConstraints:@[hConstraint,vConstraint,leftConstraint,topConstraint]];
    
    AlertYesButton *buttonSubmit=[[AlertYesButton alloc]init];
    [buttonSubmit setTitle:@"Yes" forState:UIControlStateNormal];
    buttonSubmit.translatesAutoresizingMaskIntoConstraints=NO;
    [buttonWrapper addSubview:buttonSubmit];
     hConstraint=[NSLayoutConstraint constraintWithItem:buttonSubmit attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeWidth multiplier:0.5f constant:0];
     vConstraint=[NSLayoutConstraint constraintWithItem:buttonSubmit attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeHeight multiplier:1.0f constant:0];
     leftConstraint=[NSLayoutConstraint constraintWithItem:buttonSubmit attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:0];
     topConstraint=[NSLayoutConstraint constraintWithItem:buttonSubmit attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:buttonWrapper attribute:NSLayoutAttributeTop multiplier:1.0f constant:0];
    [buttonWrapper addConstraints:@[hConstraint,vConstraint,leftConstraint,topConstraint]];
    
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
