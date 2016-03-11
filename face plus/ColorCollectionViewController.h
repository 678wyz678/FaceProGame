//
//  ColorCollectionViewController.h
//  face plus
//
//  Created by linxudong on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCollectionViewController.h"
@class DownToUpDelegate;
@interface ColorCollectionViewController : UICollectionViewController
@property (assign,nonatomic)NSUInteger index;
@property BOOL ifChangeColorForBackground;
@property DownToUpDelegate* delegate;
@end
