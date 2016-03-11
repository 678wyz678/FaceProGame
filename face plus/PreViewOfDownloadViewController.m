//
//  PreViewOfDownloadViewController.m
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "PreViewOfDownloadViewController.h"
#import "CreateDirIfNotExist.h"
#import "RWImageToFolder.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "Color2Image.h"
@interface PreViewOfDownloadViewController ()

@end

@implementation PreViewOfDownloadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.previewImageView setImage:self.controller_Param];
    NSArray* rgbColor=[Color2Image getRGBAsFromImage:_controller_Param atX:1 andY:1 count:1];
    self.view.layer.contents=(id)([Color2Image imageWithColor:rgbColor[0]].CGImage);
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)save{
//    CGSize SCREEN_SIZE=[UIScreen mainScreen].bounds.size;
//    
//    CGSize documentPhotoSize=CGSizeMake(SCREEN_SIZE.width*0.33, SCREEN_SIZE.width*4*0.33/3.0);
//    //开始合成图片(document内)
//    UIGraphicsBeginImageContext(documentPhotoSize);
//    [_controller_Param drawInRect:CGRectMake(0,0,documentPhotoSize.width, documentPhotoSize.height)];
//    UIImage*documentImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    
//    [CreateDirIfNotExist createDirIfNotExist:@"SavedImages"];
//    NSString* fileName=[RWImageToFolder save:documentImage];
//    
//    
//    UIImageWriteToSavedPhotosAlbum(_controller_Param, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    // store the array
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"incompletedWorks.txt"];
//    
//    NSMutableDictionary*dictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile] ;
//    if (!dictionary) {
//        dictionary=[NSMutableDictionary dictionary];
//    }
//    [dictionary setValue:[SKSceneCache singleton].scene forKey:fileName];
//    
//    [NSKeyedArchiver archiveRootObject:dictionary toFile:appFile];
//    
    
    
    
}

- (IBAction)saveBtnAction:(id)sender {
    [self save];
}

- (IBAction)reverseImageAction:(id)sender {
    [self PictureFlipe];
}


-(void)setController_Param:(UIImage *)controller_Param{
    _controller_Param=controller_Param;
    [self.previewImageView setImage:controller_Param];

}
//如果是前置摄像头就反转
- (void )PictureFlipe
{
    UIImageOrientation orientation=UIImageOrientationUp;
    if (_controller_Param.imageOrientation==UIImageOrientationUp) {
        orientation=UIImageOrientationUpMirrored;
    }
    UIImage * flippedImage = [UIImage imageWithCGImage:_controller_Param.CGImage scale:_controller_Param.scale orientation:orientation];
    [self setController_Param:flippedImage];
    
}

-(BOOL)prefersStatusBarHidden{

    return YES;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    if (error == nil)
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"This picture has been saved to your photo album.Picture Saved!" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"Please try it again later.Saving Failed" delegate:nil cancelButtonTitle:@"OK." otherButtonTitles:nil];
        [alert show];
    }
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
