//
//  SwitchImageButton.m
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "SwitchImageButton.h"

@implementation SwitchImageButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self addTarget:self action:@selector(selectImage) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)selectImage{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SELECT_NEW_IMAGE" object:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
