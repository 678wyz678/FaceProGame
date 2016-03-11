//
//  IconButton.m
//  face plus
//
//  Created by linxudong on 12/29/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "IconButton.h"
#import "IconScrollView.h"

#import "UIView+Glow.h"
@interface IconButton(){}
@property (nonatomic,assign)BOOL notFirstLoad;
@end

@implementation IconButton

-(instancetype)init{
    if (self=[super init]) {
        self.layer.cornerRadius=11.0f;
        
        [self addTarget:self action:@selector(launchNotificationForScrollView) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)quitShakeMode{
    if (self.index==16) {
        [self setImage:[UIImage imageNamed:@"icon_font"] forState:UIControlStateNormal];
        NSDictionary* dict=[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:@"random_color"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RandomColorWithBroadcast" object:self userInfo:dict];
            //[self setImage:[UIImage imageNamed:@"icon_background"] forState:UIControlStateNormal];
        
    }

    if (self.index==17) {
        [self setHidden:NO];
    }
    //_selectState=self.isSelected;
    //self.isSelected=false;
    
    
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(launchNotificationForScrollViewForShakePopUp) forControlEvents:UIControlEventTouchUpInside];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetState) name:@"RESET_ICONBUTTON" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitShakeMode) name:@"QUIT_SHAKE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(random) name:@"RANDOM_TEXTURE" object:nil];

    }
    return self;
}
-(void)launchNotificationForScrollViewForShakePopUp{
    self.isSelected=!self.isSelected;

}

-(void)launchNotificationForScrollView{
    
    IconScrollView * scrollView=(IconScrollView*)[[self superview] superview];
    BOOL inMode = scrollView.inModeOfShake;
    
    if (!inMode) {
        NSNumber* POSITION=[NSNumber numberWithInteger:self.index];
        NSDictionary* dict=NSDictionaryOfVariableBindings(POSITION);

        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_LOCATION_OF_SCROLLVIEW" object:self userInfo:dict];
    }
    else{
    //    self.isSelected=!self.isSelected;
    }
   
}


-(void)setIndexT:(NSNumber *)indexT{
    _indexT=indexT;
    _index=indexT.integerValue;
    
    if (self.index==16) {
        [self setImage:[UIImage imageNamed:@"color_button_for_shake"] forState:UIControlStateNormal];
    }
    
    if (self.index==17) {
        [self setHidden:YES];
    }
    if(self.index==0||self.index==1||self.index==4||self.index==5||self.index==7||self.index==8||self.index==11||self.index==15||self.index==16)
    {
        self.selectState=YES;
        self.isSelected=YES;
    }

}

-(void)resetState{
    if (self.index==16) {
        [self setImage:[UIImage imageNamed:@"color_button_for_shake"] forState:UIControlStateNormal];
    }
    //self.isSelected=_selectState;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if (!self.notFirstLoad) {
        self.notFirstLoad=YES;
        CGSize size=[self frame].size;
        self.layer.cornerRadius=size.width/2.f;
    }

 

}

-(void)setIsSelected:(BOOL)isSelected{
    if (self.index==17) {
        return;
    }
    

    
    if (isSelected) {
        CGSize size=[self frame].size;
        self.layer.cornerRadius=size.width/2.f;
        self.layer.borderColor=[UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0x00/255.0 alpha:1] .CGColor;
        self.layer.borderWidth=2.0f;
        _isSelected=YES;
        
        [UIView animateWithDuration:2 animations:^{
            self.layer.borderColor=[UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0x00/255.0 alpha:1] .CGColor;
        }];
        
        
//        
//        CABasicAnimation *color = [CABasicAnimation animationWithKeyPath:@"borderColor"];
//        // animate from red to blue border ...
//        color.fromValue = (id)[UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0x00/255.0 alpha:1].CGColor;
//        color.toValue   = (id)[UIColor whiteColor].CGColor;
//        // ... and change the model value
//        color.repeatCount=HUGE_VALF;
//        color.autoreverses=YES;
//        color.duration=1.0;
//        
//        [self.layer addAnimation:color forKey:@"color"];

//        [self startGlowingWithColor:[UIColor colorWithRed:0xff/255.0 green:0xcc/255.0 blue:0x00/255.0 alpha:1] intensity:1];
        
        
    }
    else{

        self.layer.borderColor=[UIColor clearColor].CGColor;
        self.layer.borderWidth=0.f;
        _isSelected=NO;
        [self.layer removeAllAnimations];
      //  [self stopGlowing];

    }
    
}


-(void)random{
    if (_isSelected) {
        NSNumber*index=[NSNumber numberWithUnsignedInteger:self.index];
        NSDictionary*dict=NSDictionaryOfVariableBindings(index);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RandomBroadcast" object:self userInfo:dict];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
