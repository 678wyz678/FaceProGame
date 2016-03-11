//
//  SelectCompareImageDelegate.m
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "SelectCompareImageDelegate.h"
#import "ViewController.h"
#import "SCNavigationController.h"
#import "PostViewController.h"
@interface SelectCompareImageDelegate()
@property UIImagePickerController*imagePicker;
@property SCNavigationController *nav ;
@end

@implementation SelectCompareImageDelegate
-(instancetype)initWithController:(ViewController*)controller{
    if (self=[super init]) {
        _controller=controller;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectImage) name:@"SELECT_NEW_IMAGE" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postImageFromNotification:) name:@"Photo_is_ready" object:nil];
    }
    return self;
}

-(void)selectImage{
    if (!_nav) {
        _nav = [[SCNavigationController alloc] init];

    }
    _nav.scNaigationDelegate = self;
    [_nav showCameraWithParentController:self.controller];
    

}


- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image{
    PostViewController *con = [[PostViewController alloc] init];
    con.postImage = image;
    [navigationController pushViewController:con animated:YES];
}

- (void)showAlbum:(SCNavigationController *)navigationController{
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      picker.allowsEditing = YES;
      picker.delegate = self;
      [self.nav presentViewController:picker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    [self.nav dismissViewControllerAnimated:NO completion:NULL];

    //获得编辑过的图片
    UIImage* image = [info objectForKey: @"UIImagePickerControllerEditedImage"];
    
    PostViewController *con = [[PostViewController alloc] init];
    con.postImage = image;
    [self.nav pushViewController:con animated:YES];
}


//先didTakePicture然后在通过nsnotification回调此方法
-(void)postImageFromNotification:(NSNotification*)sender{
    if (_nav) {
        [_nav dismissViewControllerAnimated:YES completion:^{
            ;
        }];
    }
    if (_controller) {
        
        UIImage * image = [sender.userInfo objectForKey:@"POST_PHOTO"];
        UIView* leftImageViewInViewController=[_controller leftSKView];
        UIImageView* imageView=(UIImageView*)[leftImageViewInViewController viewWithTag:9420];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
      
        [imageView setImage:image];
        [leftImageViewInViewController viewWithTag:62129].hidden=NO;
        [[_controller.leftSKView viewWithTag:4700] removeFromSuperview];
    }
    
    
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
