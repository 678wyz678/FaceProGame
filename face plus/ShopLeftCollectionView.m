//
//  ShopLeftCollectionView.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "ShopLeftCollectionView.h"
#import "ShopLeftCollectionViewDelegate.h"
#import "ShopLeftCollectionViewSource.h"
@implementation ShopLeftCollectionView
{
    ShopLeftCollectionViewDelegate* _shopLeftCollectionViewDelegate;
    ShopLeftCollectionViewSource* _shopLeftCollectionViewSource;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        _shopLeftCollectionViewDelegate=[[ShopLeftCollectionViewDelegate alloc]init];
        self.delegate=_shopLeftCollectionViewDelegate;
        _shopLeftCollectionViewSource=[[ShopLeftCollectionViewSource alloc]init];
        self.dataSource=_shopLeftCollectionViewSource;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToBottom) name:@
         "SHOP_LEFT_SCROLL" object:nil];
    }
    return  self;
}
-(void)scrollToBottom{
    [self selectItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc{
    NSLog(@"shop dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
