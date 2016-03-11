//
//  ShopLeftCollectionViewDelegate.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "ShopLeftCollectionViewDelegate.h"

@implementation ShopLeftCollectionViewDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width=[[UIScreen mainScreen]bounds].size.width;
   
    
        return CGSizeMake(width,width/2.0);

}


-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{

    //[[collectionView cellForItemAtIndexPath:indexPath] setHighlighted:YES];
    

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary*dict=[NSDictionary dictionaryWithObject:[NSNumber numberWithUnsignedInteger:indexPath.row] forKey:@"SHOP_ITEM_INDEX"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SWITCH_SHOP_ITEM" object:self userInfo:dict];
}

@end
