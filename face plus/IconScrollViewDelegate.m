//
//  IconScrollViewDelegate.m
//  face plus
//
//  Created by linxudong on 12/29/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "IconScrollViewDelegate.h"
static CGFloat marginPlusWidthOfIcon=0;
@implementation IconScrollViewDelegate

{
    BOOL shouldPostNotificationAfterDragging;//因为摇一摇点击按钮后不需要刷新pagecontroller，所以设置一个flag
}

-(instancetype)init{
    if (self=[super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startShakeMode) name:@"RESET_ICONBUTTON" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endShakeMode) name:@"QUIT_SHAKE" object:nil];
        shouldPostNotificationAfterDragging=YES;
    }
    return self;
}

-(void)startShakeMode{
    
    shouldPostNotificationAfterDragging=NO;
}
-(void)endShakeMode{
    shouldPostNotificationAfterDragging=YES;
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self launchNotification:scrollView];
   }
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        
        [self launchNotification:scrollView];


    }
}

-(void)launchNotification:(UIScrollView*)scrollView{
    if (marginPlusWidthOfIcon==0) {
        marginPlusWidthOfIcon=40*0.818+([UIScreen mainScreen].bounds.size.width-100-40*0.818*5)/5;
    }
    CGFloat offsetX= scrollView.contentOffset.x;
    CGFloat nearestIndex = offsetX/marginPlusWidthOfIcon;
    NSLog(@"nearestIndex:%f",nearestIndex);
    if (nearestIndex-((int)nearestIndex)>0.5) {
        nearestIndex++;
    }
    
    NSNumber* POSITION=[NSNumber numberWithInteger:((int)nearestIndex)];
    NSDictionary* dict=NSDictionaryOfVariableBindings(POSITION);
    if (shouldPostNotificationAfterDragging) {
         [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_LOCATION_OF_SCROLLVIEW" object:self userInfo:dict];
    }
   
    
}
@end
