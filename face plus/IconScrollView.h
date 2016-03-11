//
//  IconScrollView.h
//  face plus
//
//  Created by linxudong on 12/29/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IconScrollViewDelegate;
@interface IconScrollView : UIScrollView
@property IconScrollViewDelegate* myDelegate;
@property NSMutableArray* subViewArray;
@property (nonatomic,assign)BOOL inModeOfShake;
@end
