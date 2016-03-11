//
//  GlobalNavigationViewController.m
//  face plus
//
//  Created by linxudong on 14/11/18.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "GlobalNavigationViewController.h"
#import <UIKit/UIKit.h>
#import "PLUS_SKView.h"
#import "ViewController.h"
#import "ShopViewController.h"
@interface GlobalNavigationViewController ()
@property ShopViewController * shopViewController;
@end

@implementation GlobalNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showController:) name:@"SHOW_CONTROLLER" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popController) name:@"POP_ONE_CONTROLER" object:nil];
    
    
    // Do any additional setup after loading the view.
}

-(void)popController{
    [self popViewControllerAnimated:NO];
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (![self.navigationController.topViewController isKindOfClass:[ViewController class]]) {
        [super pushViewController:viewController animated:animated];
        return;
    }

}
-(void)showController:(NSNotification*)sender{
    NSString* storyboard=[sender.userInfo objectForKey:@"Storyboard"];
    NSString* controllerName=[sender.userInfo objectForKey:@"Controller"];
    
    
    
    UIViewController* controller=[[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:controllerName];
    if ([controllerName isEqualToString:@"Store"]&&self.shopViewController) {
        controller=self.shopViewController;
    }
    else if([controllerName isEqualToString:@"Store"]){
        
        NSLog(@"缓存商店");
        self.shopViewController=(ShopViewController*)controller;
    }
    
    
    id param=[sender.userInfo objectForKey:@"Param"];
    if (param) {
        if ([controller respondsToSelector:@selector(setController_Param:)]) {
            [controller setValue:param forKey:@"controller_Param"];
        }
    }
    
    [self pushViewController:controller animated:NO];
}


-(void)showMainController{
    @try {
        if(self.mainControllerCache){
            self.mainControllerCache.fromNavigation=YES;
            [self pushViewController:_mainControllerCache animated:NO];
        }
        else{
            UIViewController* controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditMode"];
            self.mainControllerCache=controller;
            self.mainControllerCache.fromNavigation=YES;
            [self pushViewController:controller animated:NO];
        }

    }
    @catch (NSException *exception) {
        
    }
}


-(void)showMainControllerWithShake{
    @try {
        if(self.mainControllerCache){
            self.mainControllerCache.fromNavigation=YES;
            self.mainControllerCache.gotoShake=YES;
            [self pushViewController:_mainControllerCache animated:NO];
        }
        else{
            ViewController* controller=(ViewController*)[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditMode"];
            self.mainControllerCache=controller;
            self.mainControllerCache.fromNavigation=YES;
            self.mainControllerCache.gotoShake=YES;
            [self pushViewController:controller animated:NO];
        }
        
    }
    @catch (NSException *exception) {
        
    }
}

-(void)showMainControllerWithSceneName:(NSString*)sceneName{
            if (self.mainControllerCache) {
            self.mainControllerCache.controller_Param=sceneName;
            self.mainControllerCache.fromNavigation=YES;
            [self pushViewController:self.mainControllerCache animated:NO];
        }
        else{
            UIViewController* controller=[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"EditMode"];
            self.mainControllerCache=controller;
            self.mainControllerCache.controller_Param=sceneName;
            self.mainControllerCache.fromNavigation=YES;
            [self pushViewController:controller animated:NO];
        }
    
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//禁止转动
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(BOOL) shouldAutorotate {
    
    // Return YES for supported orientations
    return YES;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */-(void)dealloc{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
 }
@end
