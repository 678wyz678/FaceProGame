//
//  ShopImageScrollView.m
//  face plus
//
//  Created by linxudong on 1/9/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ShopImageScrollView.h"
#import "ShopImageScrollVIewContentView.h"

@interface ShopImageScrollViewDelegate:NSObject<UIScrollViewDelegate>
@end

@implementation ShopImageScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
}
@end

@interface ShopImageScrollView()
@property (nonatomic)ShopImageScrollViewDelegate* myDelegate;
@property (nonatomic,assign)BOOL rightDirection;
@property(nonatomic ,assign) CGFloat contentWidth;
@end

@implementation ShopImageScrollView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.delegate=_myDelegate=[[ShopImageScrollViewDelegate alloc]init];
        _rightDirection=YES;
    NSTimer * timer1=  [NSTimer timerWithTimeInterval:0.041667*1.4 target:self selector:@selector(scrollAlways) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer1 forMode:NSDefaultRunLoopMode];
    }
    
    return self;
}

-(void)scrollAlways{
    
    ShopImageScrollVIewContentView*contentView=(ShopImageScrollVIewContentView*)[self viewWithTag:9941];
   
    _contentWidth=[[UIScreen mainScreen]bounds].size.width/4.0* (contentView.dataSource.count-3);//因为是offset，所以实际有10个，但是offset只到7

    if (self.contentOffset.x>=_contentWidth) {
        _rightDirection=NO;
    }
    else if(self.contentOffset.x<=0){
        _rightDirection=YES;
    }
    CGFloat offset=_rightDirection==YES?0.3f:-0.3f;
    self.contentOffset=CGPointMake(self.contentOffset.x+offset, 0);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end





