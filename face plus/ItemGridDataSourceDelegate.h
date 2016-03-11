//
//  ItemGridDataSourceDelegate.h
//  face plus
//
//  Created by linxudong on 1/22/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ItemGridDataSourceDelegate : NSObject<UICollectionViewDataSource>
@property (nonatomic) NSMutableArray* data;
@property(nonatomic) UIColor*cellColor;
@end
