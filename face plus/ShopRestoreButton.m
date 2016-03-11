//
//  ShopRestoreButton.m
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "ShopRestoreButton.h"

@implementation ShopRestoreButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {


       self.titleLabel.font = [UIFont fontWithName:@"Caviar Dreams" size:16];
        self.layer.cornerRadius=4.f;
        self.layer.borderWidth=1.f;
        self.layer.borderColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4].CGColor;
    }
    return self;
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
       // [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    else{
        self.backgroundColor=[UIColor clearColor];
        //[self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
