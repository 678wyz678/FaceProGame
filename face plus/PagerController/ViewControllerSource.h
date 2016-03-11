//
//  ViewControllerSource.h
//  face plus
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class  MyCollectionViewController;
@interface ViewControllerSource : NSObject<UIPageViewControllerDataSource>
@property ( strong, nonatomic) NSMutableDictionary *pageData;
- (NSUInteger)indexOfViewController:(MyCollectionViewController *)viewController;
- (MyCollectionViewController *)viewControllerAtIndex:(NSUInteger)index;

-(void)initPackageDictionary;

NSMutableDictionary* getPageData();
@end
