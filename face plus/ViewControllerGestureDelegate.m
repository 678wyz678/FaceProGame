//
//  ViewControllerGestureDelegate.m
//  face plus
//
//  Created by linxudong on 1/14/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ViewControllerGestureDelegate.h"
#import "SyncDragPanGestureRecognizer.h"
#import "ViewController.h"
#import <FXBlurView.h>
#import "PLUS_SKView.h"
#import "DPI300Node.h"
#import "P_Rotate.h"
#import "P_Zoom.h"
#import "P_SyncRotate.h"
#import "P_Dragable.h"
#import "SmartSelectionDelegate.h"
#import "MyScene.h"
#import "FontNode.h"
#import "BottomPagerController.h"
#import "ViewControllerSource.h"
#import "P_SyncDrag.h"
#import "P_SyncRotate.h"
#import "SKSceneCache.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "EyeLeftNode.h"
#import "SelectTempNodeObject.h"
@implementation ViewControllerGestureDelegate

-(instancetype)initWithController:(ViewController*)controller{
    if (self=[super init]) {
        _controller=controller;
    }
    return self;
}

//////uigesture Part///
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    //去除guideview
    if([_controller.blurview viewWithTag:56823])
    {
        _controller.alertView=[[SCLAlertView alloc]init];
        [_controller.alertView addButton:NSLocalizedString(@"Leave", @"离开")  actionBlock:^{
            UIView*guideView=   [_controller.blurview viewWithTag:56823];
            [UIView animateWithDuration:0.8 animations:^{
                guideView.alpha=0.f;
            } completion:^(BOOL finished) {
                [guideView removeFromSuperview];
            }];
        }];
       
        [_controller.alertView showWarning:_controller title:NSLocalizedString(@"Leave tutorial?", @"离开教程?") subTitle:@"" closeButtonTitle:NSLocalizedString(@"NO",@"不") duration:0.f];
        
        return NO;
    }
    
    if ([gestureRecognizer.view isKindOfClass:[PLUS_SKView class]]) {
        [_controller.skView setFastFrameRate];
    }
    
    if ([gestureRecognizer isKindOfClass:[SyncDragPanGestureRecognizer class]]) {
        UIPanGestureRecognizer* gesture=(UIPanGestureRecognizer*)gestureRecognizer;
        if (ABS([gesture translationInView:_controller.view].y)>ABS(5*[gesture translationInView:_controller.view].x)) {
            _controller.isSyncDragNotRotate=NO;
            
        }
        else{
            _controller.isSyncDragNotRotate=YES;
        }
    }
    
    
    
    //当手势在skview中时，触发备份当前信息
    if ([gestureRecognizer.view isKindOfClass:[PLUS_SKView class]]) {
        SKView* skView=(SKView*)(gestureRecognizer.view);
        [self backupState:skView.scene];
        [self.controller setNeedSave:YES];
    }
    
    else if(gestureRecognizer.view.tag==1314521)//判断是否是blurview
    {
        _controller.bottomViewCurrentHeight=_controller.blurview.frame.size.height;
    }
    
    
    [_controller.skScene backupGridState];
    
    //此处通知所有难以直接用delegate通知的部门
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"START_GESTURE" object:self];
    EyeLeftNode*eyeLeft=(EyeLeftNode*)( [[_controller.skScene childNodeWithName:faceLayerName] childNodeWithName:eyeLeftLayerName]);
    [eyeLeft backUpEyeBallPosition];
    
    
    return YES;
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO;
}


-(void)backupState:(SKNode*)node{
    
    NSArray* children=[node children];
    if (children&&children.count>0) {
        [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj isKindOfClass:[DPI300Node class]]) {
                DPI300Node* node=(DPI300Node*)obj;
                node.curPosition=node.position;
                if([node conformsToProtocol:@protocol(P_Zoom)]){
                    DPI300Node<P_Zoom>* zoomNode=(DPI300Node<P_Zoom>*)node;
                    zoomNode.curScaleFactor=zoomNode.xScale;
                }
                if([node conformsToProtocol:@protocol(P_Rotate)]){
                    DPI300Node<P_Rotate>* rotateNode=(DPI300Node<P_Rotate>*)node;
                    rotateNode.curAngle=rotateNode.zRotation;
                }
                if([node conformsToProtocol:@protocol(P_SyncRotate)]){
                    DPI300Node<P_SyncRotate>* rotateNode=(DPI300Node<P_SyncRotate>*)node;
                    rotateNode.curAngle=rotateNode.zRotation;
                }
            }
            [self backupState:(SKNode*)obj];
        }];
        
    }
    
    MyScene*scene=[SKSceneCache singleton].scene;
    if(scene){
        FontNode*font= (FontNode*)[scene childNodeWithName:@"font"];
        font.curPosition=font.position;
        font.curScaleFactor=font.xScale;
        font.curAngle=font.zRotation;
    }
   
    
    
}
//////uigesture End///



- (void)panHandler:(UIPanGestureRecognizer *)sender {
    if (_controller.inModeOfBackgroundGrid) {
        [_controller.skScene changeDensity:[sender translationInView:_controller.skView]];
    }
    else{
        
    if (_controller.currentNode) {
        CGPoint curPoint;
        //拖动组建
        if([_controller.currentNode conformsToProtocol:@protocol(P_Dragable)]){
            curPoint= [sender translationInView:_controller.skView];
            
            [_controller.currentNode performSelector:@selector(drag:) withObject:[NSValue valueWithCGPoint:curPoint]];
        }
        //如果不支持单手指对称缩放且支持拖动，则直接移动对应node
    }
        
    }
    
    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        [self slowSKViewDown];
    }
    
}



- (void)tapHandler:(UITapGestureRecognizer*)sender {
    _controller.fromTapNotReLoadView=YES;
    if (!_controller.smartSelectionDelegate) {
        _controller.smartSelectionDelegate=[[SmartSelectionDelegate alloc]init];
        _controller.smartSelectionDelegate.controller=_controller;
    }
    
    CGPoint point=[sender locationInView:_controller.skView];
    CGPoint converted=[_controller.skScene convertPointFromView:point];
    //DPI300Node* tempNode=nil;
    //int max=0;
    //NSUInteger order=0;
    NSArray* nodes=[_controller.skScene nodesAtPoint:converted];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(self.hidden = NO)&&(self isKindOfClass: %@  || self isKindOfClass: %@)",
                              [DPI300Node class],[FontNode class]];
    
    NSPredicate *predicate2 = [NSPredicate predicateWithFormat:
                               @"self.selectable = YES"];
    NSArray* finalArray=[[nodes filteredArrayUsingPredicate:predicate] filteredArrayUsingPredicate:predicate2];
    
    NSMutableArray* weakArray=[NSMutableArray new];
    [finalArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SelectTempNodeObject*object=[[SelectTempNodeObject alloc]init];
        object.node=obj;
        [weakArray addObject:object];
    }];
    
    if(finalArray.count>0){
        
        NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"tap", @"SOUND_KEY",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_SOUND" object:self userInfo:dict];
        
        
        
        [_controller.smartSelectionDelegate select:weakArray];
    }
    
    else{
        if (_controller.ifSlide) {
            NSArray* array=@[[_controller.pageViewController.source viewControllerAtIndex:16 ]];
            //从上至下
            [_controller.pageViewController switchPageController:array];
            [_controller guideUser:16];
        }//是否换页
    }
    
    
    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        [self slowSKViewDown];
    }
    
}


- (void)SyncDragEyeAndBrow:(UIPanGestureRecognizer *)sender {
    
    if (_controller.isSyncDragNotRotate) {

        if (_controller.currentNode&&[_controller.currentNode conformsToProtocol:@protocol(P_SyncDrag)]) {

            CGPoint translation= [sender translationInView:_controller.skView];
            [_controller.currentNode performSelector:@selector(syncDrag:) withObject:[NSValue valueWithCGPoint:translation]];
        }
    }
    else{
        if ([_controller.currentNode conformsToProtocol:@protocol(P_SyncRotate)]) {

            CGPoint translation= [sender translationInView:_controller.skView];
            [_controller.currentNode performSelector:@selector(syncRotate:) withObject:[NSNumber numberWithFloat:-translation.y/300]];
        }
        else if ([_controller.currentNode conformsToProtocol:@protocol(P_Rotate)]){
            CGPoint translation= [sender translationInView:_controller.skView];
            [_controller.currentNode performSelector:@selector(rotateMyself:) withObject:[NSNumber numberWithFloat:-translation.y/300]];
        }
        
    }

    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        [self slowSKViewDown];
    }
}


- (void)rotate:(UIRotationGestureRecognizer *)sender {
    
    if (_controller.currentNode&&[_controller.currentNode conformsToProtocol:@protocol(P_Rotate)]) {
        
        CGFloat  curAngle= -sender.rotation/2 ;
        [_controller.currentNode performSelector:@selector(rotateMyself:) withObject:[NSNumber numberWithFloat:curAngle]];
    }
    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        [self slowSKViewDown];
    }
}

- (void)zoomHandler:(UIPinchGestureRecognizer*)sender {
    if(_controller.inModeOfBackgroundGrid){
        [_controller.skScene changeScale:sender.scale ];
    }
    else{
    if (_controller.currentNode) {
        
        if ([_controller.currentNode conformsToProtocol:@protocol(P_Zoom)]) {
            [_controller.currentNode performSelector:@selector(zoom:) withObject:[[NSNumber alloc]initWithFloat: sender.scale]];
        }
    }
    if(sender.state == UIGestureRecognizerStateEnded || sender.state == UIGestureRecognizerStateFailed || sender.state == UIGestureRecognizerStateCancelled)
    {
        [self slowSKViewDown];
    }}
    
}


-(void)slowSKViewDown{
    [_controller.skView setSlowFrameRate];
}

-(void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
