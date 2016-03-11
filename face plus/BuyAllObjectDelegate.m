//
//  BuyAllObjectDelegate.m
//  face plus
//
//  Created by linxudong on 15/2/11.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "BuyAllObjectDelegate.h"

@implementation BuyAllObjectDelegate

- (void)validateProductIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:@[@"package_all"]]];
    productsRequest.delegate = self;
    [productsRequest start];
}


-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"error;%@",invalidIdentifier);
        
        // Handle any invalid product identifiers.
    }
    self.allPackageProduct=_products[0];
}
@end
