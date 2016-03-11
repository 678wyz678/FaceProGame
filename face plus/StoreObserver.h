//
//  StoreObserver.h
//  face plus
//
//  Created by linxudong on 12/21/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
@interface StoreObserver : NSObject<SKPaymentTransactionObserver>
+(instancetype)singleton;
@end
