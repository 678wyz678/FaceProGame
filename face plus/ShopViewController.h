//
//  ShopViewController.h
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@class MyNaviGationView;
@interface ShopViewController : UIViewController<SKProductsRequestDelegate>

@property (weak, nonatomic) IBOutlet MyNaviGationView *navigationBar;
@property NSArray*products;
@end
