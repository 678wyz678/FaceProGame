//
//  SettingTableViewController.m
//  face plus
//
//  Created by linxudong on 14/12/2.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "SettingTableViewController.h"
@interface SettingTableViewController(){
}
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (strong,nonatomic )SKReceiptRefreshRequest* request;

@end

@implementation SettingTableViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    BOOL playSound=  [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
    _soundSwitch.on=playSound;
}

- (IBAction)changeSound:(UISwitch*)sender {
 [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"PlaySound"];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
  }

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
//    
//    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithBool:YES],SKReceiptPropertyIsVolumePurchase,[NSNumber numberWithBool:NO],SKReceiptPropertyIsExpired,[NSNumber numberWithBool:NO],SKReceiptPropertyIsRevoked, nil];
//    _request = [[SKReceiptRefreshRequest alloc] initWithReceiptProperties:dict];
//    _request.delegate = self;
//    [_request start];
}



@end
