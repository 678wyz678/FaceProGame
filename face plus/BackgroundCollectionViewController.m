//
//  BackgroundCollectionViewController.m
//  face plus
//
//  Created by linxudong on 12/11/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "BackgroundCollectionViewController.h"
#import "DownToUpDelegate.h"
#import "ViewController.h"
#import "BottomPagerController.h"
#import "PackageArray.h"
#import "ViewControllerSource.h"
#import "MyScene.h"
#import "SKSceneCache.h"

static NSIndexPath* selectedGridIndexPath;
@interface BackgroundCollectionViewController ()
@property NSMutableArray* lineArray;
@property NSMutableArray* paintArray;
@property NSMutableArray* starArray;
@property (assign,nonatomic)Byte backgroundState;
@end

@implementation BackgroundCollectionViewController
static NSString * const reuseIdentifier = @"background_cell";

- (void)viewDidLoad {
    [super viewDidLoad];
     self.collectionView.backgroundColor=[UIColor clearColor];
    self.lineArray=[[NSMutableArray alloc]initWithObjects:@"back_dot",@"horizontal_line",@"vertical_line",@"45degree_line",@"135degree_line",@
                    "circle_line",@"radar_line", nil];
    
    self.paintArray=[[NSMutableArray alloc]init];
//    for (int i=1; i<=48; i++) {
//        [_paintArray addObject:[NSString stringWithFormat:@"flag_%d",i]];
//    }
    
    self.starArray=[NSMutableArray arrayWithObjects:@"back_star",@"back_skull",@"back_flower",@"back_hand",@"back_heart",@"back_logo",@"back_smile.png", @"back_ball",nil];

    [self.collectionView setAllowsMultipleSelection:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateSelection];
   
   }


-(void)updateSelection{
    MyScene*scene=[SKSceneCache singleton].scene;

    _backgroundState=scene.backgroundState;
    //有背景图片
    if (32==(_backgroundState&0b00100000)) {
        //        [self removeAllLine];
        //        [self removeGrid];
    }
    //设置grid
     if(16==(_backgroundState&0b00010000)){
        if (selectedGridIndexPath) {
            [self.collectionView selectItemAtIndexPath:selectedGridIndexPath animated:NO scrollPosition:0];
        }
    }
     else{
         if (selectedGridIndexPath) {
             [self.collectionView deselectItemAtIndexPath:selectedGridIndexPath animated:NO];
         }
     }
    //设置线
     if(1==(_backgroundState&0b00000001)){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:NO scrollPosition:0];
    }
     else{
         [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] animated:NO];
     }
    
     if(2==(_backgroundState&0b00000010)){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:NO scrollPosition:0];
    }
     else{
         [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] animated:NO];
     }
     if(4==(_backgroundState&0b00000100)){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO scrollPosition:0];
    }
     else{
         [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] animated:NO];
     }
    
    if(8==(_backgroundState&0b00001000)){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO scrollPosition:0];
    }
    else{
        [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:NO];
    }
     if(64==(_backgroundState&0b01000000)){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:NO scrollPosition:0];
    }
     else{
         [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0] animated:NO];
     }
    
     if(128==(_backgroundState&0b10000000)){
        [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:NO scrollPosition:0];
    }
     else{
         [self.collectionView deselectItemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0] animated:NO];
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger num=0;
    switch (section) {
        case 0:
            num= _lineArray.count+1;
            break;
        
        case 1:
            num= _starArray.count;
            break;
        case 2:
            num= _paintArray.count;
            break;
        default:
            break;
    }
    return num;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    if (((indexPath.row%4==0)||(indexPath.row%4==2))&&((indexPath.row/4)%2==0)) {
        cell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    }
    else if (((indexPath.row%4==0)||(indexPath.row%4==2))&&((indexPath.row/4)%2==1)){
        cell.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05];
    }
    
    else if (((indexPath.row%4==1)||(indexPath.row%4==3))&&((indexPath.row/4)%2==1)){
        cell.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
    }
    else if (((indexPath.row%4==1)||(indexPath.row%4==3))&&((indexPath.row/4)%2==0)){
        cell.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.05];
    }
    
    UIImageView* flagImage=(UIImageView*)[cell viewWithTag:8318];
    NSString* actualName;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            //cell.backgroundColor=[UIColor blueColor];
            flagImage.image=[UIImage imageNamed:@"background_color"];
            return cell;
        }
     else  if (indexPath.row==1) {
            //cell.backgroundColor=[UIColor blueColor];
            flagImage.image=[UIImage imageNamed:@"back_dot_index"];
            return cell;
        }
       actualName=[self.lineArray[indexPath.row-1] stringByReplacingOccurrencesOfString:@".png" withString:@""];
  
      }
    else if (indexPath.section==1){
        actualName=[[self.starArray[indexPath.row] stringByReplacingOccurrencesOfString:@".png" withString:@""] stringByAppendingString:@"_index"];
    }
    else if (indexPath.section==2){
        actualName=[self.paintArray[indexPath.row] stringByReplacingOccurrencesOfString:@".png" withString:@""];
    }
    
    
    NSString*path=  [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
    
    [flagImage setImage:[UIImage imageWithContentsOfFile:path]];
    
    flagImage.layer.cornerRadius=6.0f;
    flagImage.clipsToBounds=YES;
    
    
    return cell;
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

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    DownToUpDelegate* delegate = [DownToUpDelegate singleton];
    ViewController*controller= [delegate viewController];
    
    if(indexPath.section==0) {
        MyScene*scene =  [SKSceneCache singleton].scene;

            if (indexPath.row==0) {
                NSArray* array=@[[controller.pageViewController.source viewControllerAtIndex:102 ]];
                [controller.pageViewController switchPageController:array];
            }
            else  if (indexPath.row==1) {
                NSString *fileName=@"back_dot";
                if (selectedGridIndexPath) {
                    [self.collectionView deselectItemAtIndexPath:selectedGridIndexPath animated:NO];
                }
                selectedGridIndexPath=indexPath;
                [controller.skScene changeBackgroundGridTexture:[SKTexture textureWithImageNamed:fileName]];
            }
      else  if (indexPath.row==2) {
          [scene makeHorizontalLines];
        }
      else  if (indexPath.row==3) {
          [scene makeVerticalLines];
      }
      else  if (indexPath.row==4) {
          [scene make45DLines];
      }
      else  if (indexPath.row==5) {
          [scene make135DLines];
      }
      else  if (indexPath.row==6) {
          [scene makeCircleLine];
      }
      else  if (indexPath.row==7) {
          [scene makeRadioLine];
      }
    }
    else if (indexPath.section==1){
        NSString *fileName=_starArray[indexPath.row];
        if (selectedGridIndexPath) {
            [self.collectionView deselectItemAtIndexPath:selectedGridIndexPath animated:NO];
        }
        selectedGridIndexPath=indexPath;
        
        [controller.skScene changeBackgroundGridTexture:[SKTexture textureWithImageNamed:fileName]];
    }
    else if (indexPath.section==2){
        NSString* actualName=[self.paintArray[indexPath.row] stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSString*path=  [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
        UIImage*background=[UIImage imageWithContentsOfFile:path];
        [controller setBackground: background];
        [controller.skScene setBackgroundState:0b00100000];
    }

    [self updateSelection];
    
    


}

-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    DownToUpDelegate* delegate = [DownToUpDelegate singleton];
    ViewController*controller= [delegate viewController];
    
    if(indexPath.section==0) {
        MyScene*scene =  [SKSceneCache singleton].scene;
        
        if (indexPath.row==0) {
            NSArray* array=@[[controller.pageViewController.source viewControllerAtIndex:102 ]];
            [controller.pageViewController switchPageController:array];
        }
        else  if (indexPath.row==1) {
            [controller.skScene removeGrid];
            if (selectedGridIndexPath) {
                [self.collectionView deselectItemAtIndexPath:selectedGridIndexPath animated:NO];
                selectedGridIndexPath=nil;
            }
        }
        else  if (indexPath.row==2) {
            [scene makeHorizontalLines];
            scene.backgroundState=_backgroundState&0b11110011;
        }
        else  if (indexPath.row==3) {
            [scene makeVerticalLines];
            scene.backgroundState=_backgroundState&0b11110011;

        }
        else  if (indexPath.row==4) {
            [scene make45DLines];
            scene.backgroundState=_backgroundState&0b11111100;
        }
        else  if (indexPath.row==5) {
            [scene make135DLines];
            scene.backgroundState=_backgroundState&0b11111100;
        }
        else  if (indexPath.row==6) {
            [scene makeCircleLine];
            scene.backgroundState=_backgroundState&0b10111111;
        }
        else  if (indexPath.row==7) {
            [scene makeRadioLine];
            scene.backgroundState=_backgroundState&0b01111111;
        }
    }
    else if (indexPath.section==1){
//        NSString *fileName=_starArray[indexPath.row];
//        [controller.skScene changeBackgroundGridTexture:[SKTexture textureWithImageNamed:fileName]];
        [controller.skScene removeGrid];
        if (selectedGridIndexPath) {
            [self.collectionView deselectItemAtIndexPath:selectedGridIndexPath animated:NO];
            selectedGridIndexPath=nil;
        }
        

    }
    else if (indexPath.section==2){
        NSString* actualName=[self.paintArray[indexPath.row] stringByReplacingOccurrencesOfString:@".png" withString:@""];
        NSString*path=  [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"];
        
        UIImage*background=[UIImage imageWithContentsOfFile:path];
        [controller setBackground: background];
        [controller.skScene setBackgroundState:0b00100000];
    }
    [self updateSelection];

}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width=self.collectionView.frame.size.width;
        return CGSizeMake(width/4.0,width/4.0);
        
    
    
}


void setSelectedGridIndexPath(NSIndexPath*indexPath){
    selectedGridIndexPath=indexPath;
}
@end
