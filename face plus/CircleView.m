//
//  CircleView.m
//  face plus
//
//  Created by linxudong on 12/29/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.backgroundColor=[UIColor clearColor];
        self.layer.contents=(id)[UIImage imageNamed:@"iconScrollCircle"].CGImage;
    }
    return  self;
}



@end
