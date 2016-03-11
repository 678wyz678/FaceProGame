//
//  ColorButton.m
//  face plus
//
//  Created by linxudong on 12/22/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "ColorButton.h"
#import "UIButton+Extensions.h"
#import "UIImage+Color.h"
@implementation ColorButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setHitTestEdgeInsets:UIEdgeInsetsMake(-20, -20, -20, -20)];
        //self.imageView.layer.cornerRadius = 7.0f;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowColor = [UIColor whiteColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
        self.layer.shadowOpacity = 0.7f;
        self.layer.masksToBounds = NO;
    }
    return self;
}
@end
