//
//  TransparentView.m
//  face plus
//
//  Created by linxudong on 12/30/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "TransparentView.h"

@implementation TransparentView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.backgroundColor=[UIColor  colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
