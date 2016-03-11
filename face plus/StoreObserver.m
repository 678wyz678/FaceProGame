//
//  StoreObserver.m
//  face plus
//
//  Created by linxudong on 12/21/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "StoreObserver.h"
#import <Foundation/NSKeyedArchiver.h>
static StoreObserver* observer;
@implementation StoreObserver
- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions
{
    NSLog(@"updatedTransactions");
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"%@",@"SKPaymentTransactionStatePurchasing");
                break;
            case SKPaymentTransactionStateDeferred:
                NSLog(@"%@",@"SKPaymentTransactionStateDeferred");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"%@",@"SKPaymentTransactionStateFailed");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_PURCHASE_INDICATOR" object:self];

                break;
            case SKPaymentTransactionStatePurchased:
                [self dealRestoreItem:transaction.payment.productIdentifier];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"DISMISS_PURCHASE_INDICATOR" object:self];

                [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Package" object:self];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                [self logTransactionPurchased:transaction.payment.productIdentifier];
                break;
            case SKPaymentTransactionStateRestored:
                

                [self dealRestoreItem:transaction.originalTransaction.payment.productIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];

                [self logTransactionPurchased:transaction.payment.productIdentifier];

                break;
            default:
                NSLog(@"Unexpected transaction state %@", @(transaction.transactionState));
                break;
        }

    }
}


-(void)logTransactionPurchased:(NSString*)productID{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"incompletedWorks.txt"];
    NSString *sceneFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"purchased.txt"]];
    
    
    NSMutableSet* purchasedArray=[NSKeyedUnarchiver unarchiveObjectWithFile:sceneFile];
    if (purchasedArray==nil) {
        purchasedArray=[NSMutableSet new];
    }
    [purchasedArray addObject:productID];
    [NSKeyedArchiver archiveRootObject:purchasedArray toFile:sceneFile];
}


-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    //由于有的包要从下面移到上面，重新加载扩展包
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Refresh_Package" object:self];
}
//处理restore
-(void)dealRestoreItem:(NSString*)productId{
       NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Package" ofType:@"plist"]];
    NSInteger  packageIndex=((NSNumber*)[dictionary objectForKey:productId]).integerValue;
    
    [[NSUserDefaults standardUserDefaults] setInteger:-ABS(packageIndex) forKey:productId ];
    
}

+(instancetype)singleton{
    if (!observer) {
        observer=[[StoreObserver alloc]init];
    }
    return observer;
}
@end
