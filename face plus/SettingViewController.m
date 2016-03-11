//
//  SettingViewController.m
//  face plus
//
//  Created by linxudong on 15/1/31.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "SettingViewController.h"
@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *soundSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *electricSoundEffectSwitch;
@property (weak, nonatomic) IBOutlet UIButton *imageSizeButton;
@property (weak, nonatomic) IBOutlet UISwitch *guitarEffectSwitch;
@property (weak, nonatomic) IBOutlet UILabel *guitarLabel;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    BOOL playSound=  [[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"];
    _soundSwitch.on=playSound;

    
    BOOL elecEffect=  [[NSUserDefaults standardUserDefaults] boolForKey:@"ElecEffect"];
    _electricSoundEffectSwitch.on=elecEffect;
    _guitarEffectSwitch.on=!elecEffect;
    [_guitarLabel setText:NSLocalizedString(@"Guitar effect", @"吉他")];
     NSInteger size4_4=[[NSUserDefaults standardUserDefaults] integerForKey:@"Export_4-4"];
    if (size4_4) {
        [_imageSizeButton setTitle:@"1:1" forState:UIControlStateNormal];
    }
    else{
    [_imageSizeButton setTitle:@"4:3" forState:UIControlStateNormal];
    }
    
    
    //[self validateProductIdentifiers];
    // Do any additional setup after loading the view.
}

- (IBAction)changeSound:(UISwitch*)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"PlaySound"];
}
- (IBAction)changeSoundEffect:(UISwitch*)sender {
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"ElecEffect"];
    _guitarEffectSwitch.on=!_electricSoundEffectSwitch.on;
}
- (IBAction)guitarEffect:(UISwitch*)sender {
    [[NSUserDefaults standardUserDefaults] setBool:!sender.on forKey:@"ElecEffect"];
    _electricSoundEffectSwitch.on=!_guitarEffectSwitch.on;

}

- (IBAction)toggleExportImageSize:(id)sender {
    NSInteger size4_4=[[NSUserDefaults standardUserDefaults] integerForKey:@"Export_4-4"];
    if (size4_4) {
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Export_4-4"];
    }
    else{
     [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Export_4-4"];
    }
    
    switch (size4_4) {
        case 0:
            [_imageSizeButton setTitle:@"1:1" forState:UIControlStateNormal];
            break;
            
        case 1:
            [_imageSizeButton setTitle:@"4:3" forState:UIControlStateNormal];
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return YES;
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
