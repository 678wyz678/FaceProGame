//
//  ShopImageScrollVIewContentView.m
//  face plus
//
//  Created by linxudong on 1/11/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "ShopImageScrollVIewContentView.h"

@implementation ShopImageScrollVIewContentView
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
       
    }
    return self;
}


-(void)setDataSource:(NSMutableArray *)dataSource{
    if (dataSource) {
        
        //设置contentViewSize
        NSDictionary*dict=NSDictionaryOfVariableBindings(self);
        NSNumber* width=[NSNumber numberWithFloat:[[UIScreen mainScreen]bounds].size.width/4.0*dataSource.count];
        NSNumber* height=[NSNumber numberWithFloat:[[UIScreen mainScreen]bounds].size.width/4.0];
        NSDictionary*numData=NSDictionaryOfVariableBindings(width,height);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[self(width)]" options:0 metrics:numData views:dict]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(height)]" options:0 metrics:numData views:dict]];
        //end set contentViewSize;
   
    
    NSMutableArray*tempArray=[NSMutableArray new];
    
    NSNumber* imageWidth=[NSNumber numberWithFloat:[[UIScreen mainScreen]bounds].size.width/4.0];
    NSDictionary*num=NSDictionaryOfVariableBindings(imageWidth);
    _dataSource=dataSource;
    [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i=0; i<_dataSource.count;i++) {
        UIImageView *imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:_dataSource[i]]];
        [tempArray addObject:imageView];
        [self addSubview:imageView];
        
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        NSArray*hConstraints,*vConstraints;
        if (i==0) {
            NSDictionary*dict=NSDictionaryOfVariableBindings(imageView);

            hConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"|[imageView(imageWidth)]" options:0 metrics:num views:dict];
             vConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(imageWidth)]" options:0 metrics:num views:dict];
        }
        else{
            UIImageView*previousImageView=tempArray[i-1];
            NSDictionary*dict=NSDictionaryOfVariableBindings(imageView,previousImageView);

            hConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"[previousImageView]-0-[imageView(imageWidth)]" options:0 metrics:num views:dict];
             vConstraints=[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[imageView(imageWidth)]" options:0 metrics:num views:dict];
        }
        
       
        
        [self addConstraints:hConstraints];
        [self addConstraints:vConstraints];
        
    }
        
         }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
