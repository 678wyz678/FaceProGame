//
//  ShopViewController.m
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "ShopViewController.h"
#import "MyNaviGationView.h"
#import "Reachability.h"
#import "BuyAllObjectDelegate.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "JSONHTTPClient.h"
#import "KVNProgress.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSMutableArray* purchasedItems;

static NSInteger downloadVersionNum;
@interface ShopViewController ()
@property SKReceiptRefreshRequest*  request;
@property SCLAlertView* alertView;
@property (assign,nonatomic)NSInteger numOfTotal;
@property (assign,nonatomic)NSInteger numOfDownload;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNavigation:) name:@"SWITCH_SHOP_ITEM" object:nil];
    _navigationBar.backgroundColor=UIColorFromRGB(0xfdcd2f);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAlertForBuyItem:) name:@"BUY_ITEM" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissAlert) name:@"DISMISS_PURCHASE_INDICATOR" object:nil];
    
    
    //UIAlertView* updateAlertView=[[UIAlertView alloc]initWithTitle:@"更多免费素材已发布" message:@"是否要更新以获得更多素材" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
    
    //[updateAlertView show];
    // Do any additional setup after loading the view.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//更新
    if (buttonIndex==1) {
        __weak typeof (self) weakSelf=self;
      NSInteger versionNum=  [[NSUserDefaults standardUserDefaults] integerForKey:@"PUSH_VERSION"];
   [JSONHTTPClient getJSONFromURLWithString:@"http://www.keyiart.com/getMoreFree" params:@{@"current_version":[NSNumber numberWithInteger:versionNum]} completion:^(id json, JSONModelError *err) {
       if(err)
       {NSString*error=@"Network Error";
           if([json objectForKey:@"content"]){
               error=[json objectForKey:@"content"];
           }
           [KVNProgress showErrorWithStatus:error];
       }
       else{
           [weakSelf checkJSON:json addToCurrentArray:NO];
       }
   }];
    }

    
}



-(void)checkJSON:(NSDictionary*)json addToCurrentArray:(BOOL)add{//
    
     if([json isKindOfClass:[NSDictionary class]]){
         
         NSArray*array=[json objectForKey:@"content"];
         downloadVersionNum=[[json objectForKey:@"version"] integerValue];
         if (array.count>0) {
             [KVNProgress showProgress:0.02];
             self.numOfTotal=array.count;
             [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                 [self downloadFreeImage:obj];
             }];
         }
         return;
    }
   
    [KVNProgress showErrorWithStatus:@"Data Error!"];

}

-(void)downloadFreeImage:(NSString*)stringURL{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Downloading Started");
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        NSString*filename= [url lastPathComponent];
        if ( urlData )
        {
            
            NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString  *documentsDirectory = [paths objectAtIndex:0];
            NSString* updatedImageDirectory=[documentsDirectory stringByAppendingPathComponent:@"updatedIndexImages"];
            if ([filename containsString:@"@2x"]) {
                updatedImageDirectory=[documentsDirectory stringByAppendingPathComponent:@"updatedImages"];
            }
            [self createDirectory:@"updatedImages" atFilePath:documentsDirectory];
            [self createDirectory:@"updatedIndexImages" atFilePath:documentsDirectory];

            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", updatedImageDirectory,filename];
            
            
            
            //saving is done on main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [urlData writeToFile:filePath atomically:YES];
                NSLog(@"File Saved !");
                self.numOfDownload++;
            });
        }
        
    });
}


//创建更新资源保存目录
-(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}

-(void)setNumOfDownload:(NSInteger)numOfDownload{
    _numOfDownload=numOfDownload;

    [KVNProgress showProgress:_numOfDownload*1.0/_numOfTotal];
    if (_numOfDownload>=self.numOfTotal) {
        self.numOfTotal=0;
        [KVNProgress dismissWithCompletion:^{
            [[NSUserDefaults standardUserDefaults]setInteger:downloadVersionNum forKey:@"PUSH_VERSION"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc]initWithTitle:@"下载完成" message:@"" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            });
            [[NSUserDefaults standardUserDefaults]synchronize];

            
        }];
    }
    
}



-(void)dismissAlert{
    [_alertView hideView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOP_LEFT_SCROLL" object:self];
    
}


-(void)showAlertForBuyItem:(NSNotification*)sender{
    NSString* productId=[sender.userInfo objectForKey:@"Product_ID"];
    NSString* productInfo=[sender.userInfo objectForKey:@"Product_Info"];
    NSString* productPrice=[sender.userInfo objectForKey:@"Product_Price"];

   NetworkStatus status= [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
    
    if (productInfo) {
        __weak typeof(self) weakSelf=self;
        _alertView=[[SCLAlertView alloc]init];
        [_alertView addButton:@"Buy" actionBlock:^{
            weakSelf.products=@[productId];
            if (weakSelf) {
                [weakSelf validateProductIdentifiers];
            }
        }];
        [_alertView showCustom:self image:[UIImage imageNamed:@"globalStore"] color:UIColorFromRGB(0x1abc9c) title:productPrice subTitle:productInfo closeButtonTitle:@"Cancel" duration:0.0f];
    }
    else if(status==NotReachable){
        _alertView=[[SCLAlertView alloc]init];
        [_alertView showWaiting:self title:@"" subTitle:NSLocalizedString(@"No internet connection", @"无互联网连接,请稍后重试") closeButtonTitle:@"OK" duration:2.f];

    }
    else{
        _alertView=[[SCLAlertView alloc]init];
        [_alertView showWaiting:self title:@"" subTitle:NSLocalizedString(@"Fetching info from AppStore...", @"从服务器获取信息") closeButtonTitle:@"OK" duration:2.f];
    }
    
}

- (void)validateProductIdentifiers
{
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:_products]];
    productsRequest.delegate = self;
    [productsRequest start];
}


-(void)updateNavigation:(NSNotification*)sender{
    NSUInteger index=((NSNumber*)[[sender userInfo] objectForKey:@"SHOP_ITEM_INDEX"]).unsignedIntegerValue;
    
    int color=0;
    
    switch (index) {
        case 0:
            color=0xfdcd2f;
            break;
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
            return;
            break;
    }
    
    _navigationBar.backgroundColor=UIColorFromRGB(color);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  //  self.navigationController.navigationBarHidden=NO;
}
-(BOOL)prefersStatusBarHidden{
    return YES;
}






//处理购买

// SKProductsRequestDelegate protocol method
-(void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"error;%@",invalidIdentifier);
        
        // Handle any invalid product identifiers.
    }
    SKProduct* product=_products[0];
    
    
    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
    payment.quantity = 1;
    _alertView=[[SCLAlertView alloc]init];
    [_alertView showWaiting:self title:@"" subTitle:@"Processing..." closeButtonTitle:nil duration:0.f];
    
    [[SKPaymentQueue defaultQueue] addPayment:payment];
   
}


-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}




//恢复购买
- (IBAction)restore:(id)sender {
    NetworkStatus status= [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
   if(status==NotReachable){
        _alertView=[[SCLAlertView alloc]init];
        [_alertView showWaiting:self title:@"" subTitle:NSLocalizedString(@"No internet connection", @"无互联网连接,请稍后重试") closeButtonTitle:@"OK" duration:2.f];
    }
    
   else{
       
       [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
       
       //NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],SKReceiptPropertyIsVolumePurchase,[NSNumber numberWithBool:NO],SKReceiptPropertyIsExpired,[NSNumber numberWithBool:NO],SKReceiptPropertyIsRevoked, nil];
       _request = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:nil];
       _request.delegate = self;
       [_request start];
       _alertView=[[SCLAlertView alloc]init];
       [_alertView showWaiting:self title:[NSString stringWithFormat:@"%@...",NSLocalizedString(@"Restoring", @"努力恢复中")]  subTitle:@"" closeButtonTitle:nil duration:10.f];
   }

}


-(void)requestDidFinish:(SKRequest *)request
{
    if ([request isKindOfClass:[SKReceiptRefreshRequest class]]) {
       // NSLog(@"Got a new receipt...");
        [_alertView hideView];
        _alertView=[[SCLAlertView alloc]init];
        [_alertView showSuccess:self title:nil subTitle:NSLocalizedString(@"Restoration done", @"恢复完成") closeButtonTitle:@"OK" duration:2.f];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
