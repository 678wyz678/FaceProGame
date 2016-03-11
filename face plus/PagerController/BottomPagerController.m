//
//  BottomPagerController.m
//  face plus
//
//  Created by linxudong on 14/11/6.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "BottomPagerController.h"
#import "ColorCollectionViewController.h"
#import "ViewControllerSource.h"
static NSInteger currentShowNotColorViewControllerIndex;
static BOOL lastIsColorController;
@interface BottomPagerController ()

@end

@implementation BottomPagerController
-(instancetype) initWithTransitionStyle:(UIPageViewControllerTransitionStyle)style navigationOrientation:(UIPageViewControllerNavigationOrientation)navigationOrientation options:(NSDictionary *)options{
    self=[super initWithTransitionStyle:style navigationOrientation:navigationOrientation options:options];
    if (self) {
        self.source=[[ViewControllerSource alloc]init];
        self.dataSource=self.source;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScrollEnabled:) name:@"SET_PAGE_CONTROLLER_ENABLED" object:nil];
        
       
    }
    return self;

}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if (self) {
        self.source=[[ViewControllerSource alloc]init];
        self.dataSource=self.source;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setScrollEnabled:) name:@"SET_PAGE_CONTROLLER_ENABLED" object:nil];
        
        [self.gestureRecognizers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIGestureRecognizer*gesture=(UIGestureRecognizer*)obj;
            if ([gesture isKindOfClass:[UITapGestureRecognizer class]]) {
                gesture.enabled=NO;
            }
        }];

        
    }
    return self;

}


-(void)setScrollEnabled:(NSNotification*)sender{
    BOOL enabled=((NSNumber*)[sender.userInfo objectForKey:@"ENABLED"]).boolValue;
    
    for(UIView* view in self.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]){
            UIScrollView* scrollView=(UIScrollView*)view;
            [scrollView setScrollEnabled:enabled];
            return;
        }
    }
}




-(instancetype)init{
    self=[super init];
    if (self) {
        _source=[[ViewControllerSource alloc]init];
       self.dataSource=self.source;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//切换pager页面
-(void)switchPageController:(NSArray*)array{
    id controller=[array firstObject];
    if (![controller isKindOfClass:[ColorCollectionViewController class]]) {
        currentShowNotColorViewControllerIndex=[controller index];
        lastIsColorController=NO;
    }
    else{
        if (lastIsColorController) {
            array=@[[self.source viewControllerAtIndex:currentShowNotColorViewControllerIndex]];
            
            lastIsColorController=NO;
        }
        else{
            lastIsColorController=YES;
            
        }
    }
   
    
    __weak UIPageViewController* pvcw = self;
    [self setViewControllers:array
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES completion:^(BOOL finished) {
                                           UIPageViewController* pvcs = pvcw;
                                           if (!pvcs) return;
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [pvcs setViewControllers:array
                                                              direction:UIPageViewControllerNavigationDirectionForward
                                                               animated:NO completion:nil];
                                           });
                                       }];
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
