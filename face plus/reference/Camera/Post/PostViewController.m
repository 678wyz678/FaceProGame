//
//  PostViewController.m
//  SCCaptureCameraDemo
//
//  Created by Aevitx on 14-1-21.
//  Copyright (c) 2014年 Aevitx. All rights reserved.
//

#import "PostViewController.h"

@interface PostViewController ()

@end

@implementation PostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (_postImage) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:_postImage];
        imgView.clipsToBounds = YES;
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
        imgView.center = self.view.center;
        [self.view addSubview:imgView];
    }
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backBtn.frame = CGRectMake(0, self.view.frame.size.height - 40, 80, 40);
    [backBtn setTitle:NSLocalizedString(@"Cancel", @"返回") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    
    UIButton *useItBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    useItBtn.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height - 40, 80, 40);
    [useItBtn setTitle:NSLocalizedString(@"Use", @"使用")  forState:UIControlStateNormal];
    [useItBtn addTarget:self action:@selector(useBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:useItBtn];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backBtnPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)useBtnPressed:(id)sender {
    NSDictionary*dict=[NSDictionary dictionaryWithObject:self.postImage forKey:@"POST_PHOTO"]    ;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Photo_is_ready" object:self userInfo:dict];
}





@end
