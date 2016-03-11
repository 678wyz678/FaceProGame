//
//  BuyAllObjectDelegate.h
//  face plus
//
//  Created by linxudong on 15/2/11.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@interface BuyAllObjectDelegate : NSObject<SKProductsRequestDelegate>
@property SKProduct* allPackageProduct;
@property NSArray* products;
- (void)validateProductIdentifiers;
-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response;
@end
