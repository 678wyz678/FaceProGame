//
//  FontController.m
//  face plus
//
//  Created by linxudong on 1/1/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "FontController.h"
#import "DownToUpDelegate.h"
#import "ViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
@implementation FontController


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //转动素材后更新界面焦点（参数为本collection的第一张素材entity）
    [self.focusDelegate updateFocus:nil setCurrentNode:NO];
    [self.focusDelegate updateIconScrollViewOffset:self.index];
    self.focusDelegate.viewController.inModeOfBackgroundGrid=NO;

}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.focusDelegate= [DownToUpDelegate singleton];
}

- (IBAction)InsertFont:(UIButton *)sender {
    SCLAlertView *alert = [[SCLAlertView alloc] init];
    
    UITextField *textField = [alert addTextField:@""];
    
    [alert addButton:NSLocalizedString(@"Word", @"添加") actionBlock:^(void) {
        NSString*font= textField.text;
        NSDictionary*dict=NSDictionaryOfVariableBindings(font);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ADD_FONT" object:self userInfo:dict];
        
    }];
    
    [alert showEdit:_focusDelegate.viewController title:NSLocalizedString(@"Enter some words", @"输入文字") subTitle:NSLocalizedString(@"Add words into the scene.", @"在肖像中添加文字") closeButtonTitle:NSLocalizedString(@"Cancel",@"取消") duration:0.0f];
    
    
}


@end
