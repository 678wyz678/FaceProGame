//
//  DPI300Node.h
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FeatureLayer.h"
#import "BaseEntity.h"
#import "P_Order.h"
#import "P_Dragable.h"
@interface DPI300Node : SKSpriteNode<P_Order,P_Dragable>


@property NSString* tag;//中文标签
@property (nonatomic)BaseEntity *currentEntity;
@property (nonatomic)BaseEntity *backupEntity;

@property(assign,nonatomic)BOOL needReverseAfterHasAction;

-(BOOL)changeTexture:(BaseEntity*)entity;
-(void)changeTextureWithReverse:(BaseEntity *)entity;
-(void)reverseAction;

-(instancetype) initWithEntity:(BaseEntity *)entity;

@property (assign)int selectedPriority;
@property (assign)BOOL selectable;
@property (nonatomic)NSString* currentImageFile;

//判断此node是否为PairNode的副手
@property(nonatomic)BOOL isViceSir;

//判断是否是新添加的node,用于：
//比如还没有glass node ,但是用户点击了一个 package包预览，则如此属性值为yes,则removeFromParent;
@property (assign,nonatomic)BOOL newAdded;



//是否需要随机颜色
@property(assign,nonatomic)BOOL dontRandomColor;
@end
