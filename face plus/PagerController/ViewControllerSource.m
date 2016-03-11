//
//  ViewControllerSource.m
//  face plus
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ViewControllerSource.h"
#import "FeatureArray.h"
#import "HuazhuangCollectionViewController.h"
#import "DownToUpDelegate.h"
#import "ColorCollectionViewController.h"
#import "ShakeCollectionViewController.h"
#import "BackgroundCollectionViewController.h"
#import "FontController.h"
#import "ExtendPackageDelegate.h"
#import "PackageArray.h"
#import "FeaturePackageArray.h"
#import "DownToUpDelegate.h"
#import "OperationStack.h"
#import "ShakeOption.h"
#import "ImportAllEntity.h"
#import "ViewController.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "BehindHairCollectionViewController.h"
#import "FrontHairCollectionViewController.h"

static NSMutableDictionary* staticPageData;



//摇一摇控制
static int i;

@interface ViewControllerSource()
@property ExtendPackageDelegate* packageDelegate;
@property NSMutableDictionary* PackageData;
@end

@implementation ViewControllerSource

- (instancetype)init {
    self = [super init];
    if (self) {
        // Create the data model.
        _pageData =[[NSMutableDictionary alloc]init];
        [_pageData setObject:[FeatureArray singleton].faceArray forKey:@0];
        [_pageData setObject:[FeatureArray singleton].hairArray forKey:@1];
        [_pageData setObject:[FeatureArray singleton].frontHairArray forKey:@2];
        [_pageData setObject:[FeatureArray singleton].behindHairArray forKey:@3];
        [_pageData setObject:[FeatureArray singleton].eyeArray forKey:@4];
        [_pageData setObject:[FeatureArray singleton].eyeballArray forKey:@5];
        [_pageData setObject:[FeatureArray singleton].browArray forKey:@6];
        [_pageData setObject:[FeatureArray singleton].noseArray forKey:@7];
        [_pageData setObject:[FeatureArray singleton].mouthArray forKey:@8];
        [_pageData setObject:[FeatureArray singleton].beardArray forKey:@9];
        [_pageData setObject:[FeatureArray singleton].whiskerArray forKey:@10];
        [_pageData setObject:[FeatureArray singleton].earArray forKey:@11];
        [_pageData setObject:[FeatureArray singleton].whelkArray forKey:@12];
        [_pageData setObject:[FeatureArray singleton].glassArray forKey:@13];
        [_pageData setObject:[FeatureArray singleton].capArray forKey:@14];
        [_pageData setObject:[FeatureArray singleton].neckArray forKey:@15];
        [_pageData setObject:[FeatureArray singleton].backgroundArray forKey:@16];
        [_pageData setObject:[FeatureArray singleton].fontArray forKey:@17];
        staticPageData=_pageData;
        self.packageDelegate=[ExtendPackageDelegate singleton];
        self.packageDelegate.viewControllerSource=self;
        [self initPackageDictionary];
        i=0;
       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RandomBroadcast:) name:@"RandomBroadcast" object:nil];
        
    }
    return self;
}


-(void)initPackageDictionary{
    _PackageData =[[NSMutableDictionary alloc]init];
    [_PackageData setObject:[FeaturePackageArray singleton].faceArray forKey:@0];
    [_PackageData setObject:[FeaturePackageArray singleton].hairArray forKey:@1];
    [_PackageData setObject:[FeaturePackageArray singleton].frontHairArray forKey:@2];
    [_PackageData setObject:[FeaturePackageArray singleton].behindHairArray forKey:@3];
    [_PackageData setObject:[FeaturePackageArray singleton].eyeArray forKey:@4];
    [_PackageData setObject:[FeaturePackageArray singleton].eyeballArray forKey:@5];
    [_PackageData setObject:[FeaturePackageArray singleton].browArray forKey:@6];
    [_PackageData setObject:[FeaturePackageArray singleton].noseArray forKey:@7];
    [_PackageData setObject:[FeaturePackageArray singleton].mouthArray forKey:@8];
    [_PackageData setObject:[FeaturePackageArray singleton].beardArray forKey:@9];
    [_PackageData setObject:[FeaturePackageArray singleton].whiskerArray forKey:@10];
    [_PackageData setObject:[FeaturePackageArray singleton].earArray forKey:@11];
    [_PackageData setObject:[FeaturePackageArray singleton].whelkArray forKey:@12];
    [_PackageData setObject:[FeaturePackageArray singleton].glassArray forKey:@13];
    [_PackageData setObject:[FeaturePackageArray singleton].capArray forKey:@14];
    [_PackageData setObject:[FeaturePackageArray singleton].neckArray forKey:@15];
    [_PackageData setObject:[FeaturePackageArray singleton].fontArray forKey:@17];


}
NSMutableDictionary* getPageData(){
    return staticPageData;
}

-(void)RandomBroadcast:(NSNotification*)sender{
    

    

    
        NSUInteger index=((NSNumber*)[sender.userInfo objectForKey:@"index"]).unsignedIntegerValue;
        
        if (index==16) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RANDOM_BACKGROUND" object:self];
            //随即更改所有器官颜色
            [[NSNotificationCenter defaultCenter] postNotificationName:@"RANDOM_ALL_COLOR" object:self];

            return;
        }
        if(index==17){
            return;
        }
        
        if (index<_pageData.count) {
            NSArray* array=[self.pageData objectForKey:[NSNumber numberWithUnsignedInteger:index]];//取出对应素材类型的所有素材的数组
            NSInteger randomIndex = arc4random() % [array count];
            BaseEntity*entity=[array objectAtIndex:randomIndex];
            if (index!=12&&index!=2&&index!=3&&index<=16) {
                NSMutableDictionary*indexPathDictionary =  getDictionaryOfIndexPath();
                
                if (indexPathDictionary==nil) {
                    

                    return;
                }
                else{
                    
                    BaseEntity*preEntity=[indexPathDictionary objectForKey:[NSNumber numberWithUnsignedInteger:index]];
                    OperationStack * stackDelegate=[DownToUpDelegate singleton].viewController.operationStackDelegate;
                    
                    if (![entity isEqual:preEntity]) {
                        //说明不是同一个素材，直接切换current index 并且new operation
                        //999说明时摇一摇出来的
                        [indexPathDictionary setObject:entity forKey:[NSNumber numberWithUnsignedInteger:index]];
                        [stackDelegate newOperation:entity];
                        
                    }
                    else{
                        //表明按了同一个素材,删除当前currentIndexPath，并且removenode
                        [stackDelegate removeNode:entity];
                        [indexPathDictionary removeObjectForKey:[NSNumber numberWithUnsignedInteger:index]];
                        return;
                    }
                    
                }
            }//end if (index<=16)
            
            else if(index==2){
            
                
                OperationStack * stackDelegate=[DownToUpDelegate singleton].viewController.operationStackDelegate;
                NSMutableSet* selectedCellIndexPath=getSelectedIndexPathForFrontHair();
                //如果已经有10个配件则不再往上添加
                
                [selectedCellIndexPath enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                    
                    
                    BaseEntity* useLessEntity=(BaseEntity*)obj  ;
                    [selectedCellIndexPath removeObject:useLessEntity];
                    
                        [stackDelegate newOperation:useLessEntity];
                    
                }];
                
                [[SKSceneCache singleton].scene removeAllRecordOfFrontHair];
                
                setSelectedIndexPathForFrontHair([NSMutableSet new]);
                selectedCellIndexPath=getSelectedIndexPathForFrontHair();
                
                NSArray* array=[getPageData() objectForKey:[NSNumber numberWithUnsignedInteger:2]];//取出对应素材类型的所有素材的数组
                //////////loop 5 times start
                
                    NSInteger randomTemp = arc4random() % [array count];
                    BaseEntity * randomEntity=[array objectAtIndex:randomTemp];
                    
                    [selectedCellIndexPath addObject:randomEntity];
                    [stackDelegate newOperation:randomEntity];
                
            }
            
            else if(index==3){
                
                
                OperationStack * stackDelegate=[DownToUpDelegate singleton].viewController.operationStackDelegate;
                NSMutableSet* selectedCellIndexPath=getSelectedIndexPathForBehindHair();
                //如果已经有10个配件则不再往上添加
                
                [selectedCellIndexPath enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                    
                    
                    BaseEntity* useLessEntity=(BaseEntity*)obj  ;
                    [selectedCellIndexPath removeObject:useLessEntity];
                    
                    [stackDelegate newOperation:useLessEntity];
                    
                }];
                
                [[SKSceneCache singleton].scene removeAllRecordOfBehindHair];
                
                setSelectedIndexPathForBehindHair([NSMutableSet new]);
                selectedCellIndexPath=getSelectedIndexPathForBehindHair();
                
                NSArray* array=[getPageData() objectForKey:[NSNumber numberWithUnsignedInteger:3]];//取出对应素材类型的所有素材的数组
                //////////loop 5 times start
                
                NSInteger randomTemp = arc4random() % [array count];
                BaseEntity * randomEntity=[array objectAtIndex:randomTemp];
                
                [selectedCellIndexPath addObject:randomEntity];
                [stackDelegate newOperation:randomEntity];
                
            }
            
            else if (index==12){
                
                
                OperationStack * stackDelegate=[DownToUpDelegate singleton].viewController.operationStackDelegate;
                NSMutableSet* selectedCellIndexPath=getSelectedIndexPath();
                //如果已经有10个配件则不再往上添加
                
                [selectedCellIndexPath enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {

                    
                    BaseEntity* useLessEntity=(BaseEntity*)obj  ;
                    [selectedCellIndexPath removeObject:useLessEntity];

                    if ([useLessEntity isKindOfClass:[EyelashEntity class]]||[useLessEntity isKindOfClass:[UnderEyeEntity class]]||[useLessEntity isKindOfClass:[EyelidEntity class]]||[useLessEntity isKindOfClass:[EarDecorationEntity class]]) {
                        //肯定是是同一个indexpath  删除node并且 remove indexpath
                        [stackDelegate removeNode:useLessEntity];
                    }//end out if
                    
                    else{
                        [stackDelegate newOperation:useLessEntity];
                    }
                    
                }];
                
                [[SKSceneCache singleton].scene removeAllRecord];
                
                setSelectedIndexPath([NSMutableSet new]);
                selectedCellIndexPath=getSelectedIndexPath();
                
                NSArray* array=[getPageData() objectForKey:[NSNumber numberWithUnsignedInteger:12]];//取出对应素材类型的所有素材的数组
                //////////loop 5 times start
                for (int i=0; i<=4; i++) {
                    
                    
                    NSInteger randomTemp = arc4random() % [array count];
                    BaseEntity * randomEntity=[array objectAtIndex:randomTemp];
                    
                    [selectedCellIndexPath addObject:randomEntity];
                    [stackDelegate newOperation:randomEntity];
                }
                
            }
        }
        

   

    
    
    
    
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    //主storyboard
    UIStoryboard*storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //other storyboard
    UIStoryboard*otherStoryBoard=[UIStoryboard storyboardWithName:@"Other" bundle:nil];

    // Return the data view controller for the given index.
    if (index==100) {
        ColorCollectionViewController* controller=[storyboard  instantiateViewControllerWithIdentifier:@"ColorCollectionView"];
        controller.delegate=[DownToUpDelegate singleton];
        controller.index=index;
        return  controller;
    }
    
   else if (index==102) {
        ColorCollectionViewController* controller=[storyboard  instantiateViewControllerWithIdentifier:@"ColorCollectionView"];
        controller.delegate=[DownToUpDelegate singleton];
       controller.ifChangeColorForBackground=true;
        controller.index=index;
        return  controller;
    }
    else if (index==200){
        ShakeCollectionViewController* controller=[storyboard instantiateViewControllerWithIdentifier:@"shake_collection"];
        controller.index=index;
        return  controller;
    }
    else if (index==16){
        BackgroundCollectionViewController* controller=[storyboard instantiateViewControllerWithIdentifier:@"background_collection"];
        controller.index=index;
        controller.data=[[PackageArray alloc]initWithPackageNum:0] ;
        controller.data.packageArray=[self.pageData objectForKey:[[NSNumber alloc]initWithUnsignedInteger:index]];

        return  controller;
    }
    else if (index==17){
        FontController* controller=[otherStoryBoard instantiateViewControllerWithIdentifier:@"FONT_CONTROLLER"];
        controller.index=index;
        return  controller;
    }
   else if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }
    
    
    // Create a new view controller and pass suitable data.
    MyCollectionViewController *dataViewController  = [storyboard  instantiateViewControllerWithIdentifier:@"MyCollectionView"];
;
    
    switch (index) {
   
        
            case 12:
            //不要在转动后setCurrentNode,因为是多元素的库
            dataViewController=[storyboard  instantiateViewControllerWithIdentifier:@"HuazhuangCollectionView"];
            dataViewController.notSetCurrentNodeAfterViewAppear=YES;
            break;
            case 2:
            //不要在转动后setCurrentNode,因为是多元素的库
            dataViewController=[storyboard  instantiateViewControllerWithIdentifier:@"FrontHairCollectionView"];
           // dataViewController.notSetCurrentNodeAfterViewAppear=YES;
            break;
            case 3:
            //不要在转动后setCurrentNode,因为是多元素的库
            dataViewController=[storyboard  instantiateViewControllerWithIdentifier:@"BehindHairCollectionView"];
         //   dataViewController.notSetCurrentNodeAfterViewAppear=YES;
            break;

            
//            case 9:
//            dataViewController.notSetCurrentNodeAfterViewAppear=YES;
//            break;
//            case 10:
//            dataViewController.notSetCurrentNodeAfterViewAppear=YES;
//            break;
//            case 15:
//            dataViewController.notSetCurrentNodeAfterViewAppear=YES;
//            break;
            default:
            break;
        
    }
    dataViewController.index=index;
     //加装包
   dataViewController.packageData=[self.PackageData objectForKey:[[NSNumber alloc]initWithUnsignedInteger:index]];
    
    //普通包
    dataViewController.data=[[PackageArray alloc]initWithPackageNum:0];
    dataViewController.data.packageArray=[self.pageData objectForKey:[[NSNumber alloc]initWithUnsignedInteger:index]];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(MyCollectionViewController *)viewController {
    // Return the index of the given data view controller.
    // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return viewController.index;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(MyCollectionViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    if (index==0) {
        NSUInteger max=[self.pageData count]-1;
        return [self viewControllerAtIndex:max];
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(MyCollectionViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return [self viewControllerAtIndex:0 ];
    }
       return [self viewControllerAtIndex:index ];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



-(NSUInteger)calculateNormalPackagePositionNum:(NSUInteger)index{
    //排序
    NSMutableArray*tempArrayForAll=[NSMutableArray arrayWithArray:[self.PackageData objectForKey:[[NSNumber alloc]initWithUnsignedInteger:index]]];
    PackageArray*normalPackage=[[PackageArray alloc]initWithPackageNum:0];
    normalPackage.packageArray=[self.pageData objectForKey:[NSNumber numberWithUnsignedInteger:index]];
    [tempArrayForAll addObject:normalPackage];
    
    NSArray* allPackages= [tempArrayForAll sortedArrayUsingSelector:@selector(compare:)];
   return  [allPackages indexOfObject:normalPackage];
}
@end
