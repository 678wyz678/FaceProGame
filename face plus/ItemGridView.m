//
//  ItemGridView.m
//  face plus
//
//  Created by linxudong on 1/22/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ItemGridView.h"
#import "ItemGridDataSourceDelegate.h"
#import "ItemGridDelegate.h"
#import "PackageIndexArray.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ItemGridView
{
    ItemGridDataSourceDelegate* _itemGridDataSourceDelegate;
    ItemGridDelegate* _itemGridDelegate;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        _itemGridDelegate=[[ItemGridDelegate alloc]init];
        self.delegate=_itemGridDelegate;
        _itemGridDataSourceDelegate=[[ItemGridDataSourceDelegate alloc]init];
        self.dataSource=_itemGridDataSourceDelegate;
            
        self.backgroundColor=[UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.1];
        //重新更换数据源的监听器
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchShopItem:) name:@"SWITCH_SHOP_ITEM" object:nil];
        [self fadeIn];
    }
    return  self;
}

-(void)fadeIn{
    self.alpha=0.f;
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha=1.0;
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


///切换商店素材
-(void)switchShopItem:(NSNotification*)sender{
    NSUInteger index=((NSNumber*)[[sender userInfo] objectForKey:@"SHOP_ITEM_INDEX"]).unsignedIntegerValue;
    
    int color=0;
   
    switch (index) {
        case 0:
            color=0xfdcd2f;
           _itemGridDataSourceDelegate.data=[PackageIndexArray singleton].animalIndexFiles;
            break;
        case 1:
            color=0xfd9526;
            _itemGridDataSourceDelegate.data=[PackageIndexArray singleton].rockIndexFiles;
            break;
        case 2:
            color=0xd02752;
            _itemGridDataSourceDelegate.data=[PackageIndexArray singleton].zombieIndexFiles;
            break;
        case 3:
            color=0x60e5c6;
            _itemGridDataSourceDelegate.data=[PackageIndexArray singleton].futureIndexFiles;
            break;
        case 4:
            color=0xe0f808;
            _itemGridDataSourceDelegate.data=[PackageIndexArray singleton].bodyIndexFiles;

            break;
        default:
            return;
            break;
    }
    UIColor*tempColor=UIColorFromRGB(color);
    CGFloat red=0.f,green=0.f,blue=0.f,alpha=0.f;
    [tempColor getRed:&red green:&green blue:&blue alpha:&alpha];
    _itemGridDataSourceDelegate.cellColor=[UIColor colorWithRed:red green:green blue:blue alpha:0.4] ;
    [self reloadData];
}

-(void)reloadData{
    [super reloadData];
    [self fadeIn];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
