//
//  ItemGridDelegate.m
//  face plus
//
//  Created by linxudong on 1/22/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ItemGridDelegate.h"

@implementation ItemGridDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    float sortaPixel = 1.0/[UIScreen mainScreen].scale;

    CGFloat width=([[UIScreen mainScreen]bounds].size.width*3/4.f-sortaPixel*2.0f)/3.0f;
    

    return CGSizeMake(width,width);
    
    
    
}


- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{

    return     1.0f/[UIScreen mainScreen].scale;

}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return     1.0f/[UIScreen mainScreen].scale;

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
