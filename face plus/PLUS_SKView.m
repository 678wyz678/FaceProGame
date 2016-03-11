//
//  PLUS_SKView.m
//  face plus
//
//  Created by linxudong on 14/10/31.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "PLUS_SKView.h"

@implementation PLUS_SKView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        
        if (floor(NSFoundationVersionNumber) >= NSFoundationVersionNumber_iOS_7_1) {
            self.allowsTransparency=YES;
        }
        self.frameInterval=12.0;
        //self.showsFPS=YES;
    }
    return self;
}

-(void)setFastFrameRate{
    self.frameInterval=2.0;
}
-(void)setSlowFrameRate{
    self.frameInterval=12.0;
}
@end
