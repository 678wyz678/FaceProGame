//
//  SKViewScaleSlider.m
//  face plus
//
//  Created by linxudong on 1/17/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "SKViewScaleSlider.h"

@implementation SKViewScaleSlider
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        UIImage *minImage = [[UIImage imageNamed:@"slider_minimum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
        UIImage *maxImage = [[UIImage imageNamed:@"slider_maximum.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
        UIImage *thumbImage = [UIImage imageNamed:@"sliderHandle"];
        
        [[UISlider appearance] setMaximumTrackImage:maxImage forState:UIControlStateNormal];
        [[UISlider appearance] setMinimumTrackImage:minImage forState:UIControlStateNormal];
        [[UISlider appearance] setThumbImage:thumbImage forState:UIControlStateNormal];
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
