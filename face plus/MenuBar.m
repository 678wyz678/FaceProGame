//
//  MenuBar.m
//  face plus
//
//  Created by linxudong on 1/5/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "MenuBar.h"

@implementation MenuBar
-(instancetype)initWithCoder:(NSCoder *)aDecoderP{
    if (self=[super initWithCoder:aDecoderP]) {
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleShakeMode) name:@"RESET_ICONBUTTON" object:nil];
         //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(quitShakeMode) name:@"QUIT_SHAKE" object:nil];
    }
    
    return self;
}

-(void)toggleShakeMode{
    self.hidden=YES;
}
-(void)quitShakeMode{
    
    self.hidden=YES;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
