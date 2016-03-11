//
//  MyScene.h
//  face plus
//
//  Created by linxudong on 14/10/31.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "AccessoryRecordObject.h"
@class FaceNode;






@interface MyScene : SKScene<SKPhysicsContactDelegate>
@property(weak) FaceNode* faceNode;

@property CGFloat lineWidth;
@property CGFloat lineScale;
@property (nonatomic)Byte backgroundState;
@property UIColor* lineColor;



@property(nonatomic) UIImage* background;


@property CGFloat gridScale;
@property CGFloat gridDensity;

@property NSMutableDictionary* currentIndexPathDictionary;//MyCollectionViewController
@property NSMutableSet*selectedCellIndexPath;//HuazhuangBao
@property NSMutableSet* selectedCellIndexPathInNormalPackage;//HuazhuangBao
@property NSIndexPath* backgroundSelectedPath;

//纪录accessory的使用记录的set
@property NSMutableSet* recordsOfAccessoryUsage;
@property NSMutableSet* recordsOfFrontHairUsage;
@property NSMutableSet* recordsOfBehindHairUsage;



-(void)addRecordForFrontHair:(AccessoryRecordObject*)object;
-(void)removeRecordForFrontHair:(AccessoryRecordObject*)object;
-(void)addRecordForBehindHair:(AccessoryRecordObject*)object;
-(void)removeRecordForBehindHair:(AccessoryRecordObject*)object;
-(void)removeAllRecordOfBehindHair;
-(void)removeAllRecordOfFrontHair;


-(void)addRecord:(AccessoryRecordObject*)object;
-(void)removeRecord:(AccessoryRecordObject*)object;
-(void)removeAllRecord;

-(void)changeBackgroundGridTexture:(SKTexture*)texture;
-(void)changeBackgroundGridColor:(UIColor*)color;
-(void)changeScale:(CGFloat)scaleFactor;
-(void)changeDensity:(CGPoint)density;
-(void)backupGridState;


-(void)make135DLines;
-(void)make45DLines;
-(void)makeVerticalLines;
-(void)makeHorizontalLines;
-(void)makeCircleLine;
-(void)makeRadioLine;


-(void)removeGrid;

-(void)setCaptureMask;
-(void)setVisibleCaptureMask;
@end
 