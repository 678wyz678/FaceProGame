//
//  HuazhuangCollectionViewController.h
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "MyCollectionViewController.h"
@class BaseEntity;
@interface HuazhuangCollectionViewController : MyCollectionViewController
NSMutableSet* getSelectedIndexPath();

void setSelectedIndexPath(NSMutableSet*set);
@end
