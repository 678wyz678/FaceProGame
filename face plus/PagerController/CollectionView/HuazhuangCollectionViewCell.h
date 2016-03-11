//
//  HuazhuangCollectionViewCell.h
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "MyCollectionViewCell.h"
@class BaseEntity;
@interface HuazhuangCollectionViewCell : MyCollectionViewCell
@property (weak,nonatomic)BaseEntity* entityForCell;
@end
