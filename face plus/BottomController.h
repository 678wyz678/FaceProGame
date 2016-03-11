//
//  BottomController.h
//  face plus
//
//  Created by linxudong on 1/7/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownToUpDelegate,PackageArray;
@interface BottomController : UICollectionViewController
@property (nonatomic) PackageArray* data;
@property (assign) NSUInteger index;
@property (weak,nonatomic)DownToUpDelegate* focusDelegate;

@property(assign,nonatomic)BOOL notSetCurrentNodeAfterViewAppear;
@end
