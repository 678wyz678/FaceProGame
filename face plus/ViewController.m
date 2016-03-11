//
//  ViewController.m
//  face plus
//
//  Created by Willian on 14/10/26.
//  Copyright (c) 2014年 Willian. All rights reserved.
//
#import <stdint.h>
#import <stdlib.h>
#import "ViewController.h"
#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "PLUS_SKView.h"
#import "FaceNode.h"
#import "EyeLeftNode.h"
#import "EyeRightNode.h"
#import "NoseNode.h"
#import "MouthNode.h"
#import "NeckNode.h"
#import "BrowLeftNode.h"
#import "BrowRightNode.h"
#import "MyScene.h"
#import "Pixel2Point.h"
#import "HairNode.h"
#import "P_Rotate.h"
#import "NoseShadowNode.h"
#import "FaceShadow.h"
#import "EarNode.h"
#import "FeatureLayer.h"
#import "DPI300Node.h"
#import "DetectFeatureKind.h"
#import "FaceMeasure.h"
#import "Pixel2Point.h"
#import "ReLayout.h"
#import "BottomPagerController.h"
#import "ViewControllerSource.h"
#import "MyCollectionViewController.h"
#import "GlobalVariable.h"
#import "SKSceneCache.h"
#import "DownToUpDelegate.h"
#import "PairNodes.h"
#import "EyeBallNode.h"
#import "PairNodes.h"
#import "ColorCollectionViewController.h"
#import <FXBlurView/FXBlurView.h>
#import "OperationStack.h"
#import <Social/Social.h>
#import "ShakeButton.h"
#import "CreateDirIfNotExist.h"
#import "RWImageToFolder.h"
#import "ShakeModeDelegate.h"
#import "GetListOfFiles.h"
#import "Color2Image.h"
#import "UIImage+Additions.h"
#import "SmartSelectionDelegate.h"
#import "IconButton.h"
#import "SyncDragPanGestureRecognizer.h"
#import "P_SyncRotate.h"
#import "FontNode.h"
#import "UIMenuForSetting.h"
#import "UIMenuForGallery.h"
#import "UIMenuForShake.h"
#import "UIMenuForShare.h"
#import "UIMenuForStore.h"
#import "UIMenuForReturn.h"
#import "UIMenuForDownload.h"
#import "IconScrollView.h"
#import "SoundDelegate.h"
#import "ShakeDelegate.h"
#import "ViewControllerGestureDelegate.h"
#import "SelectCompareImageDelegate.h"
#import "MyAlertViewDelegate.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import "MyShareDelegate.h"
#import "DefaultEntity.h"
#import "UIImage+animatedGIF.h"
#import "WXApi.h"
#import "HuazhuangCollectionViewController.h"
#import "BackgroundCollectionViewController.h"
#import "MyCollectionViewController.h"
#import "AppDelegate.h"
#import "FrontHairCollectionViewController.h"
#import "BehindHairCollectionViewController.h"
#import "PresentMiddleObject.h"
#import "DownToUpDelegate.h"
#define defaultNoseColor {0xf4e7d4,0xbc9686,0xa3826c}
#define defaultSkinColor {0xfaebd9,0xbf9f86,0x93765f}

#define accelerationThreshold  0.45 // or whatever is appropriate - play around with different values
#define defaultBackgroundColor {0xff2d55,0xffd3e0,0xd6cec3,0x4cd964,0xffcc00,0xc7c7cc,0x324681,0xead2c1}
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static CGFloat faceOffsetY;
static CGFloat cacheFaceY;

static BOOL needSave;
static BOOL inShake;
@interface ViewController (){

    __weak IBOutlet UILabel *choosePart;
    __weak IBOutlet UIView *shakeViewWrapper;
}
@property SelectCompareImageDelegate* selectImageDelegate;
@property SCLAlertView* successAlertView;

//sensor 管理者
@property CMMotionManager*motionManager;


//slider

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderBottom;

@end

@implementation ViewController{
    BOOL pagerIsLoaded;
}
@synthesize currentNode=_currentNode;

-(void)setCurrentNode:(SKNode *)currentNode{
    
    
    if([currentNode isKindOfClass:[DPI300Node class]]){

     DPI300Node *  dpi300CurrentNode=(DPI300Node*)currentNode;
        _currentNode=dpi300CurrentNode;
        //选中动画(脸不需要)
        if (![_currentNode isKindOfClass:[FaceNode class]]) {
            SKAction* anm1=[SKAction scaleBy:1.2 duration:0.1];
            SKAction*anm2=[SKAction scaleBy:5.0/6 duration:0.08];
            SKAction* sequence=[SKAction sequence:[[NSArray alloc]initWithObjects:anm1,anm2, nil]];
            [_currentNode runAction:sequence];
            
            
//            if ([_currentNode respondsToSelector:@selector(order)]) {
//                DPI300Node* myNode=(DPI300Node*)_currentNode;
//            }
            
            if ([_currentNode conformsToProtocol:@protocol(PairNodes)]) {
                
                id<PairNodes> pairNode=(id<PairNodes>)self.currentNode;
                if (dpi300CurrentNode.isViceSir) {
                    _currentNode=pairNode.bindActionNode;
                }
                if (pairNode) {
                    [pairNode.bindActionNode runAction:sequence];
                }
                
            }
        }
    }
    else if([currentNode isKindOfClass:[FontNode class]]){
        _currentNode=currentNode;
        NSLog(@"字体设置成功");
    }
    else if([currentNode isKindOfClass:[SKNode class]]){
        _currentNode=nil;
    }
    //其他情况则不做操作
}


-(void)guideUser:(NSInteger)index{
    if ([self.blurview viewWithTag:56823]) {
        return;
    }
    //GuideView
    if (![[NSUserDefaults standardUserDefaults] integerForKey:[NSString stringWithFormat:@"PlayMultipleTimesFor%ld",index]]) {
        [self presentGuideView:index];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:[NSString stringWithFormat:@"PlayMultipleTimesFor%ld",index]];
    }
    


}
//缩放操作（放大缩小器官）
- (IBAction)zoomHandler:(UIPinchGestureRecognizer*)sender {
    [_gestureDelegate zoomHandler:sender];
   
    
}
//滑动操作（移动器官）
- (IBAction)panHandler:(UIPanGestureRecognizer *)sender {
    [_gestureDelegate panHandler:sender];
}
//单击触发选择器官
- (IBAction)tapHandler:(UITapGestureRecognizer*)sender {
    [_gestureDelegate tapHandler:sender];
}

- (IBAction)SyncDragEyeAndBrow:(UIPanGestureRecognizer *)sender {
    
    [_gestureDelegate SyncDragEyeAndBrow:sender];
}

- (IBAction)rotate:(UIRotationGestureRecognizer *)sender {
    [_gestureDelegate rotate:sender] ;
}




//加载各种五官
-(void)initAll{
    if (self.skScene!=nil) {
        FaceNode * face= [[FaceNode alloc] initWithEntity:[DefaultEntity singleton].faceEntity];
        EarNode * ear=[[EarNode alloc]initWithEntity:[DefaultEntity singleton].earEntity];
        ear.position=CGPointMake(168.73,-18.55);
        [face addChild:ear];
      
        [self.skScene addChild:face];
        self.skScene.faceNode=face;

    
        EyeLeftNode* eyeLeft=[[EyeLeftNode alloc ]initWithEntity:[DefaultEntity singleton].eyeEntity];
        eyeLeft.position=CGPointMake(-114.067, 31.159);
        [face addChild:eyeLeft];
        
        EyeRightNode* eyeRight=[[EyeRightNode alloc ]initWithEntity:[DefaultEntity singleton].eyeEntity];
        [face addChild:eyeRight];
        
        BrowLeftNode* browLeft=[[BrowLeftNode alloc]initWithEntity:[DefaultEntity singleton].browEntity];
        [face addChild:browLeft];
        browLeft.hidden=YES;
        
        BrowRightNode* browRight=[[BrowRightNode alloc]initWithEntity:[DefaultEntity singleton].browEntity];
        browRight.position=CGPointMake(38.555, 83.419);
        [face addChild:browRight];
        browRight.hidden=YES;

        MouthNode* mouth=[[MouthNode alloc]initWithEntity:[DefaultEntity singleton].mouthEntity];
        [face addChild:mouth];
        mouth.hidden=YES;
        
        
        NoseNode* nose=[[NoseNode alloc]initWithEntity:[DefaultEntity singleton].noseEntity];
        [face addChild:nose];
        nose.hidden=YES;

        HairNode* hair=[[HairNode alloc]initWithEntity:[DefaultEntity singleton].hairEntity];
        [face addChild:hair];
        hair.hidden=YES;
        
        NeckNode* neck=[[NeckNode alloc]initWithEntity:[DefaultEntity singleton].neckEntity];
        [face addChild:neck];
        
        int a[3]=defaultSkinColor;
        int b[3]=defaultNoseColor;

        //背景设置
        int lowerBound = 0;
        int upperBound = 2;
        int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
        ear.color=neck.color= face.color=UIColorFromRGB(a[rndValue]);
        nose.color=UIColorFromRGB(b[rndValue]);
        browRight.color = browLeft.color=hair.color;
        
        
        
        //添加pair绑定
        [eyeLeft setBindActionNode:eyeRight];
        [eyeRight setBindActionNode:eyeLeft];
        [browLeft setBindActionNode:browRight];
        [browRight setBindActionNode:browLeft];
        
        EyeBallNode* leftEyeBallNode=(EyeBallNode*)[[eyeLeft childNodeWithName:eyeballCropLayerName] childNodeWithName:eyeballLayerName];
        EyeBallNode* rightEyeBallNode=(EyeBallNode*)[[eyeRight childNodeWithName:eyeballRightCropLayerName] childNodeWithName:eyeballLayerName];
        leftEyeBallNode.bindActionNode=rightEyeBallNode;
        rightEyeBallNode.bindActionNode=leftEyeBallNode;
           }
    

    [FaceMeasure measure:((FaceNode*)[self.skScene childNodeWithName:faceLayerName]).texture
     ];
    [ReLayout layout:self.skScene];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)viewDidLoad {
      [super viewDidLoad];
    shakeViewWrapper.alpha=0;
    BOOL firstUse=[[NSUserDefaults standardUserDefaults] boolForKey:@"FIRST_USE"];
    if (!firstUse) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"PlaySound"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FIRST_USE"];
        [[NSUserDefaults standardUserDefaults] synchronize];

    }
    
    [choosePart setText:NSLocalizedString(@"Choose part and start to shake", @"选部件")];
   // [[NSUserDefaults standardUserDefaults] setBool:<#(BOOL)#> forKey:<#(NSString *)#>]
    
    //将所有gesture 装入delegate
    _gestureDelegate=[[ViewControllerGestureDelegate alloc]initWithController:self];
       [self.skView.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
           UIGestureRecognizer* gesture=(UIGestureRecognizer*)obj;
           [gesture setDelegate:_gestureDelegate];
       }];
    [self.blurview.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIGestureRecognizer* gesture=(UIGestureRecognizer*)obj;
        [gesture setDelegate:_gestureDelegate];
    }];
    //END 将所有gesture 装入delegate
    

    

    
   
    //获取屏幕大小
    self.SCREEN_SIZE=[[UIScreen mainScreen ]bounds].size;
    

    [DownToUpDelegate singleton].viewController=self;//与初始化加载pager有先后顺序，不能倒
    
    
  //  int a[8]=defaultBackgroundColor;
                       


    //背景设置
//    int lowerBound = 0;
//    int upperBound = 7;
//    int rndValue = lowerBound + arc4random() % (upperBound - lowerBound);
    [self setBackground:[Color2Image imageWithColor:UIColorFromRGB(0xffd3e0)]];

    
    
    
    
    [self initPager];
    //初始化是否需要滑动
    self.ifSlide=TRUE;
    //初始化UISlider
    [self setUISlider];
    
    //初始化前进后退委托（查看历史操作）
    self.operationStackDelegate=[[OperationStack alloc]init];
    self.operationStackDelegate.controller=self;
    
 
    
    self.blurview.dynamic=NO;


    
    
    _soundDelegate=[[SoundDelegate alloc]init];
    _shakeDelegate=[[ShakeDelegate alloc] initWithController:self];
    
    //进入摇一摇模式
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startShakeMode) name:@"RESET_ICONBUTTON" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(endShakeMode) name:@"QUIT_SHAKE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalShare) name:@"SHARE_PHOTO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalDownload) name:@"DOWNLOAD_PHOTO" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSKScene:) name:@"UPDATE_CURRENT_SCENE" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationForBottomDrager:) name:@"SET_BOTTOM_VIEW_DRAGGED_ENABLED" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationForRandomBackground) name:@"RANDOM_BACKGROUND" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationForCurrentNode:) name:@"Change_Current_Node" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(givePresent:) name:@"NEED_PRESENT" object:nil];
    self.selectImageDelegate=[[SelectCompareImageDelegate alloc]initWithController:self];
    self.alertViewDelegate=[[MyAlertViewDelegate alloc]initWithController:self];
    [self initAlertView];
    //加载shake传感器
    [self initShakeSensor];
    _sceneFileName=nil;

}



- (void)viewWillAppear:(BOOL)animated   {
    [super viewWillAppear:animated];
    [self skViewFadeIn];
    self.navigationController.navigationBarHidden= YES;
    _fromTapNotReLoadView=NO;
    [self.skScene setPaused:NO];
    NSArray* array=@[[self.pageViewController.source viewControllerAtIndex:0]];
    [self.pageViewController switchPageController: array ];
    if (_controller_Param&&self.fromNavigation) {
        
        [self updateSkSceneByName:self.controller_Param];
        _controller_Param=nil;
        self.fromNavigation=NO;
        
    }
    else if(self.fromNavigation){
        
        
        self.skScene=[[MyScene alloc] initWithSize:CGSizeMake(self.SCREEN_SIZE.width, self.SCREEN_SIZE.width*4/3.0)];
        resetFrontHairArray();
        resetBehindHairArray();
        [self initAll];
        [self.skView presentScene:self.skScene];
        self.fromNavigation=NO;
        _sceneFileName=nil;
        [self resetCollectionViewState];
        needSave=YES;
        
        
      
    }
    
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.gotoShake) {
        self.gotoShake=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int)(0.01*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [DownToUpDelegate singleton]->currentState=0x20 ;
            [[DownToUpDelegate singleton] dragButtonHandler];
            NSLog(@"开始执行");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_SHAKE_MODE" object:self];

        });
    }

    [self.blurview updateAsynchronously:YES completion:NULL];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.skScene setPaused:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"QUIT_SHAKE_MODE" object:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
  //  [self.skView presentScene:nil];
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1ull*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[self.skView presentScene:self.skScene];
   // });
    

    // Dispose of any resources that can be recreated.
}







-(void)setUISlider{
    if (self.scaleSlider) {
        CGAffineTransform rotation=CGAffineTransformMakeRotation(-1.57079633);
        self.scaleSlider.transform=rotation;
        self.scaleSlider.hidden=NO;
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            _sliderBottom.constant=20.f;
            _sliderTrailing.constant=7.f;
        
        }
    }
    
    if (self.adjustSlider) {
        CGAffineTransform rotation=CGAffineTransformMakeRotation(-1.57079633);
        self.adjustSlider.transform=rotation;
       
    }

}

- (IBAction)colorPalette:(id)sender {

    NSDictionary* dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"color", @"SOUND_KEY",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAY_SOUND" object:self userInfo:dict];
    
    NSArray* array=@[[self.pageViewController.source viewControllerAtIndex:100 ]];
    [self.pageViewController switchPageController:array];

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"pager"])
    {
        // Get reference to the destination view controller
         _pageViewController = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
    }
}


//------------底部page设置初始化 Pager Control---------------
-(void)initPager{
//    BottomPagerController* pageViewController = [[BottomPagerController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
//    _pageViewController=pageViewController;
//    
//    
    //加入底部
//        [self addChildViewController:pageViewController];
//        [self.blurview addSubview:pageViewController.view];
//    
    @try {
        //布局pagerView
//        UIView* pagerView=self.pageViewController.view;
//        UIView* blurView=self.blurview;
//     //   UIView* operationBar=self.operationBar;
//        
//       // NSLog(@"opbar是不是nil呢????:%@",self.operationBar);
//        
//        UIView* transparent=self.transparentDivider;
//        NSDictionary *views = NSDictionaryOfVariableBindings(pagerView,blurView,transparent);
//        pagerView.translatesAutoresizingMaskIntoConstraints = NO;
//        
//        [self.blurview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[transparent]-0-[pagerView]|" options:0 metrics:nil views:views]];
//        [self.blurview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[pagerView]|" options:0 metrics:nil views:views]];
//        
        if (self.SCREEN_SIZE.height<=480) {
            self.standardHeight=self.SCREEN_SIZE.width/2.0+40;
            
            //self.standardHeight=80+30;//30为drag和transparent的高度
        }
        else{
            
            self.standardHeight=self.SCREEN_SIZE.width/2.0+40;
        }
        self.bottomViewHeightConstraint.constant=self.standardHeight;
        [self.view layoutIfNeeded];
        
        [self initIconScrollView];
        [self initMenuBar];
    }
    @catch (NSException *exception) {
        
    }
  
   
}






-(void)setBackground:(UIImage *)Background{
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
        NSDictionary*dict=NSDictionaryOfVariableBindings(Background);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATE_SCENE_BACKGROUND" object:self userInfo:dict];
    }
    
    self.skScene.background=Background;
    self.view.layer.contents = (id)Background.CGImage;
    [self.blurview updateAsynchronously:YES completion:NULL];
}


//slider响应函数
- (IBAction)slideForScale:(UISlider*)sender {
 
   // SKAction* action=[SKAction scaleTo:sender.value*4.1667 duration:0];
    FaceNode*face=(FaceNode*)[self.skScene childNodeWithName:faceLayerName];
   // [face runAction:action];
    face.xScale=sender.value*4.1667;
     face.yScale=sender.value*4.1667;
    [face correctPositionForScaleSlider:[NSNumber numberWithFloat:sender.value]];
}

//前进后退处理事件
//- (IBAction)previousOperation:(id)sender {
//    [[self operationStackDelegate] backwardOperation];
//}
//- (IBAction)nextOperation:(id)sender {
//    [[self operationStackDelegate] forwardOperation];
//}
//end前进后退处理事件

//pagecontrol向上拖动
- (IBAction)dragPager:(UIPanGestureRecognizer *)sender {
    
    DownToUpDelegate*delegate= [DownToUpDelegate singleton];
    if (delegate) {
        [delegate ListUpAndDown:sender];
    }
}
- (IBAction)dragButtonHandler:(UIButton *)sender {
    DownToUpDelegate* delegate=[DownToUpDelegate singleton];
    if (delegate) {
        [delegate dragButtonHandler];
    }
}




- (void)globalShare {
    __weak ViewController* weakSelf=self;
    self.alertView=[[SCLAlertView alloc]init];
    if ([WXApi isWXAppInstalled]) {
        [_alertView addButton:@"发微信好友" actionBlock:^{
            if (!weakSelf.shareDelegate) {
                weakSelf.shareDelegate=[[MyShareDelegate alloc]initWithController:weakSelf];
            }
            DownToUpDelegate* delegate=[DownToUpDelegate singleton];
            UIImage* image=[delegate captureSKView];
            [weakSelf.shareDelegate sendWeixinImageContent:image];
        }];
        [_alertView addButton:@"微信朋友圈" actionBlock:^{
            if (!weakSelf.shareDelegate) {
                weakSelf.shareDelegate=[[MyShareDelegate alloc]initWithController:weakSelf];
            }
            DownToUpDelegate* delegate=[DownToUpDelegate singleton];
            UIImage* image=[delegate captureSKView];
            [weakSelf.shareDelegate sendWeixinImageContentInTiemLine:image];

        }];
    }
      [_alertView addButton:@"微博Weibo" actionBlock:^{
        if (!weakSelf.shareDelegate) {
            weakSelf.shareDelegate=[[MyShareDelegate alloc]initWithController:weakSelf];
        }
        DownToUpDelegate* delegate=[DownToUpDelegate singleton];
        UIImage* image=[delegate captureSKView];
        [weakSelf.shareDelegate shareSinaWeibo:image];

    }];
    
    [_alertView addButton:@"Twitter" actionBlock:^{
        if (!weakSelf.shareDelegate) {
            weakSelf.shareDelegate=[[MyShareDelegate alloc]initWithController:weakSelf];
        }
        DownToUpDelegate* delegate=[DownToUpDelegate singleton];
        UIImage* image=[delegate captureSKView];
        [weakSelf.shareDelegate shareTwitter:image];

    }];
    [_alertView addButton:@"Facebook" actionBlock:^{
        if (!weakSelf.shareDelegate) {
            weakSelf.shareDelegate=[[MyShareDelegate alloc]initWithController:weakSelf];
        }
        DownToUpDelegate* delegate=[DownToUpDelegate singleton];
        UIImage* image=[delegate captureSKView];
        [weakSelf.shareDelegate shareFaceBook:image];

    }];


    [self performSelectorOnMainThread:@selector(loadAlertView) withObject:nil waitUntilDone:NO];
    
    
    

}

-(void)loadAlertView{
    UIColor *color = [UIColor colorWithRed:0x1a/255.0 green:0xbc/255.0 blue:0x9c/255.0 alpha:1.0];
    [_alertView showCustom:self image:[UIImage imageNamed:@"globalShare"] color:color title:@"Share" subTitle:NSLocalizedString(@"Choose one of the tool to share with.", @"分享方式") closeButtonTitle:NSLocalizedString(@"Cancel", @"取消") duration:0.0f];
    

}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert;
        if (error == nil)
        {
            alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"This portrait has been saved to your photo album.", @"保存形象") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            alert = [[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Please try it again later.Saving Failed", @"保存失败")  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    });
    
}


///download start/////////
-(void)globalDownloadDelegate{
        _alertView.labelTitle.text=[NSString stringWithFormat:@"%@...",NSLocalizedString(@"Saving", @"保存中") ];
    NSDate *fireDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0.001]; // 1 ms

    NSTimer *timer = [[NSTimer alloc]
                      initWithFireDate:fireDate interval:0.1f target:self selector:@selector(download) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(void)download{
    
    DownToUpDelegate* delegate=[DownToUpDelegate singleton];
    
    
    UIImage* image=[delegate captureSKView];
    

    CGSize SCREEN_SIZE=[UIScreen mainScreen].bounds.size;
    
    
    NSInteger export4_4=[[NSUserDefaults standardUserDefaults] integerForKey:@"Export_4-4"];
    CGSize documentPhotoSize=CGSizeMake(SCREEN_SIZE.width*0.33, SCREEN_SIZE.width*0.33);
    if (!export4_4) {
        documentPhotoSize=CGSizeMake(SCREEN_SIZE.width*0.33, SCREEN_SIZE.width*0.33*4/3.f);
    }
    
    
    //开始合成图片(document内)
    UIGraphicsBeginImageContext(documentPhotoSize);
    [image drawInRect:CGRectMake(0,0,documentPhotoSize.width, documentPhotoSize.height)];
    UIImage*documentImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    [CreateDirIfNotExist createDirIfNotExist:@"SavedImages"];
    
    NSString* fileName=nil;
    //如果是恢复过来的文件,则保留文件名
    if (_sceneFileName) {
        fileName=_sceneFileName;
        [RWImageToFolder saveWithName:documentImage fileName:fileName];
          
        
    }
    else{
        fileName  =[RWImageToFolder save:documentImage];
        
        NSArray* firstScreenArray=[[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_SCREEN_STACK"];
        NSMutableArray* tempArray=nil;
        if (!firstScreenArray) {
            tempArray=[NSMutableArray arrayWithObject:fileName];
        }
        else{
            
            
            
            tempArray=[NSMutableArray arrayWithArray:firstScreenArray];
            
            
            [tempArray addObject:fileName];
        }
        
        NSArray* finalArray=[NSArray arrayWithArray:tempArray];
        
        [[NSUserDefaults standardUserDefaults] setValue:finalArray forKey:@"FIRST_SCREEN_STACK"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    });
    // store the array
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
   // NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"incompletedWorks.txt"];
    NSString *sceneFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
    
   
    

    [NSKeyedArchiver archiveRootObject:[SKSceneCache singleton].scene toFile:sceneFile];

    
    
    if (![[NSUserDefaults standardUserDefaults] integerForKey:@"ifSharedBefore"]) {
        _alertView=[[SCLAlertView alloc]init];
        [_alertView showNotice:self title:@"Share with friends" subTitle:NSLocalizedString(@"Locked parts are randomly rewarded.", @"分享获得部件")  closeButtonTitle:@"OK" duration:0.0f];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"ifSharedBefore" ];
    }
    needSave=NO;


}
- (void)globalDownload {

    __weak typeof(self) weakSelf = self;
    self.alertView=[[SCLAlertView alloc]init];
    [_alertView addButton:@"Yes" actionBlock:^{
        [weakSelf globalDownloadDelegate];
    }];
    [_alertView addButton:@"NO" actionBlock:^{
        ;
    }];
    UIColor *color = [UIColor colorWithRed:65.0/255.0 green:64.0/255.0 blue:144.0/255.0 alpha:1.0];
    [_alertView showCustom:self image:[UIImage imageNamed:@"globalDownload"] color:color title:NSLocalizedString(@"Download",@"下载") subTitle:NSLocalizedString(@"Ready to save portrait to photo library?", @"保存相册") closeButtonTitle:nil duration:0.0f];
}
//////download end/////



//shake 传感器
-(void)initShakeSensor{
    
    _motionManager = [[CMMotionManager alloc] init];
    _motionManager.deviceMotionUpdateInterval = 0.5;
    
    [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue]  withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         [self motionMethod:motion];
     }];

}


-(void)motionMethod:(CMDeviceMotion *)deviceMotion
{
    if (shakeViewWrapper.alpha>0) {
        return;
    }
        CMAcceleration userAcceleration = deviceMotion.userAcceleration;
        if (fabs(userAcceleration.x) > accelerationThreshold
            || fabs(userAcceleration.y) > accelerationThreshold
            || fabs(userAcceleration.z) > accelerationThreshold)
        {
            
          
            
            [_shakeDelegate shake];
            
            
            
            
               // NSTimer* timer=[NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(reserInShakeBool) userInfo:nil repeats:NO];
                //[[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        }
  
}

-(void)reserInShakeBool{
    inShake=NO;
}








-(void)initIconScrollView{
     [_iconScrollViewContent setTranslatesAutoresizingMaskIntoConstraints:NO];
    _transparentDivider.clipsToBounds=YES;
    int iconNum=18;
    CGFloat defaultIconWidth=40*0.818;
    
    NSNumber* margin=[NSNumber numberWithFloat:(_SCREEN_SIZE.width-100-defaultIconWidth*5)/5];
    _standardMargin=margin.floatValue;
    NSNumber* sideMargin=[NSNumber numberWithFloat:(_SCREEN_SIZE.width-100)/2.0-defaultIconWidth/2.0];
    //计算contentview宽度
    _iconScrollViewContentWidth.constant=margin.floatValue*(iconNum-1)+sideMargin.floatValue*2+iconNum*defaultIconWidth;
    self.iconScrollViewNormalContentWidth=_iconScrollViewContentWidth.constant;
    
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"]];
    NSArray *array = [dictionary objectForKey:@"IconArray"];
    
    
    for (int i=0;i<iconNum; i++) {
        IconButton* button=[[IconButton alloc]init];
        button.index=i;
        [button setImage:[UIImage imageNamed:array[i]] forState:UIControlStateNormal];
        
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
       
        [_iconScrollViewContent addSubview:button];

        NSNumber*defaultIconWidthMetric=[NSNumber numberWithFloat:defaultIconWidth];
        if (i==0) {
            NSDictionary* dict=NSDictionaryOfVariableBindings(button);
            NSDictionary* value=NSDictionaryOfVariableBindings(sideMargin,defaultIconWidthMetric);

             NSArray* hConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"|-(sideMargin)-[button]" options:0 metrics:value views:dict];
            NSArray* vConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3.64-[button]" options:0 metrics:value views:dict];
            
            NSLayoutConstraint* heightRatio=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:32.72];
            NSLayoutConstraint* constraint=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
            [button addConstraint:constraint];
            
            [_iconScrollViewContent addConstraints:vConstraintArray];
            [_iconScrollViewContent addConstraint:heightRatio];
            [_iconScrollViewContent addConstraints:hConstraintArray];
           // [_iconScrollViewContent addConstraints:vConstraintArray];
        }
        else{
            
            UIButton * previousButton=_iconScrollView.subViewArray[i-1];
            NSDictionary* dict=NSDictionaryOfVariableBindings(previousButton,button);
            NSDictionary* value=NSDictionaryOfVariableBindings(margin,defaultIconWidthMetric);
             NSArray* hConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"[previousButton]-(margin)-[button]" options:0 metrics:value views:dict];
             NSLayoutConstraint* heightRatio=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:32.72];
            
             NSArray* vConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3.64-[button]" options:0 metrics:value views:dict];
            NSLayoutConstraint* constraint=[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
            [button addConstraint:constraint];
            
            
         
            [_iconScrollViewContent addConstraints:vConstraintArray];

            [_iconScrollViewContent addConstraints:hConstraintArray];

            [_iconScrollViewContent addConstraint:heightRatio];
           // [_iconScrollViewContent addConstraints:vConstraintArray];
        }
        
        [_iconScrollViewContent addConstraint: [NSLayoutConstraint constraintWithItem:button
                                                                            attribute:NSLayoutAttributeCenterY
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:_iconScrollViewContent
                                                                            attribute:NSLayoutAttributeCenterY
                                                                           multiplier:1
                                                                             constant:0]];
        
        [_iconScrollView.subViewArray addObject:button];
       
    }
}



-(void)initMenuBar{
    NSMutableArray* tempArrayForButtons=[[NSMutableArray alloc]init];

    [_menuBar setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSNumber* margin=[NSNumber numberWithFloat:(_SCREEN_SIZE.width-100-32*5)/5];
    NSNumber* halfMargin=[NSNumber numberWithFloat:margin.floatValue/2.0f];

    for (int i=0; i<5; i++) {
        UIButton* button;
        switch (i) {
            case 0:
                button=[[UIMenuForShake alloc]init];
                [button setImage:[UIImage imageNamed:@"globalShake"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(clickShake) forControlEvents:UIControlEventTouchUpInside];
                break;
            case 1:
                button=[[UIMenuForStore alloc]init];
                [button setImage:[UIImage imageNamed:@"globalStore"] forState:UIControlStateNormal];
                break;
            case 2:
                button=[[UIMenuForReturn alloc]init];
                [button addTarget:self action:@selector(promptForLeaving) forControlEvents:UIControlEventTouchUpInside];
                [button setImage:[UIImage imageNamed:@"navigation_back_button"] forState:UIControlStateNormal];
                break;
            case 3:
                button=[[UIMenuForGallery alloc]init];
                [button setImage:[UIImage imageNamed:@"globalGallery"] forState:UIControlStateNormal];

                break;
            case 4:
                button=[[UIMenuForDownload alloc]init];
                [button setImage:[UIImage imageNamed:@"globalDownload"] forState:UIControlStateNormal];

                break;
            

            default:
                break;
        }
        
        [tempArrayForButtons addObject:button];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_menuBar addSubview:button];

        
        NSNumber * number=margin;
        NSDictionary* dict;
        
        if (i==0) {
            
            number=halfMargin;
            dict=NSDictionaryOfVariableBindings(button);
        }
        else{
            UIView*previousButton=tempArrayForButtons[i-1];
            dict=NSDictionaryOfVariableBindings(button,previousButton);

        }
        NSDictionary* value=NSDictionaryOfVariableBindings(number);
        NSArray* hConstraintArray;
        if(i==0){
             hConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"|-(number)-[button(32)]" options:0 metrics:value views:dict];
        }
        else{
            hConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"[previousButton]-(number)-[button(32)]"  options:0 metrics:value views:dict];
        }
        
            NSArray* vConstraintArray=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-9-[button(32)]" options:0 metrics:nil views:dict];
            [_menuBar addConstraints:hConstraintArray];
            [_menuBar addConstraints:vConstraintArray];
    }
}



-(void)startShakeMode{
    self.dragBottomViewPanGesture.enabled=NO;
}
-(void)endShakeMode{
    shakeViewWrapper.alpha=0.0;
    self.dragBottomViewPanGesture.enabled=YES;
}


- (IBAction)beginSlide:(id)sender {
    [_skView setFastFrameRate];
}


- (IBAction)endSlide:(id)sender {

    [_skView setSlowFrameRate];
}


-(void)updateSKScene:(NSNotification*)sender{
   NSString*fileName= [sender.userInfo objectForKey:@"fileName"];
    [self updateSkSceneByName:fileName];
}

-(void)updateSkSceneByName:(NSString*)sceneName{

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",sceneName]];
    
    

    MyScene* scene=[SKSceneCache singleton].scene;
   EyeLeftNode*eyeleft=(EyeLeftNode*) [scene.faceNode childNodeWithName:eyeLeftLayerName] ;
    [[NSNotificationCenter defaultCenter] removeObserver:eyeleft];
    
    
     scene=[NSKeyedUnarchiver unarchiveObjectWithFile:appFile] ;
    if (scene) {
        self.skScene=scene;
        
        //设置sceneName以备保存使用
        _sceneFileName=sceneName;

        [SKSceneCache changeInstance:scene];
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            
            SKSpriteNode* background=[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[Color2Image imageWithColor:UIColorFromRGB(0xffd3e0)]]];
            

            background.size=self.SCREEN_SIZE;
            background.name=@"background";
            background.zPosition=-1000;

            background.anchorPoint=CGPointMake(0, 1);
            background.position=CGPointMake(-self.SCREEN_SIZE.width/2.0, self.SCREEN_SIZE.height/2.0);
            [self.skScene addChild:background];
        }
        if (scene.background) {
            [self setBackground:scene.background];
        }
        
        [self skViewFadeIn];

        [self.skView presentScene:scene];

        
        
        
        //恢复collectionview现场
        if (scene.currentIndexPathDictionary) {
            setDictionaryOfIndexPath(scene.currentIndexPathDictionary);
        }
        if (scene.selectedCellIndexPath) {
            setSelectedIndexPath(scene.selectedCellIndexPath);
        }
        if (scene.backgroundSelectedPath) {
            setSelectedGridIndexPath(scene.backgroundSelectedPath);
        }
        
        
    }
    needSave=YES;

}

-(void)receiveNotificationForBottomDrager:(NSNotification*)sender{
    BOOL enabled=((NSNumber*)[sender.userInfo objectForKey:@"ENABLED"]).boolValue;
    [self.dragBottomViewPanGesture setEnabled:enabled];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)receiveNotificationForRandomBackground{
    [self setBackground:[Color2Image imageWithColor:[Color2Image random]]];

}

-(void)receiveNotificationForCurrentNode:(NSNotification*)sender{
    SKNode*currentNode=[sender.userInfo objectForKey:@"Node"];
    [self setCurrentNode:currentNode];
}
-(void)initAlertView{
    //self.successAlertView=[[SCLAlertView alloc]init];
    __weak typeof(self) weakSelf = self;
    self.alertView=[[SCLAlertView alloc]init];
    [_alertView addButton:@"Yes" actionBlock:^{
        [weakSelf globalDownloadDelegate];
    }];
    [_alertView addButton:@"NO" actionBlock:^{
        ;
    }];
    
    
}
-(void)showSuccessAlert:(NSString*)message{
        _successAlertView=[[SCLAlertView alloc]init];
    
    [_successAlertView showSuccess:self title:@"Well done!" subTitle:@"保存成功" closeButtonTitle:nil duration:2.0f];
}

-(void)promptForLeaving{
    
    
    if (needSave) {
        _alertView=[[SCLAlertView alloc]init];
        __weak typeof(self) weakSelf = self;
        
        [_alertView addButton:NSLocalizedString(@"Leave", @"离开") actionBlock:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_ONE_CONTROLER" object:weakSelf];
        }];
        [_alertView showWarning:self title:[NSString stringWithFormat:@"%@...", NSLocalizedString(@"Leaving", @"离开")] subTitle:NSLocalizedString(@"Leave without saving?", @"不保存直接退出") closeButtonTitle:NSLocalizedString(@"NO",@"不") duration:0.0f];
        
    }
    
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"POP_ONE_CONTROLER" object:self];
    }
    
   }


-(void)skViewFadeIn{
    _skView.alpha=0.f;
    [UIView animateWithDuration:0.8 animations:^{
        _skView.alpha=1.0;
    }];
}
-(void)resetCollectionViewState{
    //my collection
    setDictionaryOfIndexPath(nil);
    //背景
    setSelectedGridIndexPath(nil);
    //化妆包
    setSelectedIndexPath(nil);
    //化妆包

}

-(void)presentGuideView:(NSInteger)index{
   UIWebView*guideView= [[UIWebView alloc]init];
    
    guideView.backgroundColor=[UIColor greenColor];
    guideView.translatesAutoresizingMaskIntoConstraints=NO;
     NSURL* url = [[NSBundle mainBundle] URLForResource:[NSString stringWithFormat:@"guide_%ld",index] withExtension:@"gif"];
    if (!url) {
        return;
    }
    [guideView loadData:[NSData dataWithContentsOfURL:url] MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    guideView.scalesPageToFit=YES;
    guideView.tag=56823;
    

    UIButton*button=[[UIButton alloc]init];
    button.translatesAutoresizingMaskIntoConstraints=NO;
    [button addTarget:self action:@selector(removeGuide) forControlEvents:UIControlEventTouchUpInside];
    [self.blurview addSubview:guideView];
    [guideView addSubview:button];
    
    UIView* pagerView=self.pageViewController.view;
    NSLayoutConstraint* leading=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:pagerView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint* trailing=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:pagerView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    NSLayoutConstraint* top=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:pagerView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint* bottom=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:pagerView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [_blurview addConstraints:@[top,leading,bottom,trailing]];
    
    
    leading=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    trailing=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    top=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    bottom=[NSLayoutConstraint constraintWithItem:guideView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    [guideView addConstraints:@[top,leading,bottom,trailing]];

    
    
    
    guideView.alpha=0.f;
    [UIView animateWithDuration:0.8 animations:^{
        guideView.alpha=1.f;
    }];
}



-(void)givePresent:(NSNotification*)sender{
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1ull * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSString* source=[sender.userInfo objectForKey:@"SOURCE"];
        BOOL addedBefore=NO;
        if ([source isEqualToString:@"WEIXIN"]) {
            addedBefore =[[NSUserDefaults standardUserDefaults] boolForKey:@"WEIXIN_PRESENT"];
            
        }
        else if([source isEqualToString:@"WEIBO"]){
            addedBefore =[[NSUserDefaults standardUserDefaults] boolForKey:@"WEIBO_PRESENT"];
            
        }
        else if ([source isEqualToString:@"FACEBOOK"]){
            addedBefore =[[NSUserDefaults standardUserDefaults] boolForKey:@"FACEBOOK_PRESENT"];
        }
        else if ([source isEqualToString:@"TWITTER"]){
            addedBefore =[[NSUserDefaults standardUserDefaults] boolForKey:@"TWITTER_PRESENT"];
        }
        
        if (addedBefore) {
            return;
        }
        
        //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL added=  [self.shareDelegate addAddition];
        
        if (added) {
            
            
            
            if ([source isEqualToString:@"WEIXIN"]) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WEIXIN_PRESENT"];
                
            }
            else if([source isEqualToString:@"WEIBO"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"WEIBO_PRESENT"];
            }
            else if ([source isEqualToString:@"FACEBOOK"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"FACEBOOK_PRESENT"];
            }
            else if ([source isEqualToString:@"TWITTER"]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"TWITTER_PRESENT"];
            }
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Bonus",@"奖励标题") message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"share bonus", @"分享后奖励的奖励语") ] delegate:self cancelButtonTitle:@"No,Thanks." otherButtonTitles:@"Rate", nil];
                [alert show];
            });
            
            
        }
        
    });
    
  
    
    //});
}


- (void) alertView:(UIAlertView *)alertview clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        NSString* url = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/%@", AppleId];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    }
}


-(MyShareDelegate*) shareDelegate{

    if (!_shareDelegate) {
        _shareDelegate=[[MyShareDelegate alloc]initWithController:self];
    }
    return _shareDelegate;
}


-(void)setNeedSave:(BOOL)need{
    needSave=need;
}


- (IBAction)sendSourceToFriends:(id)sender {
//    [APService setAlias:@"cjx" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
//    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
//    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

//连接极光注册 别名回调
//-(void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    NSLog(@"rescode: %ld, \ntags: %@, \nalias: %@\n", (long)iResCode, tags , alias);
//}
////极光发送消息
//- (void)networkDidReceiveMessage:(NSNotification *)notification {
//    NSDictionary * userInfo = [notification userInfo];
//    NSString *content = [userInfo valueForKey:@"content"];
//    //NSDictionary *extras = [userInfo valueForKey:@"extras"];
//    NSLog(@"content:%@",content);
//}

- (IBAction)upBottomStart:(UISlider*)sender {
    FaceNode*face =(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    [self.skView setFastFrameRate];
    if (cacheFaceY==0) {
        cacheFaceY=face.position.y;
    }
    
   
}
- (IBAction)endAdjust:(id)sender {
    [self.skView setSlowFrameRate];
}

//delegate调用 非slider调用
- (IBAction)upBottomEnd:(UISlider*)sender {
    if (cacheFaceY==0) {
        return;
    }
    
    FaceNode*face =(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    [face setPosition:CGPointMake(face.position.x, cacheFaceY)];
    cacheFaceY=0;

}
- (IBAction)adjustTopBottom:(UISlider*)sender {
    NSLog(@"adjust:%f",sender.value);

    FaceNode*face =(FaceNode*)[[SKSceneCache singleton].scene childNodeWithName:faceLayerName];
    if (cacheFaceY==0) {
        return;
    }
    
    [face setPosition:CGPointMake(face.position.x, cacheFaceY+sender.value*40)];

}

-(void)clickShake{
    shakeViewWrapper.alpha=1.0;
}
- (IBAction)stopShake:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"QUIT_SHAKE_MODE" object:self];
}
- (IBAction)readyToShake:(id)sender {
    self.iconScrollView.inModeOfShake=YES;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RESET_ICONBUTTON" object:self];
    shakeViewWrapper.alpha=0.0;
}

-(void)removeGuide{
    NSLog(@"tap");
    __weak typeof(self) weakSelf=self;
    if([self.blurview viewWithTag:56823])
    {
        self.alertView=[[SCLAlertView alloc]init];
        [self.alertView addButton:NSLocalizedString(@"Leave", @"离开")  actionBlock:^{
            UIView*guideView=   [weakSelf.blurview viewWithTag:56823];
            [UIView animateWithDuration:0.8 animations:^{
                guideView.alpha=0.f;
            } completion:^(BOOL finished) {
                [guideView removeFromSuperview];
            }];
        }];
        [weakSelf.alertView showWarning:weakSelf title:NSLocalizedString(@"Leave tutorial?", @"离开教程?") subTitle:@"" closeButtonTitle:NSLocalizedString(@"NO",@"不") duration:0.f];
        
    }

}
@end



