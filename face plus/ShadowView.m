//
//  ShadowView.m
//  face plus
//
//  Created by linxudong on 15/1/29.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "ShadowView.h"

@implementation ShadowView

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        NSString*shadowName=@"shadow";

        self.layer.contents=(id)[[UIImage imageNamed:shadowName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)].CGImage;

    }
    return self;
}

-(void)setIsDown:(BOOL)isDown{
    _isDown=isDown;
    NSString*shadowName=@"shadow";

    if (isDown) {
               shadowName=@"shadowIsDown";
    }
    self.layer.contents=(id)[[UIImage imageNamed:shadowName] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 1, 0, 0)].CGImage;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
