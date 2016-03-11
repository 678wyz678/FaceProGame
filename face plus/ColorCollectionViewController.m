//
//  ColorCollectionViewController.m
//  face plus
//
//  Created by linxudong on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//


//从rgb转换color
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]


#import "ColorCollectionViewController.h"
#import "DownToUpDelegate.h"
#import "ColorView.h"
#import "UIView+PopAnimation.h"
#import "NKOColorPickerView.h"
#import "ViewController.h"
#import "Color2Image.h"
@interface ColorCollectionViewController ()
@property NSArray* colorArray;
@property NSIndexPath* currentPath;
@end

@implementation ColorCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.colorArray=[[NSMutableArray alloc]init];
    self.colorArray=@[@0xffffff,@0xdcdcdc,@0xbababa,@0xaaaaaa,@0xa9a9a9,@0x878787,@0x555555,@0x222222,
                      @0xffead4,@0xf9dfc2,@0xf4cea8,@0xefbb8b,@0xe8a370,@0xbc7a2a,@0xa55f20,@0x834f1a,
                      @0xffded7,@0xf9cdc2,@0xf4b3a6,@0xea9c8f,@0xdd8c80,@0xdb7b71,@0xd87068,@0xc9726b,
                      @0xdac4aa,@0xcab398,@0xbb9180,@0x987d64,@0x7d614e,@0x5b4135,@0x571d00,@0x480600,
                      @0xc15115,@0xff9500,@0xffcd02,@0xe0f808,@0xffd3e0,@0xe28865,@0xff4981,@0xd50053,
                      @0x5b6e63,@0x187972,@0x324681,@0x8e60a6,@0xdff7d7,@0x52ecc6,@0x1ad5fc,@0x1d62ef];
    
    self.collectionView.backgroundColor=[UIColor clearColor];
    
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSNumber* ENABLED=[NSNumber numberWithBool:NO];
    NSDictionary*dict=NSDictionaryOfVariableBindings(ENABLED);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_PAGE_CONTROLLER_ENABLED" object:self userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_BOTTOM_VIEW_DRAGGED_ENABLED" object:self userInfo:dict];
}

-(void)viewWillDisappear:(BOOL)animated{
    
        [super viewWillDisappear:animated];
        NSNumber* ENABLED=[NSNumber numberWithBool:YES];
        NSDictionary*dict=NSDictionaryOfVariableBindings(ENABLED);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_PAGE_CONTROLLER_ENABLED" object:self userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"SET_BOTTOM_VIEW_DRAGGED_ENABLED" object:self userInfo:dict];
    
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
    return 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section==0) {
        return self.colorArray.count;

    }
    else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section==0){
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"color_cell" forIndexPath:indexPath];
    UIView* wrapper=(UIView*)[cell viewWithTag:1035];
   
        NSInteger hex=((NSNumber*)([self.colorArray objectAtIndex:indexPath.row])).integerValue;
        wrapper.backgroundColor=(UIColor*)UIColorFromRGB(hex);
   
        
    
        return cell; }
    
    //如果是section＝1
    else{
     UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"color_map" forIndexPath:indexPath];
        
        NKOColorPickerDidChangeColorBlock colorDidChangeBlock;
        
        if (_ifChangeColorForBackground) {
            colorDidChangeBlock = ^(UIColor *color){
                DownToUpDelegate* delegate=   [DownToUpDelegate singleton];
                ViewController*controller= [delegate viewController];
                controller.view.layer.contents = (id)[Color2Image imageWithColor:color].CGImage;
            };

            
        }
        
        else if(_delegate.viewController.inModeOfBackgroundGrid){
            colorDidChangeBlock = ^(UIColor *color){
                [self.delegate changeColorForBackgroundGrid:color];
            };
        }
        else{
            colorDidChangeBlock = ^(UIColor *color){
                DownToUpDelegate* delegate=   [DownToUpDelegate singleton];
                [delegate changeColor:color];
            };

        }
        
        
        NKOColorPickerView *colorPickerView = ((NKOColorPickerView*)[cell viewWithTag:4831] );
        colorPickerView.didChangeColorBlock=colorDidChangeBlock;
        return cell;
    }

}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    NSInteger hex=((NSNumber*)([self.colorArray objectAtIndex:indexPath.row])).integerValue;
    UIColor * targetColor=UIColorFromRGB(hex);
    DownToUpDelegate* delegate = [DownToUpDelegate singleton];
    ViewController*controller= [delegate viewController];

    //纯色背景色
    if (_ifChangeColorForBackground) {
        
        //if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            UIImage*Background=[Color2Image imageWithColor:targetColor];
            [controller setBackground:Background];
        //}
    }
    
    //更换背景五角星纹理
    else if (controller.inModeOfBackgroundGrid){
        [self.delegate changeColorForBackgroundGrid:targetColor];
    }
    else{
        [self.delegate changeColor:targetColor];
    }
    ColorView* wrapper=(ColorView*)[[collectionView cellForItemAtIndexPath:indexPath] viewWithTag:1035];
    wrapper.layer.borderWidth=3.0;
    wrapper.layer.borderColor=[UIColor whiteColor].CGColor;
    
    
    
    [wrapper popDown];
    ColorView* wrapperBefore=(ColorView*)[[collectionView cellForItemAtIndexPath:_currentPath] viewWithTag:1035];
    wrapperBefore.layer.borderWidth=0;
    //wrapperBefore.layer.borderColor=[UIColor whiteColor].CGColor;
    
//设置当前的path
    _currentPath=indexPath;

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



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CGFloat width=self.collectionView.frame.size.width;
    if (indexPath.section==0) {
        CGFloat actualWidth=width-8*7-20;
        return CGSizeMake(actualWidth/8.0,actualWidth/8.0);

    }
    else{
        return CGSizeMake(width,width/2.0);

    }
   
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //
    //    [self.collectionView layoutIfNeeded];
    //    [self.collectionView performBatchUpdates:nil completion:nil];
    
}




@end
