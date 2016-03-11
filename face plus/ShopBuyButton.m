//
//  ShopBuyButton.m
//  face plus
//
//  Created by linxudong on 1/11/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ShopBuyButton.h"
#import <StoreKit/StoreKit.h>

@implementation ShopBuyButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.backgroundColor=[UIColor colorWithRed:0x32/255.f green:0x46/255.f blue:0x81/255.f alpha:0.3];
        self.layer.cornerRadius=6.0f;
        self.clipsToBounds=YES;
        
        
        [self addTarget:self action:@selector(clickBuy) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void) setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor colorWithRed:0x32/255.f green:0x46/255.f blue:0x81/255.f alpha:0.08];
    }
    else {
        self.backgroundColor = [UIColor colorWithRed:0x32/255.f green:0x46/255.f blue:0x81/255.f alpha:0.3];;
    }
}

//购买事件
-(void)clickBuy{
    if (self.productID) {
        NSDictionary* dict=[NSDictionary dictionaryWithObjectsAndKeys:self.productID,@"Product_ID",self.productInfo,@"Product_Info", self.productPrice,@"Product_Price",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUY_ITEM" object:self userInfo:dict];
       
    }
   
}


//- (void)validateProductIdentifiers
//{
//    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
//                                          initWithProductIdentifiers:[NSSet setWithArray:_products]];
//    productsRequest.delegate = self;
//    [productsRequest start];
//}
//
//// SKProductsRequestDelegate protocol method
//- (void)productsRequest:(SKProductsRequest *)request
//     didReceiveResponse:(SKProductsResponse *)response
//{
//    self.products = response.products;
//
//    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
//        NSLog(@"error;%@",invalidIdentifier);
//
//        // Handle any invalid product identifiers.
//    }
//    SKProduct* product=_products[0];
//
//
//    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
//    payment.quantity = 1;
//
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
//}
//
//
//-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
//    NSLog(@"%@",error);
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
