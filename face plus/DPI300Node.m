//
//  DPI300Node.m
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "Pixel2Point.h"
#import "BaseEntity.h"
#import "P_Order.h"
#import "PLUS_SKView.h"
#import "P_Dragable.h"
#import "P_Rotate.h"
#import "PairNodes.h"
#import "P_Zoom.h"
#import "Color2Image.h"
#import "GaussianBlurNode.h"
#import "P_Colorable.h"
@implementation DPI300Node
@synthesize curPosition=_curPosition;
@synthesize order;
-(instancetype) initWithImageNamed:(NSString *)name{
    
    self=[super initWithImageNamed:name];
    if (self!=nil) {
        self.selectedPriority=0;
        self.size=[Pixel2Point pixel2point:self.size];
        self.blendMode=SKBlendModeAlpha;
        self.colorBlendFactor=1;
        self.color=[UIColor whiteColor];
        
        self.selectable=YES;
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(randomColor) name:@"RANDOM_ALL_COLOR" object:nil];
    }
        return self;
}


-(instancetype) initWithEntity:(BaseEntity *)entity{

    self=[self initWithImageNamed:entity.selfFileName];
    self.currentEntity=entity;

    return self;
}

-(instancetype) initWithTexture:(SKTexture *)texture{
    
    self=[super initWithTexture:texture];
    if (self!=nil) {
        self.selectedPriority=0;
        self.size=[Pixel2Point pixel2point:self.size];
        self.blendMode=SKBlendModeAlpha;
        self.colorBlendFactor=1;
        self.color=[UIColor whiteColor];
        self.selectable=YES;
        self.isViceSir=NO;
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(randomColor) name:@"RANDOM_ALL_COLOR" object:nil];

    }
    return self;
}
//
//-(void)setHidden:(BOOL)hidden{
//    if (hidden) {
//        [self removeFromParent];
//    }
//}



-(BOOL)changeTexture:(BaseEntity *)entity{
    self.currentEntity=entity;
    return YES;
}

-(void)changeTextureWithReverse:(BaseEntity *)entity{
    if(!self.hasActions){
    BaseEntity*backupEntity=self.currentEntity;
    if (!backupEntity) {
        [self removeFromParent];
        return;
    }
  BOOL ok=  [self changeTexture:entity];
    if (ok) {
        self.backupEntity=backupEntity;

    }
    }
}



-(void)reverseAction{
    if (self.hasActions) {
        self.needReverseAfterHasAction=YES;
        NSLog(@"has action");
    }
    else{

        //如果是因为还没有node,但是点击了加装包预览图，则不管有没有backupentity，都removeFromParent
        if (self.newAdded) {
            NSLog(@"new added");

            [self removeFromParent];
            return;
        }
        else{
            NSLog(@"else");

            [self changeTexture:self.backupEntity];
        }

    }
}




-(void)runAction:(SKAction *)action{
    PLUS_SKView* skview = (PLUS_SKView*)self.scene.view;

    [skview setFastFrameRate];
    [super runAction:action completion:^{
        if (self.needReverseAfterHasAction) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.needReverseAfterHasAction=NO;
                [self reverseAction];
                
            });
        }
        [skview setSlowFrameRate];
     }];
}
-(void)runAction:(SKAction *)action completion:(void (^)())block{
    PLUS_SKView* skview = (PLUS_SKView*)self.scene.view;
    [skview setFastFrameRate];

    void(^actionCompletion)() = ^() {
        block();
        if (self.needReverseAfterHasAction) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.needReverseAfterHasAction=NO;
                [self reverseAction];
                
            });
        }
        [skview setSlowFrameRate];
    };
    [super runAction:action completion:actionCompletion];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super initWithCoder:aDecoder]) {
        _currentImageFile=[aDecoder decodeObjectForKey:@"currentImageFile"];
        _currentEntity=[aDecoder decodeObjectForKey:@"currentEntity"];
        _backupEntity=[aDecoder decodeObjectForKey:@"backupEntity"];
        _needReverseAfterHasAction = ((NSNumber*)[aDecoder decodeObjectForKey:@"needReverseAfterHasAction"]).boolValue;

        _isViceSir = ((NSNumber*)[aDecoder decodeObjectForKey:@"isViceSir"]).boolValue;
        self.hidden = ((NSNumber*)[aDecoder decodeObjectForKey:@"hidden"]).boolValue;

        _selectable = ((NSNumber*)[aDecoder decodeObjectForKey:@"seletable"]).boolValue;
        _newAdded = ((NSNumber*)[aDecoder decodeObjectForKey:@"newAdded"]).boolValue;
        _selectedPriority = ((NSNumber*)[aDecoder decodeObjectForKey:@"selectedPriority"]).intValue;
        _curPosition = ((NSValue*)[aDecoder decodeObjectForKey:@"curPosition"]).CGPointValue;
        _tag=[aDecoder decodeObjectForKey:@"tag"];
        
        _dontRandomColor=((NSNumber*)[aDecoder decodeObjectForKey:@"dontRandomColor"]).boolValue;
        if ([self conformsToProtocol:@protocol(P_Order)]) {
            self.order=((NSNumber*)[aDecoder decodeObjectForKey:@"order"]).integerValue;
        }
        if ([self conformsToProtocol:@protocol(P_Dragable)]) {
            self.curPosition=((NSValue*)[aDecoder decodeObjectForKey:@"curPosition"]).CGPointValue;
        }
        if ([self conformsToProtocol:@protocol(P_Zoom)]) {
            id<P_Zoom> obj=(id<P_Zoom>)self;
            obj.curScaleFactor =((NSNumber*)[aDecoder decodeObjectForKey:@"curScaleFactor"]).floatValue;
        }
        if ([self conformsToProtocol:@protocol(PairNodes)]) {
            id<PairNodes> obj=(id<PairNodes>)self;
            obj.bindActionNode=[aDecoder decodeObjectForKey:@"bindActionNode"];
        }
        if ([self conformsToProtocol:@protocol(P_Rotate)]) {
            id<P_Rotate> obj=(id<P_Rotate>)self;
            obj.curAngle=((NSNumber*)[aDecoder decodeObjectForKey:@"curAngle"]).floatValue;
        }
        if ([self conformsToProtocol:@protocol(P_Colorable)]) {
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(randomColor) name:@"RANDOM_ALL_COLOR" object:nil];
        }
        GaussianBlurNode*blurNode=(GaussianBlurNode*)[self childNodeWithName:gaussianBlurLayerName] ;
        if (blurNode) {
            [blurNode removeFromParent];
            blurNode=[[GaussianBlurNode alloc]initWithParentNode:self];
            [blurNode reSizeBlur:[NSValue valueWithCGSize:CGSizeMake(self.size.width/self.xScale, self.size.height/self.yScale)]];
            [self addChild:blurNode];
        }
        
        
        
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.currentImageFile forKey:@"currentImageFile"];
    [aCoder encodeObject:self.currentEntity forKey:@"currentEntity"];
    [aCoder encodeObject:self.backupEntity forKey:@"backupEntity"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.needReverseAfterHasAction] forKey:@"needReverseAfterHasAction"];

    [aCoder encodeObject:[NSNumber numberWithBool:self.isViceSir] forKey:@"isViceSir"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.hidden] forKey:@"hidden"];

    [aCoder encodeObject:[NSNumber numberWithBool:self.selectable] forKey:@"seletable"];
    [aCoder encodeObject:[NSNumber numberWithInt:self.selectedPriority] forKey:@"selectedPriority"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.newAdded] forKey:@"newAdded"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.dontRandomColor] forKey:@"dontRandomColor"];

    [aCoder encodeObject:_tag forKey:@"tag"];
    if ([self conformsToProtocol:@protocol(P_Order)]) {
        [aCoder encodeObject:[NSNumber numberWithInteger:self.order] forKey:@"order"];
    }
    
    
    
    if ([self conformsToProtocol:@protocol(P_Dragable)]) {
        [aCoder encodeObject:[NSValue valueWithCGPoint:self.curPosition] forKey:@"curPosition"];
    }
    if ([self conformsToProtocol:@protocol(P_Zoom)]) {
        id<P_Zoom> obj=(id<P_Zoom>)self;
        [aCoder encodeObject:[NSNumber numberWithFloat:obj.curScaleFactor] forKey:@"curScaleFactor"];
    }
    if ([self conformsToProtocol:@protocol(PairNodes)]) {
        id<PairNodes> obj=(id<PairNodes>)self;
        [aCoder encodeObject:obj.bindActionNode forKey:@"bindActionNode"];
    }
    if ([self conformsToProtocol:@protocol(P_Rotate)]) {
        id<P_Rotate> obj=(id<P_Rotate>)self;
        [aCoder encodeObject:[NSNumber numberWithFloat: obj.curAngle ] forKey:@"curAngle"];
    }
    
    
  
}


-(void)drag:(NSValue *)dest{

}



-(void)randomColor{
    if (![self conformsToProtocol:@protocol(P_Colorable)]||self.dontRandomColor) {
        return;
    }
    
    id<P_Colorable> colorSelf=(id<P_Colorable>)self;
    
    [colorSelf color:[Color2Image random]];
}




- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
