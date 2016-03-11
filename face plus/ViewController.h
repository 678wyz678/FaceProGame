//
//  ViewController.h
//  face plus
//
//  Created by Willian on 14/10/26.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "DownToUpFocusDelegateProtocol.h"
@class JCRBlurView,ColorPickerDelegate,MyScene,DPI300Node,BottomPagerController,RoundEffectView,SKNode,PLUS_SKView,FXBlurView,OperationStack,ShakeButton,FBShimmeringView,SmartSelectionDelegate,SoundDelegate,GestureDelegate,IconScrollView,ShakeDelegate,ViewControllerGestureDelegate,MyAlertViewDelegate,SCLAlertView,MyShareDelegate,ColorButton;

@interface ViewController : UIViewController<UIGestureRecognizerDelegate>
@property CGSize SCREEN_SIZE;


@property (weak, nonatomic) IBOutlet FXBlurView *blurview;
@property (weak, nonatomic) IBOutlet UIButton *colorButton;
@property (weak, nonatomic) IBOutlet UIButton *dragButton;
//拉下去之后显示的六个按钮
//@property (weak, nonatomic) IBOutlet UIView *operationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *operationBarHeightConstraint;


@property (weak, nonatomic) IBOutlet PLUS_SKView *skView;


@property (weak)MyScene * skScene;
@property (weak,nonatomic)SKNode* currentNode;
//
@property (weak,nonatomic)BottomPagerController* pageViewController;
//全局背景
@property(nonatomic) UIImage* background;


///配对使用
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeightConstraint;
@property (assign,nonatomic)float bottomViewCurrentHeight;
///transparent view
@property (weak, nonatomic) IBOutlet UIView *transparentDivider;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *transparentViewHeightConstraint;

///end transparent


///skview leading constraint
@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *skviewcon;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *skViewRightMargin;


//downToUpDelegate操作的标志位，是否需要pageview滑动（点击下面本身时不需要滑动）

@property (assign)BOOL ifSlide;


//滑动条
@property (weak, nonatomic) IBOutlet UISlider *scaleSlider;

//左侧的UIImage
@property (weak, nonatomic) IBOutlet UIView *leftSKView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageRightMargin;

//不同设备下collectionview 标准高度
@property CGFloat standardHeight;

//关于前进后退按钮和堆栈委托
@property OperationStack* operationStackDelegate;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
//@property (weak, nonatomic) IBOutlet RoundEffectView *preEffectView;
//@property (weak, nonatomic) IBOutlet RoundEffectView *nextEffectView;
//
////当前currentnode所属的类型
//@property (weak, nonatomic) IBOutlet UIScrollView *iconScrollView;
@property (weak, nonatomic) IBOutlet ShakeButton *shakeButton;

//@property (weak, nonatomic) IBOutlet UIView *shimmingContentView;
//@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;
//
//@property (weak, nonatomic) IBOutlet UILabel *shimmeringLabel;
//@property (weak, nonatomic) IBOutlet UILabel *shimmingProgressLabel;


@property(nonatomic)SmartSelectionDelegate* smartSelectionDelegate;



////////start////////
@property (weak, nonatomic) IBOutlet IconScrollView *iconScrollView;
@property (weak, nonatomic) IBOutlet UIView *iconScrollViewContent;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconScrollViewContentWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconScrollViewContentHeight;
@property(nonatomic) CGFloat iconScrollViewNormalContentWidth;

@property (nonatomic,assign) CGFloat standardMargin;
////////end////////


///sound delegate///
@property(nonatomic) SoundDelegate* soundDelegate;
///sound end///

///gesture delegate//
@property(nonatomic) ViewControllerGestureDelegate* gestureDelegate;
@property (nonatomic,assign)BOOL isSyncDragNotRotate;
//end///



//Menu bar
@property (weak, nonatomic) IBOutlet UIView *menuBar;



//pan gesture for drag bottom view to up

@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer *dragBottomViewPanGesture;


//SHAKE delegate
@property ShakeDelegate* shakeDelegate;

//tap导致的upFocus方法调用
@property(assign,nonatomic) BOOL  fromTapNotReLoadView;




//商店按钮
@property (weak, nonatomic) IBOutlet UIButton *storeButton;

//
@property(nonatomic)MyAlertViewDelegate* alertViewDelegate;

//代表是否进入了background 纹理编辑模式
@property (assign,nonatomic)BOOL inModeOfBackgroundGrid;




//此参数代表是否从firstscreen点击scene而来
@property(nonatomic)NSString* controller_Param;
@property(nonatomic)BOOL fromNavigation;


@property SCLAlertView* alertView;

//分享
@property (nonatomic)MyShareDelegate* shareDelegate;


@property NSString* sceneFileName;


//是否需要保存（手势开始以及op stack操作都要保存）
-(void)setNeedSave:(BOOL)need;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuButtonHeightRatio;

@property (weak, nonatomic) IBOutlet UISlider *adjustSlider;
- (IBAction)upBottomEnd:(UISlider*)sender ;


@property(assign,nonatomic)BOOL gotoShake;
-(void)guideUser:(NSInteger)index;
@end

