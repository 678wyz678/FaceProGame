//
//  ImageScrollView.m
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ImageScrollView.h"
@interface ImageScrollViewDelegate:NSObject<UIScrollViewDelegate>
@end

@implementation ImageScrollViewDelegate
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return [scrollView viewWithTag:9420];
}
-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{

}

@end
@interface ImageScrollView ()
@property ImageScrollViewDelegate* myDelegate;
@end
@implementation ImageScrollView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        self.delegate=_myDelegate=[[ImageScrollViewDelegate alloc]init];
        [self setMaximumZoomScale:1.5];
        [self setMinimumZoomScale:0.5];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
