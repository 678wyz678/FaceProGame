//
//  GalleryCollectionViewController.m
//  face plus
//
//  Created by linxudong on 14/12/5.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "GalleryCollectionViewController.h"
#import "GetListOfFiles.h"
#import "RWImageToFolder.h"
#import "GalleryViewController.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "GlobalNavigationViewController.h"
@interface GalleryCollectionViewController ()
 @property SCLAlertView *alertView;
@end

@implementation GalleryCollectionViewController
{
    NSArray * _fileList;
    int _imageTag;
}
static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    _imageTag=7758;
    [self reloadData];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor=[UIColor whiteColor];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _fileList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallery_cell" forIndexPath:indexPath];
   UIImageView* image=(UIImageView*) [cell viewWithTag:_imageTag];
    [image setImage:[RWImageToFolder readImage:[_fileList objectAtIndex:indexPath.row]]];
    [image setContentMode:UIViewContentModeScaleAspectFill];
    [image setClipsToBounds:YES];
    return cell;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
  //UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    __weak NSArray* weakArray=_fileList;
    __weak GalleryCollectionViewController* weakSelf=self;

    _alertView=[[SCLAlertView alloc] init];
   
    [_alertView addButton:NSLocalizedString(@"Edit", @"加载") actionBlock:^{
            NSString* fileName=  [weakArray objectAtIndex:indexPath.row];
            if (fileName) {
                GlobalNavigationViewController*nav=(GlobalNavigationViewController*)weakSelf.navigationController;
                if (weakSelf.controller_Param) {
                    [nav popViewControllerAnimated:NO];

                    [nav showMainControllerWithSceneName:fileName];

                    
                }
                
                else{
                    NSDictionary*dict=NSDictionaryOfVariableBindings(fileName);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_CURRENT_SCENE" object:weakSelf userInfo:dict];
                    [weakSelf.navigationController popViewControllerAnimated:YES];

                }
               
            }
    } ];
    [_alertView addButton:NSLocalizedString(@"Delete", @"删除")  actionBlock:^{
        [weakSelf removeItemFromCurrentSet:indexPath];
        [weakSelf reloadData];
    } ];
    [_alertView showEdit:self title:@" " subTitle:@" " closeButtonTitle:NSLocalizedString(@"Done",@"奖励标题") duration:0.0f]; // Edit

 
}

-(void)reloadData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* newPath=  [documentsDirectory stringByAppendingPathComponent:@"SavedImages"];
    _fileList=  [GetListOfFiles getListOfFiles :newPath];
    [self.collectionView reloadData];
}

//删除文件夹内缩略图，以及encode
-(void)removeItemFromCurrentSet:(NSIndexPath*)indexPath{
    NSString* fileName=[_fileList objectAtIndex:indexPath.row];
    //删除缩略图
    if (fileName) {
        [RWImageToFolder removeImage:fileName];
    }
    
    // store the array
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *sceneFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
    
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:sceneFile]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:sceneFile error:&error];
        
        if (success) {
            NSArray* firstScreenArray=[[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_SCREEN_STACK"];
            NSMutableArray* tempArray=nil;
            if (firstScreenArray) {
                
                
                tempArray=[NSMutableArray arrayWithArray:firstScreenArray];
                
                [tempArray removeObject:fileName];
                
                
                
                NSArray* finalArray=[NSArray arrayWithArray:tempArray];
                
                [[NSUserDefaults standardUserDefaults] setValue:finalArray forKey:@"FIRST_SCREEN_STACK"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }
      
            
        }
        
        
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }
    }
    
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width=self.collectionView.frame.size.width;
    // Adjust cell size for orientation
    // if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
    return CGSizeMake((width-2)/3.0,(width-2)/3.0);
    //}
    //return CGSizeMake(192.f, 192.f);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //
    //    [self.collectionView layoutIfNeeded];
    //    [self.collectionView performBatchUpdates:nil completion:nil];
    
}

@end
