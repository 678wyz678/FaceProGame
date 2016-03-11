//
//  BottomController.m
//  face plus
//
//  Created by linxudong on 1/7/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "BottomController.h"
#import "DownToUpDelegate.h"
#import "PackageArray.h"
#import "ViewController.h"
#import "BackgroundCollectionViewController.h"
@implementation BottomController
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
        [self.focusDelegate updateFocus:[self.data.packageArray objectAtIndex:0] setCurrentNode:_notSetCurrentNodeAfterViewAppear];
    
    [self.focusDelegate updateIconScrollViewOffset:self.index];
    _focusDelegate.viewController.inModeOfBackgroundGrid=NO;
    if ([self isKindOfClass:[BackgroundCollectionViewController class]]) {
        _focusDelegate.viewController.inModeOfBackgroundGrid=YES;
    }
  
}

-(void)viewDidLoad{
    [super viewDidLoad];
   self.focusDelegate= [DownToUpDelegate singleton];
}
@end
