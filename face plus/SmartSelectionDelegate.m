//
//  SmartSelectionDelegate.m
//  face plus
//
//  Created by linxudong on 12/28/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "SmartSelectionDelegate.h"
#import "ViewController.h"
#import "BottomPagerController.h"
#import "ViewControllerSource.h"
#import "P_Order.h"
#import "SelectTempNodeObject.h"
@implementation SmartSelectionDelegate



//[arr addObject:MakeWeakReference(obj)];
//id newobj = WeakReferenceNonretainedObjectValue([arr objectAtIndex:0]);

//判断是否包含相同的node
-(void)select:(NSArray*)array{
    

    
    NSMutableArray* realTimeArray=[[NSMutableArray alloc]initWithArray:array];
   [realTimeArray sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"node.selectedPriority" ascending:NO]]];
    

    if (_curSelectionArray==nil) {
        _currentObject=[realTimeArray firstObject] ;
        _curSelectionArray=realTimeArray;
    }
   else if ([_curSelectionArray isEqualToArray:realTimeArray]) {

     NSUInteger indexOfCurrent=  [_curSelectionArray indexOfObject:_currentObject];
       NSUInteger finalIndex=indexOfCurrent+1;
       if (indexOfCurrent==_curSelectionArray.count-1) {
           finalIndex=0;
       }
       
      _currentObject=[_curSelectionArray objectAtIndex:finalIndex];

    }
    
   else{

       _currentObject=[realTimeArray firstObject];

       _curSelectionArray=realTimeArray;
   }
    
    
    
    

    id<P_Order> _currentNodeOfID=(id<P_Order>)_currentObject.node;
    //这个花括号有同步关系，顺序不能点颠倒
    {
    if ([_currentNodeOfID order]==2||[_currentNodeOfID order]==3||[_currentNodeOfID order]==17||[_currentNodeOfID order]==9||[_currentNodeOfID order]==12||[_currentNodeOfID order]==10||[_currentNodeOfID order]==15||[_currentNodeOfID order]==16) {
        [_controller setCurrentNode:_currentNodeOfID];
    }
    
    ////是否换页（）
    if (_controller.ifSlide) {
        NSArray* array=@[[_controller.pageViewController.source viewControllerAtIndex:[_currentNodeOfID order]]];
        //从上至下
        [_controller.pageViewController switchPageController:array];
        
    }//是否换页
    
    }
    
}
@end
