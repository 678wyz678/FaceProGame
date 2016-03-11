//
//  TeamViewController.m
//  face plus
//
//  Created by linxudong on 15/2/7.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "TeamViewController.h"
#import "AboutDevice.h"
@interface TeamViewController ()

@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString*device=platformType();
    UIImageView*teamView=(UIImageView*)[self.view viewWithTag:55316];
    if([device isEqualToString:@"5"]||[device isEqualToString:@"4"]||[device isEqualToString:@"6"]||[device isEqualToString:@"6P"])
    {
    
    }
    else{
    device=@"4";
    }
    NSString*path=[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"team%@",device] ofType:@"png"];
    UIImage*image=[UIImage imageWithContentsOfFile:path];
    [teamView setImage:image];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
