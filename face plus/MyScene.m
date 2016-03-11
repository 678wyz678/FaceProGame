//
//  MyScene.m
//  face plus
//
//  Created by linxudong on 14/10/31.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "MyScene.h"
#import "SKSceneCache.h"
#import "FontNode.h"
#import "DPI300Node.h"
#import "PairNodes.h"
#import <math.h>
#import "Color2Image.h"
#import "MyCollectionViewController.h"
#import "HuazhuangCollectionViewController.h"
#import "FrontHairCollectionViewController.h"
#import "BehindHairCollectionViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]




@interface MyScene()
@property SKLabelNode* fontNode;
@end

@implementation MyScene
-(instancetype)initWithSize:(CGSize)size{
    self=[super initWithSize:size];
    
    
    if (self) {
        ////建立缓存
        [SKSceneCache singleton].scene=self;
        //设立锚点
        self.anchorPoint=CGPointMake(0.5, 0.5);
        self.scaleMode=SKSceneScaleModeAspectFill;
        _backgroundState=0;
        
        CGSize SCREEN_SIZE=[UIScreen mainScreen].bounds.size;
        _lineColor=[UIColor redColor];
        _recordsOfAccessoryUsage=[NSMutableSet new];
        _recordsOfBehindHairUsage=[NSMutableSet new];
        _recordsOfFrontHairUsage=[NSMutableSet new];

        //ios7添加scene背景
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
         SKSpriteNode*   background=[SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImage:[Color2Image imageWithColor:UIColorFromRGB(0xffd3e0)]]];
            background.size=SCREEN_SIZE;
            background.name=@"background";
            background.zPosition=-1000;
            background.anchorPoint=CGPointMake(0, 1);
            background.position=CGPointMake(-SCREEN_SIZE.width/2.0, SCREEN_SIZE.height/2.0);
            [self addChild:background];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSceneBackground:) name:@"UPDATE_SCENE_BACKGROUND" object:nil];
        }
        //ios 8
        else{
            self.backgroundColor=[UIColor clearColor];
            self.background=[Color2Image imageWithColor:UIColorFromRGB(0xffd3e0)];
        }
        

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFontRequest:) name:@"ADD_FONT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRequestForAddAccessory:) name:@"ADD_RECORDS_OF_ACCESSORY" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRequestForAddFrontHair:) name:@"ADD_RECORDS_OF_FRONT_HAIR" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRequestForAddBehindHair:) name:@"ADD_RECORDS_OF_BEHIND_HAIR" object:nil];

      
        _lineScale=1.0f;
        _lineWidth=2.0f;
        [self initWaterMark];
        [self initCaptureMask];
    }
    return self;
}
-(void)initCaptureMask{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {

    CGSize size=self.size;
    SKShapeNode*topMask=[SKShapeNode shapeNodeWithRect:CGRectMake(0, 0,size.width, size.width/4.0f)];
    topMask.fillColor=[UIColor colorWithWhite:0.6 alpha:0.3];
    [self addChild:topMask];
    topMask.zPosition=1000;
    topMask.position=CGPointMake(-size.width/2.0, size.width/2.0f);
    topMask.name=@"topMask";
    
    SKShapeNode*bottomMask=[SKShapeNode shapeNodeWithRect:CGRectMake(0, 0,size.width, size.width/4.0f)];
    bottomMask.fillColor=[UIColor colorWithWhite:0.6 alpha:0.3];
    [self addChild:bottomMask];
    bottomMask.zPosition=1000;
    bottomMask.position=CGPointMake(-size.width/2.0, -size.width*0.75);
    bottomMask.name=@"bottomMask";
    [self setCaptureMask];
    
    }
}

-(void)setCaptureMask{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {

  SKShapeNode* topMask=  (SKShapeNode*)[self childNodeWithName:@"topMask"];
    SKShapeNode* bottomMask=  (SKShapeNode*)[self childNodeWithName:@"bottomMask"];
    [topMask setHidden:YES];
    [bottomMask setHidden:YES];
    }
}
-(void)setVisibleCaptureMask{
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1) {

    SKShapeNode* topMask=  (SKShapeNode*)[self childNodeWithName:@"topMask"];
    SKShapeNode* bottomMask=  (SKShapeNode*)[self childNodeWithName:@"bottomMask"];
    [topMask setHidden:NO];
    [bottomMask setHidden:NO];
    }
}

//warn:ios7
-(void)changeSceneBackground:(NSNotification*)sender{
    CGSize SCREEN_SIZE=[UIScreen mainScreen].bounds.size;
    SKSpriteNode* backgroundNode=(SKSpriteNode*)[self childNodeWithName:@"background"];
    UIImage* background=(UIImage*)[sender.userInfo objectForKey:@"Background"];

    [backgroundNode setTexture:[SKTexture textureWithImage:background]];
    backgroundNode.size=SCREEN_SIZE;
}

-(void)receiveFontRequest:(NSNotification*)sender{
    NSString * font=[sender.userInfo objectForKey:@"font"];
    if (font) {
        if (!_fontNode){
            _fontNode = [[FontNode alloc]init];
             [self addChild:_fontNode];
             }
                _fontNode.text = font;
                _fontNode.fontSize = 45;
                _fontNode.fontColor = [SKColor blackColor];
                _fontNode.position = CGPointMake(0,-self.size.height/2.0+_fontNode.frame.size.height/2.0);
        NSDictionary*dict=[NSDictionary dictionaryWithObject:_fontNode forKey:@"Node"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Change_Current_Node" object:self userInfo:dict];
    }
}
- (instancetype)initWithCoder:(NSCoder *)decoder {

    if (self = [super initWithCoder:decoder]) {
        
        self.fontNode = [decoder decodeObjectForKey:@"fontNode"];
        self.background = [decoder decodeObjectForKey:@"background"];
        self.lineColor = [decoder decodeObjectForKey:@"lineColor"];
        self.lineWidth = ((NSNumber*)[decoder decodeObjectForKey:@"lineWidth"]).floatValue;
        self.lineScale=((NSNumber*)[decoder decodeObjectForKey:@"lineScale"]).floatValue;
        self.recordsOfAccessoryUsage =[NSMutableSet setWithArray: [decoder decodeObjectForKey:@"recordsOfAccessoryUsage"]];
        self.recordsOfFrontHairUsage =[NSMutableSet setWithArray: [decoder decodeObjectForKey:@"recordsOfFrontHairUsage"]];
        self.recordsOfBehindHairUsage =[NSMutableSet setWithArray: [decoder decodeObjectForKey:@"recordsOfBehindHairUsage"]];

        self.gridScale=((NSNumber*)[decoder decodeObjectForKey:@"gridScale"]).floatValue;
        self.gridDensity=((NSNumber*)[decoder decodeObjectForKey:@"gridDensity"]).floatValue;

        
        self.backgroundState=((NSNumber*)[decoder decodeObjectForKey:@"backgroundState"]).unsignedIntValue;
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            [[self childNodeWithName:@"background"] removeFromParent];
 
                       [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSceneBackground:) name:@"UPDATE_SCENE_BACKGROUND" object:nil];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveFontRequest:) name:@"ADD_FONT" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRequestForAddAccessory:) name:@"ADD_RECORDS_OF_ACCESSORY" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRequestForAddFrontHair:) name:@"ADD_RECORDS_OF_FRONT_HAIR" object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveRequestForAddBehindHair:) name:@"ADD_RECORDS_OF_BEHIND_HAIR" object:nil];

        self.faceNode=(FaceNode*)[self childNodeWithName:faceLayerName];

        
        //恢复CollectionView现场
        self.currentIndexPathDictionary=[decoder decodeObjectForKey:@"currentIndexPathDictionary"];
        self.selectedCellIndexPath=[decoder decodeObjectForKey:@"selectedCellIndexPath"];
        //background controller 恢复现场
        self.backgroundSelectedPath=[decoder decodeObjectForKey:@"backgroundSelectedPath"];
        setSelectedIndexPathForBehindHair([decoder decodeObjectForKey:@"selectedIndexPathForBehindHair"]);
        setSelectedIndexPathForFrontHair([decoder decodeObjectForKey:@"selectedIndexPathForFrontHair"]);

        [self setCaptureMask];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder{
    [super encodeWithCoder:encoder];
    [encoder encodeObject:self.fontNode forKey:@"fontNode"];
    
    
    
    
    [encoder encodeObject:self.background forKey:@"background"];
    [encoder encodeObject:self.lineColor forKey:@"lineColor"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.lineScale] forKey:@"lineScale"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.gridScale] forKey:@"gridScale"];
    [encoder encodeObject:[NSNumber numberWithFloat:self.gridDensity] forKey:@"gridDensity"];

    [encoder encodeObject:[NSNumber numberWithFloat:self.lineWidth] forKey:@"lineWidth"];
    [encoder encodeObject:[NSNumber numberWithUnsignedInt:self.backgroundState] forKey:@"backgroundState"];
    [encoder encodeObject:[NSMutableArray arrayWithArray:[self.recordsOfAccessoryUsage allObjects]] forKey:@"recordsOfAccessoryUsage"];
    [encoder encodeObject:[NSMutableArray arrayWithArray:[self.recordsOfFrontHairUsage allObjects]] forKey:@"recordsOfFrontHairUsage"];
    [encoder encodeObject:[NSMutableArray arrayWithArray:[self.recordsOfBehindHairUsage allObjects]] forKey:@"recordsOfBehindHairUsage"];


//保留collectionview 现场
    [encoder encodeObject:getDictionaryOfIndexPath() forKey:@"currentIndexPathDictionary"];
    [encoder encodeObject:getSelectedIndexPath() forKey:@"selectedCellIndexPath"];
    [encoder encodeObject:self.backgroundSelectedPath forKey:@"backgroundSelectedPath"];
    [encoder encodeObject:getSelectedIndexPathForFrontHair() forKey:@"selectedIndexPathForFrontHair"];
    [encoder encodeObject:getSelectedIndexPathForBehindHair() forKey:@"selectedIndexPathForBehindHair"];

}



-(void)makeBackgroundGrid:(SKTexture*)texture{
    
    
    
    SKSpriteNode*node=[[SKSpriteNode alloc]init];
    node.anchorPoint=CGPointMake(0, 0);
    
    
    
    CGSize ScreenSize=[UIScreen mainScreen].bounds.size;
    //NSInteger itemPerRow=6;
    //NSInteger rowPerScreen=ScreenSize.height/8.0;
    
    int curRowNum=0,curColumnNum=0;
    node.size=self.size;
    for (int i=0; i<200; i++) {
        curColumnNum++;
        if (curColumnNum>10) {
            curColumnNum=0;
            curRowNum++;
        }
        
        SKSpriteNode* star=[SKSpriteNode spriteNodeWithTexture:texture];
        star.size=CGSizeMake(ScreenSize.width/14.0, ScreenSize.width/14.0*texture.size.height/texture.size.width);
        [node addChild:star];
        star.colorBlendFactor=1.0f;
        star.color=_lineColor;
        star.alpha=0.4;
        star.name=@"star";
        if(curRowNum%2==0){
            star.position=CGPointMake(ScreenSize.width/9.0*(curColumnNum-1), ScreenSize.width/11.0*(curRowNum+1));
        }
        else{
             star.position=CGPointMake(ScreenSize.width/9.0*(curColumnNum-0.5), ScreenSize.width/11.0*(curRowNum+1));
        }
        
      
    }
    [self addChild:node];
    node.name=@"star_wrapper";
    node.anchorPoint=CGPointMake(0.5, 0.5);
    [node setPosition:CGPointMake(-ScreenSize.width/1.8, -ScreenSize.height/1.8)];
     [node setScale:1.5];
}

-(void)changeBackgroundGridTexture:(SKTexture*)texture{
    CGSize ScreenSize=[UIScreen mainScreen].bounds.size;

    if (0<(_backgroundState&0b00100000)) {
        [self randomBackground];
    }
    self.backgroundState=0b00010000;
    
    SKSpriteNode* wrapper=(SKSpriteNode*)[self childNodeWithName:@"star_wrapper"];
    if(wrapper){
    NSArray* childStars=[wrapper children];
  [childStars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      SKSpriteNode*star=(SKSpriteNode*)obj;
      [star setTexture:texture];
      star.size=CGSizeMake(ScreenSize.width/14.0, ScreenSize.width/14.0*texture.size.height/texture.size.width);
  }];}
    
    else{
        [self makeBackgroundGrid:texture];
    }
}



-(void)makeHorizontalLines{
    if (self.backgroundState&0b00100000) {
        [self randomBackground];
    }
    
    if (0<(self.backgroundState&0b00000011)) {
        [self removeLine:@"line_45n135"];
        self.backgroundState=self.backgroundState&0b00001100;

    }
    if (!8==(_backgroundState&0b00001000)) {
        self.backgroundState=(self.backgroundState|0b00001000)&(0b00001100);
        CGSize screenSize=[UIScreen mainScreen].bounds.size;
        SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
        if (!node) {
            node=[[SKSpriteNode alloc]init];
            node.size=screenSize;
            node.anchorPoint=CGPointMake(0.5, 0.5);
            node.name=@"line_container";
            [self addChild:node];
        }
        
        
        CGFloat verticalLineNumInScreen=10.f;
        CGFloat defaultLineWidth=2.f;
        //CGFloat horizontalMargin=(screenSize.width-defaultLineWidth*verticalLineNumInScreen)/(verticalLineNumInScreen-1);
        
        CGFloat horizontalLineNumInScreen=(
                                           (screenSize.height*(verticalLineNumInScreen-1)+screenSize.width-defaultLineWidth*verticalLineNumInScreen)/
                                           (screenSize.width-defaultLineWidth*verticalLineNumInScreen+defaultLineWidth*(verticalLineNumInScreen-1)));
        
        
        CGFloat verticalMargin=(screenSize.height-defaultLineWidth*horizontalLineNumInScreen)/(horizontalLineNumInScreen-1);
        //0度线
        for (int i=0; i<(int)horizontalLineNumInScreen*4; i++) {
            SKShapeNode *yourline = [SKShapeNode node];
            CGMutablePathRef pathToDraw = CGPathCreateMutable();
            CGPathMoveToPoint(pathToDraw, NULL, -screenSize.width*2-40,0 );
            CGPathAddLineToPoint(pathToDraw, NULL, screenSize.width*2+40, 0);
            yourline.path = pathToDraw;
            yourline.lineWidth=(_lineWidth==0.f)?defaultLineWidth:_lineWidth;
            yourline.alpha=0.4;
            yourline.name=@"line_hnv";
            yourline.position=CGPointMake(0,-screenSize.height*1.5+(verticalMargin+defaultLineWidth)*(i-horizontalLineNumInScreen*0.5f));
            [yourline setStrokeColor:_lineColor];
            [node addChild:yourline];
            CGPathRelease(pathToDraw);
        }
        
    }
    else{
        [self removeAllLine];
    }
    
    
    
}


-(void)makeVerticalLines{
    if (self.backgroundState&0b00100000) {
        [self randomBackground];
    }
    
    if (0<(self.backgroundState&0b00000011)) {
        [self removeLine:@"line_45n135"];
        self.backgroundState=self.backgroundState&0b00001100;
    }
    if (!4==(self.backgroundState&0b00000100)) {
        self.backgroundState=(self.backgroundState|0b00000100)&(0b00001100);
    
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    if (!node) {
        node=[[SKSpriteNode alloc]init];
        node.size=screenSize;
        node.anchorPoint=CGPointMake(0.5, 0.5);
        node.name=@"line_container";
        [self addChild:node];
    }
    

    
    CGFloat verticalLineNumInScreen=10.f;
    CGFloat defaultLineWidth=2.f;
    CGFloat horizontalMargin=(screenSize.width-defaultLineWidth*verticalLineNumInScreen)/(verticalLineNumInScreen-1);

    //90度线
    for (int i=0; i<(int)verticalLineNumInScreen*4; i++) {
        SKShapeNode *yourline = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, 0,-screenSize.height*2 );
        CGPathAddLineToPoint(pathToDraw, NULL, 0, screenSize.height*2);
        yourline.name=@"line_hnv";
        yourline.path = pathToDraw;
        yourline.lineWidth=(_lineWidth==0.f)?defaultLineWidth:_lineWidth;
        yourline.position=CGPointMake(-screenSize.width*1.5+(horizontalMargin+defaultLineWidth)*(i-verticalLineNumInScreen*0.5f),0);
        yourline.alpha=0.4;
        [yourline setStrokeColor:_lineColor];
        [node addChild:yourline];
        CGPathRelease(pathToDraw);

    }
        
    }
    else{
        [self removeAllLine];
    }
}

-(void)make135DLines{
    if (self.backgroundState&0b00100000) {
        [self randomBackground];
    }
    
    if (0<(self.backgroundState&0b00001100)) {
        [self removeLine:@"line_hnv"];
        self.backgroundState=self.backgroundState&0b00000011;

    }
    if (!2==(self.backgroundState&0b00000010)) {
        self.backgroundState=(self.backgroundState|0b00000010)&(0b00000011);
    
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    if (!node) {
        node=[[SKSpriteNode alloc]init];
        node.size=screenSize;
        node.anchorPoint=CGPointMake(0.5, 0.5);
        node.name=@"line_container";
        [self addChild:node];
    }
    
    CGFloat verticalLineNumInScreen=10.f;
    CGFloat defaultLineWidth=2.f;
    CGFloat horizontalMargin=(screenSize.width-defaultLineWidth*verticalLineNumInScreen)/(verticalLineNumInScreen-1);
    
   
    //135度线
    for (int i=0; i<(int)verticalLineNumInScreen*9; i++) {
        SKShapeNode *yourline = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, screenSize.height*-2,screenSize.height*2 );
        CGPathAddLineToPoint(pathToDraw, NULL, screenSize.height*2, screenSize.height*-2);
        yourline.name=@"line_45n135";
        yourline.path = pathToDraw;
        yourline.lineWidth=(_lineWidth==0.f)?defaultLineWidth:_lineWidth;
        yourline.position=CGPointMake(-screenSize.width*5+(horizontalMargin+defaultLineWidth)*(i),0);
        yourline.alpha=0.4;
        [yourline setStrokeColor:_lineColor];
        [node addChild:yourline];
        CGPathRelease(pathToDraw);
    }
    }
    else{
        [self removeAllLine];
    }
    
}


-(void)make45DLines{
    if (self.backgroundState&0b00100000) {
        [self randomBackground];
    }
    
    if (0<(_backgroundState&0b00001100)) {
        self.backgroundState=self.backgroundState&0b00000011;
    }
    if (!1==(_backgroundState&0b00000001)) {
        self.backgroundState=(self.backgroundState|0b00000001)&(0b00000011);
        
    CGSize screenSize=[UIScreen mainScreen].bounds.size;
    SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    if (!node) {
        node=[[SKSpriteNode alloc]init];
        node.size=screenSize;
        node.anchorPoint=CGPointMake(0.5, 0.5);
        node.name=@"line_container";
        [self addChild:node];
    }
    
    
    CGFloat verticalLineNumInScreen=10.f;
    CGFloat defaultLineWidth=2.f;
    CGFloat horizontalMargin=(screenSize.width-defaultLineWidth*verticalLineNumInScreen)/(verticalLineNumInScreen-1);
    
    //45度线
    for (int i=0; i<(int)verticalLineNumInScreen*9; i++) {
        SKShapeNode *yourline = [SKShapeNode node];
        CGMutablePathRef pathToDraw = CGPathCreateMutable();
        CGPathMoveToPoint(pathToDraw, NULL, screenSize.height*-2,screenSize.height*-2 );
        CGPathAddLineToPoint(pathToDraw, NULL, screenSize.height*2, screenSize.height*2);
        yourline.name=@"line_45n135";
        yourline.path = pathToDraw;
        yourline.lineWidth=(_lineWidth==0.f)?defaultLineWidth:_lineWidth;
        yourline.position=CGPointMake(-screenSize.width*5+(horizontalMargin+defaultLineWidth)*(i),0);
        yourline.alpha=0.4;
        [yourline setStrokeColor:_lineColor];
        [node addChild:yourline];
        CGPathRelease(pathToDraw);

    }
    }
    else{
        [self removeAllLine];
    }
}

-(void)makeCircleLine{
    if (self.backgroundState&0b00100000) {
        [self randomBackground];
    }
   
    
    if (!64==(_backgroundState&0b01000000)) {
        self.backgroundState=(self.backgroundState|0b01000000)&(0b01000000);
        CGSize screenSize=[UIScreen mainScreen].bounds.size;
        SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
        if (!node) {
            node=[[SKSpriteNode alloc]init];
            node.size=screenSize;
            node.anchorPoint=CGPointMake(0.5, 0.5);
            node.name=@"line_container";
            node.alpha=0.2;
            [self addChild:node];
        }
        
       //CGFloat defaultLineWidth=2.f;
        for (int i=0; i<20; i++) {
            CGRect circle = CGRectMake(-20-i*20, -20-i*20, 40.0+i*40, 40.0+i*40);
            SKShapeNode *shapeNode = [[SKShapeNode alloc] init];
            shapeNode.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
            shapeNode.lineWidth = (_lineWidth==0.f)?2.f:_lineWidth;
            shapeNode.name=@"circle_line";
            shapeNode.strokeColor=_lineColor;
            [node addChild:shapeNode];
        }
        
        
    }
    
    else{
        [self removeAllLine];
    }

}


//二进制:1000000
-(void)makeRadioLine{
   
    
    
    if (self.backgroundState&0b00100000) {
        [self randomBackground];
    }
    
    
    if (!128==(_backgroundState&0b10000000)) {

        self.backgroundState=(self.backgroundState|0b10000000)&(0b10000000);
        CGSize screenSize=[UIScreen mainScreen].bounds.size;
        SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
        if (!node) {
            node=[[SKSpriteNode alloc]init];
            node.size=screenSize;
            node.anchorPoint=CGPointMake(0.5, 0.5);
            node.name=@"line_container";
            node.alpha=0.4;
            [self addChild:node];
        }
        
        //CGFloat defaultLineWidth=2.f;
        for (int i=0; i<16; i++) {
            SKShapeNode *yourline = [SKShapeNode node];
            CGMutablePathRef pathToDraw = CGPathCreateMutable();
            CGPathMoveToPoint(pathToDraw, NULL, -screenSize.height,0.f );
            CGPathAddLineToPoint(pathToDraw, NULL, screenSize.height, 0.f);
            yourline.name=@"radio_line";
            yourline.zRotation=2*M_PI/12.f*i;
            yourline.path = pathToDraw;
            yourline.lineWidth=_lineWidth==0.f?2.f:_lineWidth;
            yourline.position=CGPointMake(0,0);
            yourline.alpha=0.4;
            [yourline setStrokeColor:_lineColor];
            [node addChild:yourline];
            CGPathRelease(pathToDraw);
        }
    }
    
    else{
        [self removeAllLine];
    }
    
}


-(void)initWaterMark{
    DPI300Node* waterMark=[DPI300Node spriteNodeWithImageNamed:@"watermark"];
    waterMark.name=@"waterMark";
    waterMark.zPosition=9999;
    waterMark.size=CGSizeMake(self.size.width*0.8, waterMark.size.height/waterMark.size.width*self.size.width*0.8);
    waterMark.alpha=0;
    [self addChild:waterMark];
}


//remove
-(void)removeLine:(NSString*)lineName{
    SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    NSArray* children=[node children];
    [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode*child=(SKSpriteNode*)obj;
        if ([child.name isEqualToString:lineName]) {
            [child removeFromParent];
        }
    }];
}

-(void)removeAllLine{
    SKSpriteNode*node=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    [node removeFromParent];
}
-(void)randomBackground{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RANDOM_BACKGROUND" object:self];
}
-(void)removeGrid{
    SKSpriteNode* wrapper=(SKSpriteNode*)[self childNodeWithName:@"star_wrapper"];
    [wrapper removeFromParent];
}



-(void)setBackgroundState:(Byte)backgroundState{
    _backgroundState=backgroundState;
    //设置图片
    if (32==(backgroundState&0b00100000)) {
        [self removeAllLine];
        [self removeGrid];
    }
    //设置grid
    else if(16==(backgroundState&0b00010000)){
        [self removeAllLine];
       // [self randomBackground];
    }
    //设置线
    else if(0<(backgroundState&0b00000011)){
    [self removeGrid];
        [self removeLine:@"line_hnv"];
        [self removeLine:@"circle_line"];
        [self removeLine:@"radio_line"];


    }
    else if(0<(backgroundState&0b00001100)){
        [self removeGrid];
        [self removeLine:@"line_45n135"];
        [self removeLine:@"circle_line"];
        [self removeLine:@"radio_line"];

    }
   else if (64==(backgroundState&0b01000000)) {
       [self removeLine:@"line_hnv"];
       [self removeLine:@"line_45n135"];
       [self removeLine:@"radio_line"];
        [self removeGrid];
    }
   else if (128==(backgroundState&0b10000000)) {
       [self removeLine:@"line_hnv"];
       [self removeLine:@"line_45n135"];
       [self removeLine:@"circle_line"];
       [self removeGrid];
   }
    
    

}




//////////////////////////////
-(void)changeBackgroundGridColor:(UIColor*)color{
    _lineColor=color;
    
    SKSpriteNode* wrapper=(SKSpriteNode*)[self childNodeWithName:@"star_wrapper"];
    NSArray* childStars=[wrapper children];
    [childStars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode*star=(SKSpriteNode*)obj;
        [star setColor:color];
    }];
    
    
    
    SKSpriteNode* lineWrapper=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    NSArray* childLines=[lineWrapper children];
    [childLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKShapeNode*line=(SKShapeNode*)obj;
        //line.fillColor=color;
        line.strokeColor=color;
    }];
}

-(void)changeScale:(CGFloat)scaleFactor{
    if (scaleFactor*_gridScale<2.5&&scaleFactor*_gridScale>=1) {
        SKSpriteNode* wrapper=(SKSpriteNode*)[self childNodeWithName:@"star_wrapper"];
        [wrapper setScale:scaleFactor*_gridScale];
    }
   
    
    
    SKSpriteNode* lineWrapper=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    CGFloat scale=scaleFactor*_lineScale;
    if(scale<2.5&&scale>0.5){
        [lineWrapper setScale:scale];
        NSArray* childLines=[lineWrapper children];
        [childLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SKShapeNode*line=(SKShapeNode*)obj;
            [line setLineWidth:_lineWidth+ (scaleFactor*_lineScale)];
        }];

    }
  }

-(void)changeDensity:(CGPoint)density{
    SKSpriteNode* wrapper=(SKSpriteNode*)[self childNodeWithName:@"star_wrapper"];
    NSArray* childStars=[wrapper children];
    [childStars enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode*star=(SKSpriteNode*)obj;
      
        [star setScale:ABS(_gridDensity-density.y/200)];
    }];
    
    SKSpriteNode* lineWrapper=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    NSArray* childLines=[lineWrapper children];
    [childLines enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKShapeNode*line=(SKShapeNode*)obj;
        [line setLineWidth:_lineWidth-density.y/20];
    }];
}

-(void)backupGridState{
    SKSpriteNode*lineContainer=(SKSpriteNode*)[self childNodeWithName:@"line_container"];
    _lineScale=lineContainer.xScale;
    
    SKShapeNode*shape=(SKShapeNode*)[lineContainer childNodeWithName:@"line_45n135"];
    
    if(!shape){
        shape=(SKShapeNode*)[lineContainer childNodeWithName:@"line_hnv"];
    }
    if(!shape){
        shape=(SKShapeNode*)[lineContainer childNodeWithName:@"circle_line"];
    }
    if(!shape){
        shape=(SKShapeNode*)[lineContainer childNodeWithName:@"radio_line"];
    }
    _lineWidth=shape.lineWidth;

    SKNode * starWrapper=[self childNodeWithName:@"star_wrapper"];
    if (starWrapper) {
        _gridScale=starWrapper.xScale;
    }
    SKSpriteNode*star=(SKSpriteNode*)[starWrapper childNodeWithName:@"star"];
    if (star) {
        _gridDensity=star.xScale;
    }

}

-(void)dealloc{
    NSLog(@"scene dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




-(void)addRecordForFrontHair:(AccessoryRecordObject*)object{
    [_recordsOfFrontHairUsage addObject:object];
}
-(void)removeRecordForFrontHair:(AccessoryRecordObject*)object{
    
    [object.node removeFromParent];
    [_recordsOfFrontHairUsage removeObject:object];
    NSLog(@"remove front hair");
}
-(void)addRecordForBehindHair:(AccessoryRecordObject*)object{
    [_recordsOfBehindHairUsage addObject:object];
}
-(void)removeRecordForBehindHair:(AccessoryRecordObject*)object{
    
    [object.node removeFromParent];
    [_recordsOfBehindHairUsage removeObject:object];
}



-(void)addRecord:(AccessoryRecordObject*)object{
    [_recordsOfAccessoryUsage addObject:object];
}
-(void)removeRecord:(AccessoryRecordObject*)object{
    if ([object.node conformsToProtocol:@protocol(PairNodes)]) {
        id<PairNodes>node=(id<PairNodes>)object.node;
        [node.bindActionNode removeFromParent];
    }
    [object.node removeFromParent];
    [_recordsOfAccessoryUsage removeObject:object];
}


-(void)removeAllRecord{
[_recordsOfAccessoryUsage enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
    AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
    [self removeRecord:object];
}];
}

-(void)removeAllRecordOfFrontHair{
    [_recordsOfFrontHairUsage enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
        [self removeRecordForFrontHair:object];
    }];
}

-(void)removeAllRecordOfBehindHair{
    [_recordsOfBehindHairUsage enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
        [self removeRecordForBehindHair:object];
    }];
}


-(void)receiveRequestForAddAccessory:(NSNotification*)sender{
    AccessoryRecordObject* newRecord=[sender.userInfo objectForKey:@"RECORD_OBJECT"];
    [self addRecord:newRecord];
}
-(void)receiveRequestForAddFrontHair:(NSNotification*)sender{
    AccessoryRecordObject* newRecord=[sender.userInfo objectForKey:@"RECORD_OBJECT"];
    [_recordsOfFrontHairUsage addObject:newRecord];
}
-(void)receiveRequestForAddBehindHair:(NSNotification*)sender{
    AccessoryRecordObject* newRecord=[sender.userInfo objectForKey:@"RECORD_OBJECT"];
    [_recordsOfBehindHairUsage addObject:newRecord];
}

@end
