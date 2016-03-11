//
//  SubmitButton.m
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "SubmitButton.h"

@implementation SubmitButton
-(void)drawRect:(CGRect)rect{
    self.layer.cornerRadius=40.0f;
    self.clipsToBounds=YES;
}
@end
