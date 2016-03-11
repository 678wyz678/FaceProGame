//
//  MyCollectionViewCell.h
//  CollectionViewTest
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Ferrum. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BaseEntity;
@interface MyCollectionViewCell : UICollectionViewCell
//如果是12，14，16的素材，通过此属性来定位collectionview位置
@property(weak,nonatomic) BaseEntity* entityForCell;

@end
