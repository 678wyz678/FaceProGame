//
//  MyShareDelegate.m
//  face plus
//
//  Created by linxudong on 15/1/26.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "MyShareDelegate.h"
#import "WXApi.h"
#import <UIKit/UIKit.h>
#import "WXApiObject.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import <Social/Social.h>
#import <SCLAlertView.h>
#define shareBodyArrayName @"shareBodyBounce"
@implementation MyShareDelegate
-(instancetype)initWithController:(ViewController*)controller{
    if (self=[super init]) {
        self.controller=controller;
    }
    return self;
}
- (void) sendWeixinImageContent:(UIImage*)images
{
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[MyShareDelegate getThumbnail:images]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(images,0.4f);
    
    
    message.mediaObject = ext;
    message.title=@"Face Pro";
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
}

- (void) sendWeixinImageContentInTiemLine:(UIImage*)images
{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[MyShareDelegate getThumbnail:images]];
    
    WXImageObject *ext = [WXImageObject object];
    ext.imageData = UIImageJPEGRepresentation(images,0.4f);
    
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    [WXApi sendReq:req];
}


-(void)shareSinaWeibo:(UIImage*)image{
    //准备图片
    WBMessageObject *message = [WBMessageObject message];
    WBImageObject *object = [WBImageObject object];
    object.imageData =UIImagePNGRepresentation(image);
    message.imageObject =object ;

    //发送
    
    //AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"http://www.usst365.com";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}

-(void)shareTwitter:(UIImage *)image{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
    
        SLComposeViewController *tweetSheet = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:NSLocalizedString(@"Nice work,Face Pro is such an amazing application!", @"分享语")];
        [tweetSheet addImage:image];
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result){
            if(SLComposeViewControllerResultDone==result){
                //完成，添加积分
                NSDictionary* dict=[NSDictionary dictionaryWithObject:@"TWITTER" forKey:@"SOURCE"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_PRESENT" object:self userInfo:dict];
               
            }
          
        }];

        
        [self.controller presentViewController:tweetSheet animated:YES completion:nil];

    }
    else{
    [[[UIAlertView alloc]initWithTitle:@"Please login" message:@"Please login your account in Phone Setting panel" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
    
}

-(void)shareFaceBook:(UIImage *)image{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){

    SLComposeViewController *facebook = [SLComposeViewController
                                           composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebook setInitialText:NSLocalizedString(@"Nice work,Face Pro is such an amazing application!", @"分享语")];
    [facebook addImage:image];
    [facebook setCompletionHandler:^(SLComposeViewControllerResult result){
        if(SLComposeViewControllerResultDone==result){
        //完成，添加积分
            NSDictionary* dict=[NSDictionary dictionaryWithObject:@"FACEBOOK" forKey:@"SOURCE"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NEED_PRESENT" object:self userInfo:dict];

        }
    }];
    [self.controller presentViewController:facebook animated:YES completion:nil];
    }
    else{
        [[[UIAlertView alloc]initWithTitle:@"Please login" message:@"Please login your account in Phone Setting panel" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}

+(UIImage*)getThumbnail:(UIImage*)images{
    //取出缩略图（大小约为25k）
    CGSize newSize=CGSizeMake(60, images.size.height/images.size.width*60);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [images drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //缩略图结束
    return newImage;
}

-(BOOL)addAddition{
  NSArray* tempArray= [[NSUserDefaults standardUserDefaults] valueForKey:shareBodyArrayName];
    NSMutableArray *array=[NSMutableArray new];
    if (tempArray){
        array=[NSMutableArray arrayWithArray:tempArray];
    }

    int num=arc4random_uniform(5);
    if (num==0) {
        num++;
    }

    NSString* bodyNum=[NSString stringWithFormat:@"%d",num];
    BOOL added=NO;

    if (![array containsObject:bodyNum]) {
        [array addObject:bodyNum];
        added=YES;
    }

    NSArray* finalArray=[NSArray arrayWithArray:array];

    [[NSUserDefaults standardUserDefaults] setValue:finalArray forKey:shareBodyArrayName];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return added;
}




@end
