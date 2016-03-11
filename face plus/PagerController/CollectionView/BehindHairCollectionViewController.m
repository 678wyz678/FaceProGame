//
//  BehindHairCollectionViewController.m
//  face plus
//
//  Created by linxudong on 3/14/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "BehindHairCollectionViewController.h"
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
#import "BehindHairNode.h"
#import "MyCollectionViewCell.h"
static NSMutableSet* selectedCellIndexPathForBehindHair;

@implementation BehindHairCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView setAllowsMultipleSelection:YES];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    if (selectedCellIndexPathForBehindHair) {
        [selectedCellIndexPathForBehindHair enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            
            BaseEntity*preEntity=(BaseEntity*)obj;
            NSIndexPath*preIndexPath=[self loopToFindIndexForEntity:preEntity];
            if(preIndexPath){
                [self.collectionView selectItemAtIndexPath:preIndexPath animated:NO scrollPosition:0];
            }
            
        }];
    }


}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    PackageArray* currentPackage=self.allPackages[indexPath.section];
    ViewController * controller= [self.focusDelegate viewController ];
    OperationStack * stackDelegate=[controller operationStackDelegate];
    
    PackageArray* tappedArray=self.allPackages[indexPath.section];
    __block BaseEntity*tappedEntity=[tappedArray.packageArray objectAtIndex:indexPath.row];;
    if (currentPackage.packageNum<=0) {
        
        
        
        [getSelectedIndexPathForBehindHair() addObject:tappedEntity];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSNumber*index=[NSNumber numberWithInteger:indexPath.row];
            NSDictionary* dict=NSDictionaryOfVariableBindings(index);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_CHORD" object:self userInfo:dict];
        });
        
        UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
        
        
        UIImageView*imageView= (UIImageView*)[ [datasetCell viewWithTag:4321] viewWithTag:1234];
        
        [stackDelegate newOperation:tappedEntity];
        [imageView popDown];
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    SKNode*currentNode=[self.focusDelegate.viewController currentNode];
    if ([currentNode isKindOfClass:[BehindHairNode class]]&&currentNode.hidden==NO&&selectedCellIndexPathForBehindHair.count>0) {
        DPI300Node*tempNode=(DPI300Node*)currentNode;
        
        
        [self.allPackages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //
            PackageArray*package=(PackageArray*)obj;
            NSUInteger indexPathRowInPackageData=  [package.packageArray indexOfObject:tempNode.currentEntity];
            
            
            
            if (indexPathRowInPackageData!=NSNotFound) {
                *stop=YES;
                //idx为sectioNum
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:indexPathRowInPackageData inSection:idx] animated:YES scrollPosition:UICollectionViewScrollPositionTop];
            }
        }];
        
        
    }
}

//取消选择
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    PackageArray* currentPackage=self.allPackages[indexPath.section];
    
    if (currentPackage.packageNum<=0) {
        ViewController * controller= [self.focusDelegate viewController ];
        OperationStack * stackDelegate=[controller operationStackDelegate];
        BaseEntity* entity;
        PackageArray* array=self.allPackages[indexPath.section];
        entity=[array.packageArray objectAtIndex:indexPath.row];
        
        
        [getSelectedIndexPathForBehindHair() removeObject:entity];
        
        
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


NSMutableSet* getSelectedIndexPathForBehindHair(){
    if(selectedCellIndexPathForBehindHair==nil){
        selectedCellIndexPathForBehindHair=[NSMutableSet new];
    }
    return selectedCellIndexPathForBehindHair;
}
//nothing


void setSelectedIndexPathForBehindHair(NSMutableSet*set){
    
    selectedCellIndexPathForBehindHair=set;
}
void resetBehindHairArray(){
    selectedCellIndexPathForBehindHair=nil;
}

@end
