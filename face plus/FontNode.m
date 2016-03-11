//
//  FontNode.m
//  face plus
//
//  Created by linxudong on 1/2/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "FontNode.h"

@implementation FontNode
@synthesize order;
@synthesize curAngle;
@synthesize curPosition;
@synthesize curScaleFactor;



-(instancetype)init{
    self=[super init];
    if (self) {
        self.selectable=YES;
       self.order=17;
        self.name=@"font";
        self.fontName=@"MFJinHei_Noncommercial-Regular";
        self.selectedPriority=1;
    }
    return self;
}



-(void)drag:(NSValue*)dest{
      //获得的值是方向相反所以用减法
    CGPoint finalPosition=CGPointMake(self.curPosition.x+dest.CGPointValue.x/3,self.curPosition.y-dest.CGPointValue.y/3);
        [self setPosition:finalPosition];
    
}

-(void)zoom:(NSNumber*)scaleFactor{
    if (scaleFactor.floatValue*self.curScaleFactor<3.f) {
        [self setScale:scaleFactor.floatValue*self.curScaleFactor];

    }
}


//换颜色
-(void)color:(UIColor *)color{
    self.fontColor=color;
    
}
-(void)rotateMyself:(NSNumber*)angle{
    [self setZRotation:self.curAngle+angle.floatValue];
}
@end
