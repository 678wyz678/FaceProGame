//
//  ItemGridDataSourceDelegate.m
//  face plus
//
//  Created by linxudong on 1/22/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ItemGridDataSourceDelegate.h"
#import "PackageIndexArray.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation ItemGridDataSourceDelegate
-(instancetype)init{

    _data=[PackageIndexArray singleton].animalIndexFiles;
    _cellColor=[UIColor colorWithRed:0xfd/255.f green:0xcd/255.f blue:0x2f/255.f alpha:0.4];//UIColorFromRGB(0xfdcd2f);
     return self;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}





- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  _data.count;   // _sourceData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"item_cell" forIndexPath:indexPath];
    
    cell.backgroundColor=_cellColor;
    UIImageView*imageView=(UIImageView*)[cell viewWithTag:3640];
    NSString* actualName=[_data[indexPath.row] stringByReplacingOccurrencesOfString:@".png" withString:@""];

     NSString*path=  [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
    imageView.image=[UIImage imageWithContentsOfFile:path];
    if([UIImage imageWithContentsOfFile:path]==nil){
        NSLog(@"path:%@",actualName);
    }
    return cell;
}




@end
