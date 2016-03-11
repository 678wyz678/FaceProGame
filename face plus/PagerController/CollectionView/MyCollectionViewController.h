//
//  MyCollectionViewController.h
//  CollectionViewTest
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Ferrum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BottomController.h"
@class  DownToUpDelegate,BottomPagerController,BaseEntity;
@interface MyCollectionViewController : BottomController
@property NSMutableArray* packageData;
@property NSArray* allPackages;

-(NSIndexPath*)loopToFindIndexForEntity:(BaseEntity*)entity;

NSMutableDictionary* getDictionaryOfIndexPath();
NSMutableDictionary* getDictionaryOfNormalPackageSectionNum();
void setDictionaryOfIndexPath(NSMutableDictionary* indexPathDict);
@end
