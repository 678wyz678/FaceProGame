//
//  FontController.h
//  face plus
//
//  Created by linxudong on 1/1/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownToUpDelegate;
@interface FontController : UIViewController
@property (assign,nonatomic) NSUInteger index;
@property (weak,nonatomic)DownToUpDelegate* focusDelegate;
@end
