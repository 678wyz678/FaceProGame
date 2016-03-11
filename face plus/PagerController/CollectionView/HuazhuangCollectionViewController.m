//
//  HuazhuangCollectionViewController.m
//  face plus
//
//  Created by linxudong on 15/1/30.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "HuazhuangCollectionViewController.h"
#import "PackageArray.h"
#import "ViewController.h"
#import "OperationStack.h"
#import "UIView+PopAnimation.h"
#import "DownToUpDelegate.h"
#import "PackageArray.h"
#import "DPI300Node.h"
#import "EyelashEntity.h"
#import "EyelidEntity.h"
#import "UnderEyeEntity.h"
#import "EarDecorationEntity.h"
static NSMutableSet* selectedCellIndexPath;
//static NSUInteger normalSectionNum;
//static NSMutableSet* selectedCellIndexPathInNormalPackage;
@interface HuazhuangCollectionViewController ()
@end

@implementation HuazhuangCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (selectedCellIndexPath==nil) {
        selectedCellIndexPath=[NSMutableSet new];
    }
//    if (selectedCellIndexPathInNormalPackage==nil) {
//        selectedCellIndexPathInNormalPackage=[NSMutableSet new];
//    }
    [self.collectionView setAllowsMultipleSelection:YES];
    
  //normalSectionNum=[self.allPackages indexOfObject:self.data];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (selectedCellIndexPath) {
        [selectedCellIndexPath enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
            //NSIndexPath* indexPath=(NSIndexPath*)obj;
            BaseEntity*preEntity=(BaseEntity*)obj;
            NSIndexPath*preIndexPath=[self loopToFindIndexForEntity:preEntity];
            if(preIndexPath){
                [self.collectionView selectItemAtIndexPath:preIndexPath animated:NO scrollPosition:0];
            }
                
        }];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    SKNode*currentNode=[self.focusDelegate.viewController currentNode];
    if ([currentNode isKindOfClass:[DPI300Node class]]&&currentNode.hidden==NO&&selectedCellIndexPath.count>0) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    return YES;
//}


//取消选择
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    PackageArray* currentPackage=self.allPackages[indexPath.section];
    NSLog(@"deselect");

    if (currentPackage.packageNum<=0) {
        ViewController * controller= [self.focusDelegate viewController ];
        OperationStack * stackDelegate=[controller operationStackDelegate];
        BaseEntity* entity;
        PackageArray* array=self.allPackages[indexPath.section];
        entity=[array.packageArray objectAtIndex:indexPath.row];
        
        
        [selectedCellIndexPath removeObject:entity];
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            NSNumber*index=[NSNumber numberWithInteger:indexPath.row];
            NSDictionary* dict=NSDictionaryOfVariableBindings(index);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_CHORD" object:self userInfo:dict];
        });
        
        UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
        
       
        
        UIImageView*imageView= (UIImageView*)[ [datasetCell viewWithTag:4321] viewWithTag:1234];
        
        if ([entity isKindOfClass:[EyelashEntity class]]||[entity isKindOfClass:[UnderEyeEntity class]]||[entity isKindOfClass:[EyelidEntity class]]||[entity isKindOfClass:[EarDecorationEntity class]]) {
            [stackDelegate removeNode:entity];
        }
        else{
            [stackDelegate newOperation:entity];
        }
        [imageView popDown];
    }

   }

//选择
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    PackageArray* currentPackage=self.allPackages[indexPath.section];
    ViewController * controller= [self.focusDelegate viewController ];
    OperationStack * stackDelegate=[controller operationStackDelegate];
    
    PackageArray* tappedArray=self.allPackages[indexPath.section];
   __block BaseEntity*tappedEntity=[tappedArray.packageArray objectAtIndex:indexPath.row];;
    if (currentPackage.packageNum<=0) {

        [selectedCellIndexPath enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {

            BaseEntity* tempEntity;
            tempEntity=(BaseEntity*)obj;

            if ([tappedEntity isKindOfClass:[EyelashEntity class]]||[tappedEntity isKindOfClass:[EyelidEntity class]]||[tappedEntity isKindOfClass:[UnderEyeEntity class]]||[tappedEntity isKindOfClass:[EarDecorationEntity class]]) {
            
            
            if ([tappedEntity isKindOfClass:[tempEntity class]]) {
                NSIndexPath* eyelashIndexPath=[self loopToFindIndexForEntity:tempEntity];
                if (eyelashIndexPath) {
                    [self.collectionView deselectItemAtIndexPath:eyelashIndexPath animated:NO];
                }
                [selectedCellIndexPath removeObject:tempEntity];


            }

         }//end out if
        }];
        
        
        [selectedCellIndexPath addObject:tappedEntity];
     
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end


NSMutableSet* getSelectedIndexPath(){
    if(selectedCellIndexPath==nil){
        selectedCellIndexPath=[NSMutableSet new];
    }
    return selectedCellIndexPath;
}
//nothing


void setSelectedIndexPath(NSMutableSet*set){
   
    selectedCellIndexPath=set;
}
