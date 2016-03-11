//
//  DownToUpDelegate.m
//  face plus
//
//  Created by linxudong on 14/11/7.
//  Copyright (c) 2014年 Willian. All rights reserved.
//
#define ROTATE_LEFT(x, n,s) ((x) << (n)) | ((x) >> ((s) - (n)))

#define ROTATE_RIGHT(x, n, s) ((x) >> (n)) | ((x) << ((s) - (n)))

#import "DownToUpDelegate.h"
#import "SKSceneCache.h"
#import "ImportAllEntity.h"
#import "FeatureLayer.h"
#import "ViewController.h"
#import "PLUS_SKView.h"
#import "DPI300Node.h"
#import "P_Colorable.h"
#import "ColorPicker.h"
#import "WhelkNode.h"
#import "MyScene.h"
#import "BeardNode.h"
#import "UnderEyeLeftNode.h"
#import "EyeLeftNode.h"
#import "EyelashLeftNode.h"
#import "UIImage+Color.h"
#import "BottomPagerController.h"
#import "ViewControllerSource.h"
#import "IconScrollView.h"
#import "FrontHairNode.h"
#import "BehindHairNode.h"
#import "UIImage+Color.h"
#import "Color2Image.h"
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
@interface DownToUpDelegate ()<ColorPickerDelegate>
{
    CGFloat transparentAndDragHeight;
    CGFloat verticalBottomHeight;
    CGFloat verticalBottomContentWidth;

    CGFloat bottomViewMaxHeight;
}

@end

static DownToUpDelegate* instance=nil;
static int colorButtonTag=768;
@implementation DownToUpDelegate

- (instancetype)init
{
    
    self = [super init];
    if (self) {
        [ColorPicker setDelegate:self];
        transparentAndDragHeight=40.0;
        verticalBottomHeight=50;
        
        //计算底部content width
        int iconNum=18;
        
        CGFloat margin=(SCREEN_SIZE.width-100-22*5)/5;
        CGFloat sideMargin=(SCREEN_SIZE.width-100)/2.0-22/2.0;
        //计算contentview宽度
        verticalBottomContentWidth=margin*(iconNum-1)+sideMargin*2+iconNum*50*0.818;
        
        //当前状态中间为0x02(趋势向上),0x20(趋势向下)，上为0x08(趋势向下),下为0x80(趋势向上)
        currentState=0x02;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receiveNotificationForScrollViewLocation:) name:@"UPDATE_LOCATION_OF_SCROLLVIEW" object:nil];
    }
    return self;
}





//
-(void)updateFocus:(BaseEntity*)entity setCurrentNode:(BOOL)notSetCurrentNode{
    
   // dispatch_async(dispatch_get_main_queue(), ^{
        
    BOOL currentNodeIsSet=YES;

    SKScene* scene=(SKScene*)[SKSceneCache singleton].scene;
    if (entity&&!notSetCurrentNode) {
        self.viewController.ifSlide=false;
        

        
        SKSpriteNode* faceNode=(SKSpriteNode*)[scene childNodeWithName:faceLayerName];
        if ([entity isKindOfClass:[NoseEntity class]]) {
           self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:noseLayerName];
        }
       else if ([entity isKindOfClass:[MouthEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:mouthLayerName];
        }

      else  if ([entity isKindOfClass:[EyeEntity class]]||[entity isKindOfClass:[DoubleEyeEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:eyeLeftLayerName];
        }
       else if ([entity isKindOfClass:[EarEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:earLayerName];
        }
       else if ([entity isKindOfClass:[BrowEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:browLeftLayerName];
        }
       else if ([entity isKindOfClass:[HairEntity class]]||[entity isKindOfClass:[GirlHairEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:hairLayerName];
        }
       else if ([entity isKindOfClass:[FaceEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)faceNode ;
        }
       else if ([entity isKindOfClass:[EyeballEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[[[faceNode childNodeWithName:eyeLeftLayerName]childNodeWithName:eyeballCropLayerName] childNodeWithName:eyeballLayerName] ;
        }
       else if ([entity isKindOfClass:[GlassEntity class]]||[entity isKindOfClass:[SingleGlassEntity class]]) {
            self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:glassLayerName];
        }
       else if ([entity isKindOfClass:[WhelkEntity class]]) {
            //whelkStack为whelkNode文件中定义的whelk栈
            WhelkNode* whelk=[[WhelkNode multipleNodeStack] lastObject];
            if (whelk) {
                self.viewController.currentNode=whelk;
            }
        }
       else if ([entity isKindOfClass:[NeckEntity class]]||[entity isKindOfClass:[BodyEntity class]]) {
         DPI300Node*node= (DPI300Node*) [faceNode childNodeWithName:neckLayerName];
           DPI300Node*body= (DPI300Node*) [faceNode childNodeWithName:bodyLayerName];

           if (node&&node.hidden==NO) {
               self.viewController.currentNode= node;
           }
           else if (body&&body.hidden==NO) {
               self.viewController.currentNode= body;
           }
           
        }
        
       else if ([entity isKindOfClass:[WhelkEntity class]]) {
           //whelkStack为whelkNode文件中定义的whelk栈
           WhelkNode* whelk=[[WhelkNode multipleNodeStack] lastObject];
           if (whelk) {
               self.viewController.currentNode=whelk;
           }
       }
       else if ([entity isKindOfClass:[CapEntity class]]||[entity isKindOfClass:[CapWithBackgroundEntity class]]) {
           self.viewController.currentNode= (DPI300Node*)[faceNode childNodeWithName:capLayerName];
       }
       else if ([entity isKindOfClass:[FrontHairEntity class]]) {
            DPI300Node*node= (DPI300Node*)[faceNode childNodeWithName:frontHairLayerName];
           
           if (node&&![self.viewController.currentNode isKindOfClass:[FrontHairNode class]]) {
               self.viewController.currentNode=node;
           }
       }
       else if ([entity isKindOfClass:[BehindHairEntity class]]) {
           DPI300Node*node= (DPI300Node*)[faceNode childNodeWithName:behindHairLayerName];
           if (node&&![self.viewController.currentNode isKindOfClass:[BehindHairNode class]]) {
               self.viewController.currentNode=node;
           }
       }
       else if ([entity isKindOfClass:[WhiskerEntity class]]||[entity isKindOfClass:[BeardEntity class]]) {
         SKCropNode*crop=  (SKCropNode*)[faceNode childNodeWithName:faceCropLayerName];
           DPI300Node*whiker= (DPI300Node*)[crop childNodeWithName:whiskerLayerName];
           DPI300Node*beard=(DPI300Node*)[faceNode childNodeWithName:beardLayerName];
           
           if (whiker&&whiker.hidden==NO) {
               self.viewController.currentNode=whiker;
           }
           else if(beard&&beard.hidden==NO){
               self.viewController.currentNode=beard;

           }
       }

       else if ([entity isKindOfClass:[BrowLikeSmallBeardEntity class]]||[entity isKindOfClass:[SmallBeardEntity class]]) {
           DPI300Node*browLike= (DPI300Node*)[faceNode childNodeWithName:browLikeSmallBeardLayerName];
           DPI300Node*smallBeard=(DPI300Node*)[faceNode childNodeWithName:smallBeardLayerName];
           
           if (browLike&&browLike.hidden==NO) {
               self.viewController.currentNode=browLike;
           }
           else if(smallBeard&&smallBeard.hidden==NO){
               self.viewController.currentNode=smallBeard;
           }
       }

        
        
       else if ([entity isKindOfClass:[TattooEntity class]]) {
           SKCropNode*crop=  (SKCropNode*)[faceNode childNodeWithName:faceCropLayerName];
           self.viewController.currentNode= (DPI300Node*)[crop childNodeWithName:tattooLayerName];

       }
       else if ([entity isKindOfClass:[UnderEyeEntity class]]) {
           EyeLeftNode*eyeLeft=  (EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName];
           UnderEyeLeftNode* underLeftEye=(UnderEyeLeftNode*)[eyeLeft childNodeWithName:underEyeLeftLayerName];
           
           self.viewController.currentNode= underLeftEye;
       }
        
       else if ([entity isKindOfClass:[EyelashEntity class]]) {
           EyelashLeftNode*eyeLeft=  (EyelashLeftNode*)[[faceNode childNodeWithName:eyeLeftLayerName] childNodeWithName:eyelashLeftLayerName];
           self.viewController.currentNode= eyeLeft;
       }
        self.viewController.ifSlide=true;

    }
    
    

    
    else if(entity==nil){
        self.viewController.currentNode= [scene childNodeWithName:@"font"];
        currentNodeIsSet=NO;
    }
    
    
    else{
        currentNodeIsSet=NO;
    }
    
    if (currentNodeIsSet&&[self.viewController.currentNode isKindOfClass:[DPI300Node class]]) {
        DPI300Node*dpi300=(DPI300Node*)self.viewController.currentNode;
        [self.viewController guideUser:dpi300.order] ;
    }
    
    

    
//    if (notSetCurrentNode) {
        //如果不是从tap来的则不进行拖动
        if (currentState==0x80&&_viewController.fromTapNotReLoadView) {
            NSLog(@"dragButtonHandler");
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dragButtonHandler];
            });
        }
        
    //}
        
     //    });//end dispatch
        
}
                   
                   
//记得要在第一次singleton初始化后设置viewcontroller属性
+(instancetype)singleton{
    if (!instance) {
        instance=[[super alloc]init];
            }
    return instance;
}

-(void)ListUpAndDown:(UIPanGestureRecognizer *)sender{
    ViewController * controller=self.viewController;
    if (bottomViewMaxHeight==0) {
        //如果是ios7就把bottomview调整空间换为两格最大
        //if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
         //   bottomViewMaxHeight=controller.standardHeight;
        //}
       // else{
            bottomViewMaxHeight=SCREEN_SIZE.height-SCREEN_SIZE.width*2.0/3.0;
       // }
    }
    
    CGPoint curPoint=[sender translationInView:controller.view];
    if (curPoint.y!=0.f) {
        CGFloat finalHeight=-curPoint.y+controller.bottomViewCurrentHeight;
        
        if (((finalHeight<bottomViewMaxHeight))&&finalHeight>verticalBottomHeight) {
            //向上拉
            controller.bottomViewHeightConstraint.constant=finalHeight;
            
            if(finalHeight>=controller.standardHeight){
                //如果是从下面穿过中间划到上面 比例中的curpoint.y需要减去standardheight
                if (controller.bottomViewCurrentHeight<controller.standardHeight) {
                    curPoint.y=-(finalHeight-controller.standardHeight);
                }
                
                
                //拉的比例
                CGFloat ratio=-curPoint.y/(SCREEN_SIZE.height-SCREEN_SIZE.width*2/3.0-controller.standardHeight);
                
                if (ratio<0) {
                    ratio=1-ABS(ratio);
                }
                //skView右移(22为transparent和drag高度)
                CGFloat deltaLeftMargin=(SCREEN_SIZE.width/2.0)*(ratio);
                [controller.skviewcon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
                    if (constraint) {
                        constraint.constant=deltaLeftMargin;
                    }
                }];
                
                
                //调整leftskview的alpha值
                controller.leftSKView.alpha=ratio;
                controller.scaleSlider.alpha=ABS(1-ratio);
                controller.previousButton.alpha=ABS(1-ratio);
                controller.nextButton.alpha=ABS(1-ratio);
                
                
                controller.leftImageRightMargin.constant=deltaLeftMargin;
            }
            
            //finnalheight在standard height之下
            else{
                curPoint.y=-(controller.standardHeight-finalHeight);
                
                //拉的比例
                CGFloat ratio=-curPoint.y/(controller.standardHeight-transparentAndDragHeight);
                if (ratio<0) {
                    ratio=1-ABS(ratio);
                }
                [controller.skviewcon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
                    if (constraint) {
                        constraint.constant=-40*ratio;
                    }
                }];
                
                [controller.skViewRightMargin enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
                    if (constraint) {
                        constraint.constant=-40.0f*ratio;
                    }
                }];
            }
        }
        
        
        [controller.view layoutIfNeeded];
    }
    
    
    
    if (sender.state==UIGestureRecognizerStateEnded||sender.state==UIGestureRecognizerStateCancelled) {
        CGPoint  speed=[sender velocityInView:controller.view];
        //上上
        if (speed.y<=0&&controller.bottomViewHeightConstraint.constant>controller.standardHeight) {
            currentState=0x08;
            [self verticalTop];
        }//if 向上滑动 结束
        
        
        
        //上下或者下上
        else if((speed.y>0&&controller.bottomViewHeightConstraint.constant>controller.standardHeight)
                ||
                (speed.y<0&&controller.bottomViewHeightConstraint.constant<controller.standardHeight))  {
            if (speed.y>0) {
                currentState=0x20;
            }
            else{
                currentState=0x02;
            }
            [self verticalCenter];

         }
        //下下
        else if(speed.y>0&&controller.bottomViewHeightConstraint.constant<controller.standardHeight){
            currentState=0x80;
            [self verticalBottom];
        }
        
    }
   

}


-(void)dragButtonHandler{
    currentState=ROTATE_LEFT(currentState, 2, 8);
//    if (currentState==0x08&&floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
//        currentState=ROTATE_LEFT(currentState, 2, 8);
//        currentState=ROTATE_LEFT(currentState, 2, 8);
//
//    }
    switch (currentState) {
        case 0x02:
            [self verticalCenter];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"QUIT_SHAKE_MODE" object:self];
            break;
        case 0x20:
           [self verticalCenter];
            break;

        case 0x08:
       [self verticalTop];
            break;
        case 0x80:
     [self verticalBottom];
            break;
        default:
            break;
    }
    
    
}

- (BOOL)shouldChangeColorTo:(UIColor *)color{
    [self changeColor:color];
    return YES;
}

-(void)changeColor:(UIColor *)color{
    DPI300Node*node=self.viewController.currentNode;
    if (node&&[node conformsToProtocol:@protocol(P_Colorable)]) {
        id<P_Colorable> colorable=(id<P_Colorable>)node;
        [colorable color:color];

        
    }
    
}

//截图
-(UIImage*)captureSKView{
    
    ViewController* controller=self.viewController;
    
    //画布后台前台准备
    CGImageRef ref=(__bridge CGImageRef)controller.view.layer.contents;
    UIImage*background=[UIImage imageWithCGImage:ref];
    
    
    //隐藏不必要的组建
    [controller.skView viewWithTag:colorButtonTag].hidden=YES;
    controller.previousButton.hidden=YES;
    controller.nextButton.hidden=YES;
    controller.scaleSlider.hidden=YES;
    controller.adjustSlider.hidden=YES;

    UIGraphicsBeginImageContextWithOptions(CGSizeMake(controller.skView.bounds.size.width, controller.skView.bounds.size.height) , NO, 3.0);
    [controller.skView drawViewHierarchyInRect:CGRectMake(0, 0, controller.skView.bounds.size.width, controller.skView.bounds.size.height) afterScreenUpdates:YES];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext(); 
    
    //恢复可见性
    [controller.skView viewWithTag:colorButtonTag].hidden=NO;
    controller.previousButton.hidden=NO;
    controller.nextButton.hidden=NO;
    controller.scaleSlider.hidden=NO;
    controller.adjustSlider.hidden=NO;

    CGFloat heightRatio=4/3.f;
    NSInteger export4_4=[[NSUserDefaults standardUserDefaults] integerForKey:@"Export_4-4"];
    if (export4_4) {
        heightRatio=1.0f;
    }
    CGSize photoLibrarySize=CGSizeMake(SCREEN_SIZE.width*4, SCREEN_SIZE.width*4*heightRatio);
    //开始合成图片(photo library)
    UIGraphicsBeginImageContext(photoLibrarySize);
    if (!floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
    [background drawInRect:CGRectMake(0,0,photoLibrarySize.width, photoLibrarySize.height)];
    }
    CGFloat drawHeight=viewImage.size.height/viewImage.size.width*photoLibrarySize.width;
    [viewImage drawInRect:CGRectMake(0,(photoLibrarySize.height-drawHeight)/2.f,photoLibrarySize.width,drawHeight )];
   
    UIImage *photoImage = UIGraphicsGetImageFromCurrentImageContext();
    
    
    
    //获取背景色像素rgb
    UIColor* rgbColor=[Color2Image getRGBAsFromImage:photoImage atX:1 andY:1 count:1][0];
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha =0.0;
    [rgbColor getRed:&red green:&green blue:&blue alpha:&alpha];
    CGFloat grayValue=(red*0.299+green*0.587+blue*0.114)*255.f;
    UIColor * finalTextColor=grayValue>186.f?[UIColor blackColor]:[UIColor whiteColor];
    UIImage*waterMark=[[UIImage imageNamed:@"watermark"] imageWithTint:finalTextColor];
//    [photoImage drawInRect:CGRectMake(0,0,photoLibrarySize.width, photoLibrarySize.height+10)];
    [waterMark drawInRect:CGRectMake(photoLibrarySize.width-100*waterMark.size.width/waterMark.size.height-23,photoLibrarySize.height-105,100*waterMark.size.width/waterMark.size.height, 100) blendMode:kCGBlendModeNormal alpha:0.4];
    photoImage = UIGraphicsGetImageFromCurrentImageContext();
    

    UIGraphicsEndImageContext();
    

       return  photoImage;
}




//与外界无关的skview动画函数
-(void)verticalCenter{
    ViewController * controller=self.viewController;
    
    
    [controller.view layoutIfNeeded];
    [controller.skviewcon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=0.0f;
        }
    }];
    
    [controller.skViewRightMargin enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=0.0f;
        }
    }];

    controller.bottomViewHeightConstraint.constant=controller.standardHeight;
    controller.transparentViewHeightConstraint.constant=transparentAndDragHeight;
    controller.iconScrollViewContentHeight.constant=transparentAndDragHeight;
    controller.iconScrollViewContentWidth.constant=_viewController.iconScrollViewNormalContentWidth;
    [controller.dragButton setImage:[UIImage imageNamed:@"menu_down"] forState:UIControlStateNormal];
    controller.menuButtonHeightRatio.constant=32;

    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:10
          initialSpringVelocity:0.5
                        options:0 animations:^{
                            controller.adjustSlider.hidden=YES;

                            controller.leftSKView.alpha=0;
                            controller.scaleSlider.alpha=1;
                            controller.previousButton.alpha=1;

                            controller.nextButton.alpha=1;
                            controller.iconScrollView.hidden=NO;

                            controller.menuBar.hidden=YES;
                            controller.storeButton.hidden=YES;
                            controller.colorButton.alpha=1;

                            [controller.view viewWithTag:7749].hidden=NO;
                            [[SKSceneCache singleton].scene setCaptureMask];

                            [controller.view layoutIfNeeded];

                        }
                     completion:^(BOOL finished) {
                         [controller upBottomEnd:nil];
                     }];
  // [self toggleOperationBar];
}

-(void)verticalTop{
    ViewController * controller=self.viewController;
    [self.viewController.view layoutIfNeeded];
    
    [controller.skViewRightMargin enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=0.0f;
        }
    }];
    [controller.skviewcon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=0.0f;
        }
    }];
    
    
    //高度重新设定
    controller.bottomViewHeightConstraint.constant=SCREEN_SIZE.height-SCREEN_SIZE.width*2.0/3.0;
    //skview右移
    [controller.skviewcon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=SCREEN_SIZE.width/2.0f;
        }
    }];
    
    //leftImageView左移
    controller.leftImageRightMargin.constant=SCREEN_SIZE.width/2.0f;
    controller.transparentViewHeightConstraint.constant=transparentAndDragHeight;
    controller.iconScrollViewContentHeight.constant=transparentAndDragHeight;
    controller.iconScrollViewContentWidth.constant=_viewController.iconScrollViewNormalContentWidth;
    [controller.dragButton setImage:[UIImage imageNamed:@"menu_down"] forState:UIControlStateNormal];
    controller.menuButtonHeightRatio.constant=32;

    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:10
          initialSpringVelocity:0.5
                        options:0 animations:^{
                            controller.leftSKView.alpha=1;
                            controller.adjustSlider.hidden=YES;

                            controller.scaleSlider.alpha=0;
                            controller.previousButton.alpha=0;
                            controller.nextButton.alpha=0;
                            controller.iconScrollView.hidden=NO;
                            controller.menuBar.hidden=YES;
                            controller.storeButton.hidden=YES;
                            controller.colorButton.alpha=1;
                            [controller.view viewWithTag:7749].hidden=NO;
                           
                                [[SKSceneCache singleton].scene setCaptureMask];
                            
                            [controller.view layoutIfNeeded];
                        }
                     completion:^(BOOL finished) {
                           //[controller.leftSKView presentScene:[[SKSceneCache singleton].scene copy]];
                         
                         controller.leftSKView.hidden=NO;
                         [controller upBottomEnd:nil];

                         
                     }];///animation结束
    [self toggleOperationBar];

}
-(void)verticalBottom{
    ViewController * controller=self.viewController;

    [controller.view layoutIfNeeded];
    
    
    [controller.skViewRightMargin enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=-40.0f;
        }
    }];
    [controller.skviewcon enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSLayoutConstraint* constraint=(NSLayoutConstraint*)obj;
        if (constraint) {
            constraint.constant=-40.0f;
        }
    }];
    
    controller.bottomViewHeightConstraint.constant=verticalBottomHeight;
    controller.transparentViewHeightConstraint.constant=verticalBottomHeight;
    controller.iconScrollViewContentHeight.constant=verticalBottomHeight;
    controller.iconScrollViewContentWidth.constant=verticalBottomContentWidth;

    [controller.dragButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    controller.menuButtonHeightRatio.constant=30.9;

    [UIView animateWithDuration:0.4
                          delay:0
         usingSpringWithDamping:10
          initialSpringVelocity:0.5
                        options:0 animations:^{
                            controller.scaleSlider.alpha=1;
                            controller.adjustSlider.hidden=NO;
                            controller.leftSKView.alpha=0;
                            controller.previousButton.alpha=1;
                            controller.nextButton.alpha=1;
                            controller.iconScrollView.hidden=YES;
                            controller.menuBar.hidden=NO;
                            controller.storeButton.hidden=NO;
                            controller.colorButton.alpha=0;
                            if ([[NSUserDefaults standardUserDefaults] integerForKey:@"Export_4-4"]) {
                                [[SKSceneCache singleton].scene setVisibleCaptureMask];
                            }
                            else{
                                [[SKSceneCache singleton].scene setCaptureMask];
                            }
                            [controller.view viewWithTag:7749].hidden=YES;
                            [controller.view layoutIfNeeded];}
                     completion:^(BOOL finished) {
                         controller.adjustSlider.value=0;
                     }];

    [self toggleOperationBar];

    
   
}



-(void)updateIconScrollViewOffset:(NSInteger) index{
   UIScrollView* scrollView= _viewController.iconScrollView;
    if(scrollView){
        CGPoint target=CGPointMake((_viewController.standardMargin+40*0.818)*(index), 0);
        [scrollView layoutIfNeeded];
    [UIView animateWithDuration:0.2 animations:^{
        scrollView.contentOffset=target;
        [scrollView layoutIfNeeded];
    }];
    }
}


-(void)toggleOperationBar{
 
}


//接受此通知的表明scrollview已经offset到位了（通知来自button点击以及滑动操作）
-(void)receiveNotificationForScrollViewLocation:(NSNotification*)notification{
    NSInteger scrollViewIndex=((NSNumber*)[notification.userInfo objectForKey:@"POSITION"]).integerValue;
    
    NSArray* array=@[[_viewController.pageViewController.source viewControllerAtIndex:scrollViewIndex]];

    [_viewController.pageViewController switchPageController:array];
}


-(void)changeColorForBackgroundGrid:(UIColor*)color{
    [_viewController.skScene changeBackgroundGridColor:color];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
