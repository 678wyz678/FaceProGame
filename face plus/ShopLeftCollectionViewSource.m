//
//  ShopLeftCollectionViewSource.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "ShopLeftCollectionViewSource.h"
#import "ShopImageScrollVIewContentView.h"
#import "ShopCategoryObject.h"
#import "ShopBuyButton.h"
#import <Foundation/NSKeyedArchiver.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
static NSMutableArray* localProductsData;
static NSArray* products;
@interface ShopLeftCollectionViewSource()
@property (weak,nonatomic)UICollectionView*collectionView;
@end



@implementation ShopLeftCollectionViewSource
{
    NSMutableArray* thumbnailNameArray;//图片数据
    NSMutableArray* productIDArray;//id数据

   // NSMutableDictionary* contentViewData;
}

-(instancetype)init{
    
    
    if (self=[super init]) {
        
        thumbnailNameArray=[[NSMutableArray alloc]initWithObjects:@"category_animal",@"category_pk",@"category_zombie",@"category_future",@"category_body",@"category_all", nil];
        productIDArray=[[NSMutableArray alloc] initWithArray:@[@"package_animal_1",@"package_rock_1",@"package_zombie_1",@"package_future_1",@"package_body_1",@"package_all"]];
        if (localProductsData==nil) {
            localProductsData=[NSMutableArray new];
            for (int i=0; i<thumbnailNameArray.count; i++) {
                ShopCategoryObject *object=[[ShopCategoryObject alloc]init];
                object.thumbnailName=thumbnailNameArray[i];
                object.productID=productIDArray[i];
                object.itemPrice=NSLocalizedString(@"buy", @"买");
                [localProductsData addObject:object];
            }
            [self validateProductIdentifiers];
        }
        


        
    }
    return self;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    _collectionView=collectionView;
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return   localProductsData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"master_cell" forIndexPath:indexPath];
    UIImageView* image=(UIImageView*)[cell viewWithTag:3342];
    int color=0;
    switch (indexPath.row) {
        case 1:
            color=0xfd9526;
            break;
            
            case 2:
            color=0xd02752;
            break;

            case 3:
            color=0x60e5c6;
            break;
        case 4:
            color=0xe0f808;
            break;
            default:
            color=0xfdcd2f;
            break;
    }
    cell.backgroundColor=UIColorFromRGB(color);
    
    NSString*path=[[NSBundle mainBundle] pathForResource:[[localProductsData objectAtIndex:indexPath.row] thumbnailName] ofType:@"png"];
    image.image=[UIImage imageWithContentsOfFile:path];
    image.contentMode=UIViewContentModeScaleAspectFit;
    ShopBuyButton*buyBtn=(ShopBuyButton*)[cell viewWithTag:8653];
    buyBtn.productID=[localProductsData[indexPath.row] productID];
    buyBtn.productInfo=[localProductsData[indexPath.row] productInfo];
    buyBtn.productPrice=[localProductsData[indexPath.row] itemPrice];
    [buyBtn setTitle:[localProductsData[indexPath.row] itemPrice] forState:UIControlStateNormal];
    return cell;
}

//查询商品
- (void)validateProductIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIDArray]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{

    products = response.products;
    
    //检查出错的商品id
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"error;%@",invalidIdentifier);
        }
    
    ///本地货币格式
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    ///本地货币格式结束
    
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    // NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"incompletedWorks.txt"];
    NSString *purchasedSetFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"purchased.txt"]];
    
    
    NSSet*purchasedSet=[NSKeyedUnarchiver unarchiveObjectWithFile:purchasedSetFile];
    
    
    
    //把商品的价格写回localProductdata
    for(SKProduct  *product in products){
        
    NSUInteger productIndex =  [productIDArray indexOfObject:product.productIdentifier];
     ShopCategoryObject*object =  localProductsData[productIndex];
        [numberFormatter setLocale:product.priceLocale];
        object.itemPrice= [numberFormatter stringFromNumber:product.price];
        object.productInfo=product.localizedDescription;
        
        if ([purchasedSet containsObject:product.productIdentifier]) {
            object.itemPrice=NSLocalizedString(@"Bought", @"已经购买");
        }
        
    }
    if (_collectionView) {
        [_collectionView reloadData];
    }
    
    

}

@end
