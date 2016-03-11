//
//  BottomPagerController.h
//  face plus
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BottomPagerDelegate,ViewControllerSource;
@interface BottomPagerController : UIPageViewController
@property(nonatomic) BottomPagerDelegate* pagerDelegate;
@property(nonatomic) ViewControllerSource* source;
-(void)switchPageController:(NSArray*)array;
@end
