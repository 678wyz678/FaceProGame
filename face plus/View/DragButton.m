//
//  DragButton.m
//  face plus
//
//  Created by linxudong on 12/8/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "DragButton.h"
#import "ViewController.h"
#import "DownToUpDelegate.h"
#import "UIButton+Extensions.h"
#define UIViewParentController(view) ({ \
UIResponder *responder = view; \
while ([responder isKindOfClass:[UIView class]]) \
responder = [responder nextResponder]; \
(UIViewController *)responder; \
})
@implementation DragButton
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        [self setHitTestEdgeInsets:UIEdgeInsetsMake(-140, -80, -140, -80)];
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

//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    
//    CGPoint touchLocation=[[touches anyObject] locationInView:self];
//    CGPoint prevouseLocation=[[touches anyObject] previousLocationInView:self];
//    float yDiffrance=touchLocation.y-prevouseLocation.y;
//    ViewController* controller=(ViewController*)UIViewParentController(self);
//    controller.bottomViewHeightConstraint.constant-=yDiffrance;
//}

@end
