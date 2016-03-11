//
//  AppDelegate.m
//  face plus
//
//  Created by Willian on 14/10/26.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "AppDelegate.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerController.h>
#import <StoreKit/StoreKit.h>
#import "StoreObserver.h"
#import "ViewController.h"
#import "MyShareDelegate.h"
#import "WXApi.h"
#import "DownToUpDelegate.h"
#import "WeiboSDK.h"
#import "PresentMiddleObject.h"
//#import "APService.h"
#import "MTStatusBarOverlay.h"
#import "ZWIntroductionViewController.h"
#import "AboutDevice.h"
#import "NSString+Contains.h"
extern NSString * const kAPNetworkDidSetupNotification;
extern NSString * const kAPNetworkDidCloseNotification;
extern NSString * const kAPNetworkDidRegisterNotification;
extern NSString * const kAPNetworkDidLoginNotification;
// 建立连接 // 关闭连接
// 注册成功 // 登录成功
extern NSString * const kAPNetworkDidReceiveMessageNotification; // 收到消息(非APNS)

@interface AppDelegate ()
@property MPMoviePlayerController* player;
@property ZWIntroductionViewController* introductionView;
@end

@implementation AppDelegate
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"language:%@",language);
   
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"notAppFirstBoot"]) {
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"Export_4-4"];
        [[NSUserDefaults standardUserDefaults] setBool:1 forKey:@"notAppFirstBoot"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }
    
    //微信
    [WXApi registerApp:@"wx6a7a718fa1de049b"];
    //微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:@"482555234"];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:[StoreObserver singleton]];
    //[self initAPService:launchOptions];
    
    
    //加载guideview
  BOOL not_first_launch=  [[NSUserDefaults standardUserDefaults] boolForKey:@"not_first_luanch"];
    if (!not_first_launch) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"not_first_luanch"];
        self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //  self.window.backgroundColor = [UIColor whiteColor];
        [_window makeKeyAndVisible];
        
        // Added Introduction View Controller
        NSString*device=platformType();
        if([device isEqualToString:@"5"]||[device isEqualToString:@"4"]||[device isEqualToString:@"6"]||[device isEqualToString:@"6P"])
        {
            
        }
        else{
            device=@"5";
        }
        
        BOOL chinese=NO;
        NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
        NSLog(@"language:%@",language);
        if ([language myContainsString:@"zh"]) {
            chinese=YES;
        }
        
        NSArray *coverImageNames = @[@"1pix", @"1pix", @"1pix", @"1pix"];
        NSArray *backgroundImageNames = @[[NSString stringWithFormat:@"intro_1_%@%@",device,chinese==YES?@"":@"_en"],
            [NSString stringWithFormat:@"intro_2_%@%@.jpg",device,chinese==YES?@"":@"_en"],
            [NSString stringWithFormat:@"intro_3_%@%@.jpg",device,chinese==YES?@"":@"_en"]
                                          
                                          
        ,[NSString stringWithFormat:@"intro_4_%@%@.jpg",device,chinese==YES?@"":@"_en"]];
        self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
        
                [self.window addSubview:self.introductionView.view];
        
        __weak AppDelegate *weakSelf = self;
        self.introductionView.didSelectedEnter = ^() {
            [weakSelf.introductionView.view removeFromSuperview];
            weakSelf.introductionView = nil;
            weakSelf.window.rootViewController=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"global_nav"];
            
            //[self.window makeKeyAndVisible];
            //[weakSelf.window addSubview:weakSelf.firstScreenController.view];
            // enter main view , write your code ...
            
        };

    }
     return YES;
}


//-(void)initAPService:(NSDictionary*)launchOptions{
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        //categories
//        [APService
//         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                             UIUserNotificationTypeSound |
//                                             UIUserNotificationTypeAlert)
//         categories:nil];
//    } else {
//        //categories nil
//        [APService
//         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                             UIRemoteNotificationTypeSound |
//                                             UIRemoteNotificationTypeAlert)
//         categories:nil];
//#else
//        //categories nil
//        [APService
//         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                             UIRemoteNotificationTypeSound |
//                                             UIRemoteNotificationTypeAlert)
//         categories:nil];
//#endif
//        // Required
//        [APService setupWithOption:launchOptions];
//        
//        
//       
//
//        return ;
//    }
//    
//}


//-(void) moviePlayBackDidFinish:(NSNotification*)notification
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
// [self.player.view removeFromSuperview];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.FerrumBox.face_plus" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"face_plus" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"face_plus.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
//////
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([WXApi handleOpenURL:url delegate:self]) {
        return YES;
    }
    else{
      return   [WeiboSDK handleOpenURL:url delegate:self];
    }
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    if ([WXApi handleOpenURL:url delegate:self]) {
        return YES;
    }
    else{
        return   [WeiboSDK handleOpenURL:url delegate:self];
    }
}


//实现微信请求和回应

-(void) onReq:(BaseReq*)req
{
      
}

-(void) onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        if (resp.errCode==0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
           
                NSDictionary* dict=[NSDictionary dictionaryWithObject:@"WEIXIN" forKey:@"SOURCE"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_PRESENT" object:self userInfo:dict];
            
            });
            

        }
    }
}







//微博
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        BOOL success=(response.statusCode==WeiboSDKResponseStatusCodeSuccess);
        if (success) {
           
            NSDictionary* dict=[NSDictionary dictionaryWithObject:@"WEIBO" forKey:@"SOURCE"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_PRESENT" object:self userInfo:dict];

        }

    }
  }








////JPush 推送实现delegate
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    // Required
//    [APService registerDeviceToken:deviceToken];
//}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    // Required
//    [APService handleRemoteNotification:userInfo];
//
//}
//- (void)application:(UIApplication *)application
//didReceiveRemoteNotification:(NSDictionary *)userInfo
//fetchCompletionHandler:(void
//                        (^)(UIBackgroundFetchResult))completionHandler {
//    // IOS 7 Support Required
//    NSLog(@"userinfo:%@",userInfo);
//
//    [APService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}



@end
