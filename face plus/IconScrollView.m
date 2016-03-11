//
//  IconScrollView.m
//  face plus
//
//  Created by linxudong on 12/29/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "IconScrollView.h"
#import "IconScrollViewDelegate.h"
#import "IconButton.h"
@implementation IconScrollView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.delegate=_myDelegate=[[IconScrollViewDelegate alloc]init];
        self.subViewArray=[NSMutableArray new];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleShakeMode) name:@"TOGGLE_SHAKE_MODE" object:nil];
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitShakeMode) name:@"QUIT_SHAKE_MODE" object:nil];
        self.decelerationRate=UIScrollViewDecelerationRateFast;
    }
    
    
    return self;
}


-(void)quitShakeMode{
    //self.hidden=NO;
    self.inModeOfShake=false;
    
//    NSNumber* POSITION=[NSNumber numberWithInteger:(0)];
//    NSDictionary* dict=NSDictionaryOfVariableBindings(POSITION);
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_LOCATION_OF_SCROLLVIEW" object:self userInfo:dict];
//    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QUIT_SHAKE" object:self];
}

-(void)toggleShakeMode{
    self.inModeOfShake=!self.inModeOfShake;
    //self.hidden=NO;
    if (self.inModeOfShake) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RESET_ICONBUTTON" object:self];
        
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QUIT_SHAKE" object:self];
    }
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
