//
//  GalleryCollectionViewController.h
//  face plus
//
//  Created by linxudong on 14/12/5.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryCollectionViewController : UICollectionViewController<UIGestureRecognizerDelegate>
//bool表示是否来自FirstScreen,选择点击edit后进入controller的方式
@property (assign,nonatomic)BOOL controller_Param;
@end
