//
//  BackgroundViewCell.m
//  face plus
//
//  Created by linxudong on 15/2/10.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "BackgroundViewCell.h"

@implementation BackgroundViewCell
-(void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.layer.borderWidth=2.f;
        self.layer.borderColor=[UIColor whiteColor].CGColor;
    }
    else{
        self.layer.borderWidth=0.f;
        self.layer.borderColor=[UIColor clearColor].CGColor;
    }
}
@end
