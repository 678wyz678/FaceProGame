//
//  MyNaviGationView.m
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "MyNaviGationView.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "UIImage+Color.h"
@implementation MyNaviGationView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {

        self.translatesAutoresizingMaskIntoConstraints=NO;
        self.backgroundColor=[UIColor colorWithRed:0xdf/255.f green:0xe6/255.f blue:0xf4/255.f alpha:1];
        [self addBackBtn];
    }
    return self;
}
-(void)setBackImageFile:(NSString *)backImageFile{
    UIButton*button=(UIButton*)[self viewWithTag:9834];
    [button setImage:[UIImage imageNamed:backImageFile] forState:UIControlStateNormal];
}

-(void)setBackground:(NSNumber*)background{
    _background=background;
    self.backgroundColor=UIColorFromRGB(background.integerValue);
    self.alpha=0.3;
    UIButton*button=(UIButton*)[self viewWithTag:9834];
    if (button) {
        [button setImage:[[UIImage imageNamed:@"backBTN"] imageWithTint:[UIColor whiteColor]] forState:UIControlStateNormal];
    }

}
-(void)addBackBtn{
    CGSize size=[self frame].size;
    NSNumber* width=[NSNumber numberWithFloat:size.height*0.88];
    NSDictionary*num=NSDictionaryOfVariableBindings(width);
    
    UIButton *backBtn=[[UIButton alloc]init];
    backBtn.tag=9834;
    [backBtn addTarget:self action:@selector(globalNavigationControllerPop) forControlEvents:UIControlEventTouchUpInside];
    backBtn.translatesAutoresizingMaskIntoConstraints=NO;
    [backBtn setImage:[UIImage imageNamed:@"backBTN"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    NSDictionary*dict=NSDictionaryOfVariableBindings(backBtn);
    NSArray* hConstaints=[NSLayoutConstraint constraintsWithVisualFormat:@"|-12-[backBtn(width)]" options:0 metrics:num views:dict];
    NSLayoutConstraint* vConstriant=[NSLayoutConstraint constraintWithItem:backBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSArray* heightConstaints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backBtn(width)]" options:0 metrics:num views:dict];
    [self addConstraint:vConstriant];
    [self addConstraints:hConstaints];
    [backBtn addConstraints:heightConstaints];

}

-(void)globalNavigationControllerPop{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_ONE_CONTROLER" object:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
