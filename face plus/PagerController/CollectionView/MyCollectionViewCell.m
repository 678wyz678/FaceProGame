//
//  MyCollectionViewCell.m
//  CollectionViewTest
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Ferrum. All rights reserved.
//

#import "MyCollectionViewCell.h"
@implementation MyCollectionViewCell
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
