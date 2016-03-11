//
//  GlobalNavigationViewController.h
//  face plus
//
//  Created by linxudong on 14/11/18.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ViewController;
@interface GlobalNavigationViewController : UINavigationController
@property ViewController* mainControllerCache;


-(void)showMainControllerWithSceneName:(NSString*)sceneName;
-(void)showMainController;
-(void)showMainControllerWithShake;
@end
