//
//  ShopBuyButton.h
//  face plus
//
//  Created by linxudong on 1/11/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
@interface ShopBuyButton : UIButton<SKProductsRequestDelegate>
@property NSString* productID;
@property NSString* productInfo;
@property NSString* productPrice;

@end
