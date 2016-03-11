//
//  MyCollectionViewController.m
//  CollectionViewTest
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Ferrum. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "BaseEntity.h"
#import "ImportAllEntity.h"
#import "RemovePostFix.h"
#import "GlobalVariable.h"
#import "DownToUpDelegate.h"
#import "ViewController.h"
#import "OperationStack.h"
#import "PackageArray.h"
#import "UIView+PopAnimation.h"
#import "PackageCellButton.h"
#import "MyCollectionViewCell.h"
#import "HuazhuangCollectionViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#import "MyCollectionViewLayout.h"
static NSMutableDictionary* currentIndexPathDictionary;
//static NSMutableDictionary* normalPackageSectionPosition;
@interface MyCollectionViewController ()

@property(assign,nonatomic)BOOL isLoaded;

@property UIView* parentScollView;
@property MyCollectionViewLayout*layout;
//包含了排好序的所有包（常规包/加装包）

@property NSTimer*timer;
@end

@implementation MyCollectionViewController

//在viewdidload中对所有常规包和加装包
- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor=[UIColor clearColor];
    self.view.tag=self.index;
    
    //排序
    NSMutableArray*tempArrayForAll=[NSMutableArray arrayWithArray:_packageData];
    [tempArrayForAll addObject:self.data];
    
    _allPackages= [tempArrayForAll sortedArrayUsingSelector:@selector(compare:)];


    
    if (!currentIndexPathDictionary) {
        currentIndexPathDictionary=[NSMutableDictionary new];
    }
    
    [self.collectionView setCollectionViewLayout:[[MyCollectionViewLayout alloc] init]];
    
    
   self.timer = [NSTimer timerWithTimeInterval:3 target:self.collectionView selector:@selector(flashScrollIndicators) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    // Do any additional setup after loading the view.
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.timer.isValid) {
        [self.timer invalidate];
    }
}
-(void)dealloc{
    [self.timer invalidate];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}



-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

    if (![self isKindOfClass:[HuazhuangCollectionViewController class]]) {
        BaseEntity* entity=[currentIndexPathDictionary objectForKey:[NSNumber numberWithUnsignedInteger:self.index]];

      NSIndexPath*indexPath = [self loopToFindIndexForEntity:entity];
        if (indexPath) {
            [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
        }
    }
}


-(NSIndexPath*)loopToFindIndexForEntity:(BaseEntity*)entity{
    
    __block NSIndexPath* indexPath=nil;
[self.allPackages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    PackageArray* packageArray=(PackageArray*)obj;
    NSUInteger row=[packageArray.packageArray indexOfObject:entity];
    if (row!=NSNotFound) {
        *stop=YES;
        indexPath=[NSIndexPath indexPathForRow:row inSection:idx];
    }
}];
    
    return indexPath;

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
    
    return [_allPackages count] ;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    PackageArray* packageAtIndex=_allPackages[section];
    return packageAtIndex.packageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PackageArray* currentPackage=_allPackages[indexPath.section];

    MyCollectionViewCell *cell;
    if (currentPackage.packageNum<=0) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cjx" forIndexPath:indexPath];
    }
    else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"package_cell" forIndexPath:indexPath];
    }
 
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
    
    
    BaseEntity*entity=((BaseEntity*) currentPackage.packageArray[indexPath.row]);
    NSString*   name =entity.indexFileName;
    NSString* actualName=[name stringByReplacingOccurrencesOfString:@".png" withString:@""];
    NSString*path= entity.updatedForFreeIndexFileName==nil? [[NSBundle mainBundle] pathForResource:actualName ofType:@"png"]:entity.updatedForFreeIndexFileName;
    
    
    if (currentPackage.packageNum<=0) {
        UIImageView*imageView= (UIImageView*)[ [cell viewWithTag:4321] viewWithTag:1234];
        imageView.image=[UIImage imageWithContentsOfFile:path];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        cell.entityForCell=currentPackage.packageArray[indexPath.row];
    }
    
    else{
        

        
        PackageCellButton * button=(PackageCellButton*) [cell viewWithTag:8390];

        PackageArray* array=self.allPackages[indexPath.section];
        BaseEntity*  entity=[array.packageArray objectAtIndex:indexPath.row];
        button.entity=entity;
        [button setImage:[UIImage imageWithContentsOfFile:path] forState:UIControlStateNormal];
        [button.imageView setContentMode:UIViewContentModeScaleAspectFit];
      }
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
 //   NSArray * selectedIndexPathArray = self.collectionView.indexPathsForSelectedItems;
    
    PackageArray* currentPackage=_allPackages[indexPath.section];
    ViewController * controller= [self.focusDelegate viewController ];
    OperationStack * stackDelegate=[controller operationStackDelegate];
    //NSUInteger normalPackagePosition=((NSNumber*)([normalPackageSectionPosition objectForKey:[NSNumber numberWithUnsignedInteger:self.index]])).unsignedIntegerValue;

    if (currentPackage.packageNum<=0) {
        BaseEntity* entity;
        
        PackageArray* array=self.allPackages[indexPath.section];
        entity=[array.packageArray objectAtIndex:indexPath.row];

      // NSIndexPath*currentIndexPath =[currentIndexPathDictionary objectForKey:[NSNumber numberWithUnsignedInteger:self.index]];
       BaseEntity*preEntity=[currentIndexPathDictionary objectForKey:[NSNumber numberWithUnsignedInteger:self.index]];
        
        if ([preEntity isEqual:entity]) {
            //选择的是同一个素材，取消选中，并且删除
            [stackDelegate removeNode:entity];
            [currentIndexPathDictionary removeObjectForKey:[NSNumber numberWithUnsignedInteger:self.index]];
            [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
            return;
        }
        
        //设置当前indexpath
        [currentIndexPathDictionary setObject:entity forKey:[NSNumber numberWithUnsignedInteger:self.index]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSNumber*index=[NSNumber numberWithInteger:indexPath.row];
            NSDictionary* dict=NSDictionaryOfVariableBindings(index);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_CHORD" object:self userInfo:dict];
        });
    
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];


         UIImageView*imageView= (UIImageView*)[ [datasetCell viewWithTag:4321] viewWithTag:1234];
    
    [stackDelegate newOperation:entity];
        [imageView popDown];
    }
}



-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {

}

// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
//	return YES;
//}
//
//- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	return NO;
//}
//
//- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
//	
//}


-(CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    CGFloat width=self.collectionView.frame.size.width;
    // Adjust cell size for orientation
   // if (UIDeviceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return CGSizeMake(width/4.0,width/4.0);
    //}
    //return CGSizeMake(192.f, 192.f);
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
   
    
}




NSMutableDictionary* getDictionaryOfIndexPath(){
    if (currentIndexPathDictionary==nil) {
        currentIndexPathDictionary=[NSMutableDictionary new];
    }
    
    return currentIndexPathDictionary;
}


void setDictionaryOfIndexPath(NSMutableDictionary* indexPathDict){
    
    
    currentIndexPathDictionary=indexPathDict;
}


@end
