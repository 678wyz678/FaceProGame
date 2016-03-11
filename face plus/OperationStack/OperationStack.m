//
//  OperationStack.m
//  face plus
//
//  Created by linxudong on 14/11/27.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "OperationStack.h"
#import "ViewController.h"
#import "MyScene.h"
#import "ImportAllEntity.h"
#import "SKSceneCache.h"
#import "FaceNode.h"
#import "MouthNode.h"
#import "NoseNode.h"
#import "HairNode.h"
#import "EyeLeftNode.h"
#import "EyeRightNode.h"
#import "BrowLeftNode.h"
#import "BrowRightNode.h"
#import "NeckNode.h"
#import "EyeBallNode.h"
#import "EyeballCropNode.h"
#import "WhelkNode.h"
#import "MyScene.h"
#import "FeatureLayer.h"
#import "GlassNode.h"
#import "DownToUpDelegate.h"
#import "PLUS_SKView.h"
#import "CapNode.h"
#import "EarNode.h"
#import "EyelashNode.h"
#import "FrontHairNode.h"
#import "BehindHairNode.h"
#import "FaceCropNode.h"
#import "WhiskerNode.h"
#import "BeardNode.h"
#import "Pixel2Point.h"
#import "TattoNode.h"
#import "GirlBehindHair.h"
#import "UnderEyeLeftNode.h"
#import "UnderEyeRightNode.h"
#import "EyelashLeftNode.h"
#import "EyelashRightNode.h"
#import "BigEyeNode.h"
#import "EarDecorationNode.h"
#import "SmallBeard.h"
#import "BrowLikeSmallBeard.h"
#import "RightBrowLikeSmallBeard.h"
#import "AccessoryRightNode.h"
#import "FeaturePosition.h"

#import "AccessoryNode.h"
#import "AccessoryShadow.h"
#import "AccessoryInFaceNode.h"

#import "AccessoryRightInFaceNode.h"
#import "AccessoryLeftInFaceNode.h"
#import "BodyNode.h"
#import "Color2Image.h"
#import "EyeLeftlid.h"
#import "FaceMeasure.h"
#import "EyeRightlid.h"
@implementation OperationStack

-(instancetype)init{
    self=[super init];
    if (self) {
        _previousStack=[[NSMutableArray alloc]init];
        _nextStack=[[NSMutableArray alloc]init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOperationFromNotification:) name:@"newOperation" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newOperationWithReverse:) name:@"newOperationWithReverse" object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backwardOperation:) name:@"BackwardOperation" object:nil];
       // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RandomColorWithBroadcast:) name:@"RandomColorWithBroadcast" object:nil];

        
    }
    return self;
}


-(void)newOperationWithReverse:(NSNotification*)sender{
    BaseEntity*entity=[sender.userInfo objectForKey:@"entity"];
    MyScene*scene= [SKSceneCache singleton].scene;
    
    SKSpriteNode*waterMark=(SKSpriteNode*)[scene childNodeWithName:@"waterMark"];
    if (waterMark.alpha==0.f) {
        SKAction*fadeIn=[SKAction fadeAlphaTo:0.6 duration:0.4];
        [waterMark runAction:fadeIn];
        [self changeTextureWithReverse:entity theSceneToChange:scene];

    }
    else{
        [waterMark removeAllActions];
        SKAction*fadeIn=[SKAction fadeAlphaTo:0.6 duration:0.4];
        [waterMark runAction:fadeIn];
    }

}


-(void)newOperationFromNotification:(NSNotification*)sender{
    BaseEntity*entity=[sender.userInfo objectForKey:@"entity"];
    [self changeTexture:entity];
    
}



-(void)newOperation:(BaseEntity *)entity{
   // NSMutableArray *previous = [self mutableArrayValueForKey:@"previousStack"];
    
    //[previous addObject:entity];
    [self changeTexture:entity];
}

-(void)backwardOperation:(NSNotification*)sender{
    BaseEntity*entity=[sender.userInfo objectForKey:@"entity"];
    MyScene*scene= [SKSceneCache singleton].scene;
    SKSpriteNode*waterMark=(SKSpriteNode*)[scene childNodeWithName:@"waterMark"];

    if (waterMark.hasActions) {
        [waterMark removeAllActions];
        
    }
    SKAction*fadeOut=[SKAction fadeOutWithDuration:0.4];

    [waterMark runAction:fadeOut];
    
    
    [self reverseAction:entity theSceneToChange:scene];
}




-(void)changeTexture:(BaseEntity *)entity{
    MyScene*scene= [SKSceneCache singleton].scene;
    [self changeTexture:entity theSceneToChange:scene];
}

-(void)changeTexture:(BaseEntity*)entity theSceneToChange:(SKScene*) scene{
    if (entity) {
        //需要保存
        [self.controller setNeedSave:YES];

        
        FaceNode* faceNode=(FaceNode*)[scene childNodeWithName:faceLayerName];
        MyScene*scene=(MyScene*)[faceNode scene];

        CGSize faceSize=[Pixel2Point pixel2point:faceNode.texture.size] ;

        if ([entity isKindOfClass:[FaceEntity class]]) {
            [faceNode changeTexture:entity];
//            if (_randomColor) {
//                faceNode.color=[Color2Image random];
//            }

        }
        else if ([entity isKindOfClass:[MouthEntity class]]){
            MouthNode* mouthNode=(MouthNode*)[faceNode childNodeWithName:mouthLayerName] ;
            if (mouthNode) {
                [mouthNode changeTexture:entity];
                [mouthNode setHidden:NO];
            }
            else {
                mouthNode=[[MouthNode alloc]initWithEntity:entity];
                [faceNode addChild:mouthNode];
            }

//            if (_randomColor) {
//                mouthNode.color=[Color2Image random];
//            }
            
        }
        else if ([entity isKindOfClass:[NoseEntity class]]){
            NoseNode* noseNode=(NoseNode*)[faceNode childNodeWithName:noseLayerName] ;
            
            if (noseNode) {
                [noseNode changeTexture:entity];
            }
            else{
                noseNode=[[NoseNode alloc]initWithEntity:entity];
                [faceNode addChild:noseNode];
            }
//            if (_randomColor) {
//                noseNode.color=[Color2Image random];
//            }
             [noseNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[HairEntity class]]){
            DPI300Node* hairNode=(DPI300Node*)[faceNode childNodeWithName:hairLayerName] ;
            //如果是girlhair则删除girl behind node
            if ([hairNode childNodeWithName:girlBehindHairLayerName]) {
            GirlBehindHair*behind=(GirlBehindHair*)[hairNode childNodeWithName:girlBehindHairLayerName];
                [behind removeFromParent];
            }
                [hairNode changeTexture:entity];
              [hairNode setHidden:NO];
//            if (_randomColor) {
//                hairNode.color=[Color2Image random];
//            }
        }
        
        else if ([entity isKindOfClass:[GirlHairEntity class]]){
            HairNode* hairNode=(HairNode*)[faceNode childNodeWithName:hairLayerName] ;
           //如果本来就是女发直接changetexture
            if ([hairNode childNodeWithName:girlBehindHairLayerName]) {
                [hairNode changeTexture:entity];
            }else{
                GirlBehindHair*behind=[[GirlBehindHair alloc]initWithEntity:entity];
                [behind color:hairNode.color];
              
                [hairNode addChild:behind];
                [hairNode changeTexture:entity];
            }
//            if (_randomColor) {
//                [hairNode color:[Color2Image random]];
//            }
//            
            [hairNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[EarEntity class]]){
            EarNode* earNode=(EarNode*)[faceNode childNodeWithName:earLayerName] ;
            if (earNode) {
                [earNode changeTexture:entity];
            }
            else{
                earNode=[[EarNode alloc]initWithEntity:entity];
                [faceNode addChild:earNode];
            }
//            if (_randomColor) {
//                earNode.color=[Color2Image random];
//            }
             [earNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[EyeEntity class]]||[entity isKindOfClass:[DoubleEyeEntity class]]){
            EyeLeftNode* leftEye=(EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName] ;
            if (leftEye) {
                [leftEye changeTexture:entity];
                [leftEye setHidden:NO];
            }
            else{
                leftEye=[[EyeLeftNode alloc]initWithEntity:entity];
                [faceNode addChild:leftEye];
            }
            
            
            EyeRightNode* rightEye=(EyeRightNode*)leftEye.bindActionNode;
            if (rightEye) {
                [rightEye changeTexture:entity];
                 [rightEye setHidden:NO];
            }
            else{
                rightEye=[[EyeRightNode alloc]initWithEntity:entity];
                [faceNode addChild:rightEye];
            }
        }
        
    
        
        else if ([entity isKindOfClass:[BrowEntity class]]){
            BrowLeftNode* leftBrow=(BrowLeftNode*)[faceNode childNodeWithName:browLeftLayerName] ;
            if (leftBrow) {
                [leftBrow changeTexture:entity];
                [leftBrow setHidden:NO];
            }
            else{
                leftBrow=[[BrowLeftNode alloc]initWithEntity:entity];
                [faceNode addChild:leftBrow];
            }
            
            BrowRightNode* rightBrow=(BrowRightNode*)leftBrow.bindActionNode;
            if (rightBrow) {
                [rightBrow changeTexture:entity];
                 [rightBrow setHidden:NO];
            }
            else{
                
                [leftBrow setBindActionNode:rightBrow];
                [rightBrow setBindActionNode:leftBrow];
                
                rightBrow=[[BrowRightNode alloc]initWithEntity:entity];
                [faceNode addChild:rightBrow];
            }
//            if (_randomColor) {
//               rightBrow.color=leftBrow.color=[Color2Image random];
//            }
        }
        
        
        else if ([entity isKindOfClass:[EyeballEntity class]]){
            EyeballCropNode* leftEyeballCrop=(EyeballCropNode*)[[faceNode childNodeWithName:eyeLeftLayerName]childNodeWithName:eyeballCropLayerName ] ;
            EyeBallNode* leftEyeball=(EyeBallNode*)[leftEyeballCrop childNodeWithName:eyeballLayerName] ;
            
            if (leftEyeball) {
                [leftEyeball changeTexture:entity];
                [leftEyeball setHidden:NO];
            }
            
            
            EyeBallNode* rightEyeball=(EyeBallNode*)leftEyeball.bindActionNode;
            if (rightEyeball) {
                [rightEyeball changeTexture:entity];
                 [rightEyeball setHidden:NO];
            }
            [_controller setCurrentNode:leftEyeball];
        }
        
        else if ([entity isKindOfClass:[WhelkEntity class]]){
            WhelkNode* whelk=[[WhelkNode alloc]initWithImageNamed:entity.selfFileName];
            [[faceNode childNodeWithName:faceCropLayerName] addChild:whelk];
        }
        else if ([entity isKindOfClass:[GlassEntity class]]||
                  [entity isKindOfClass:[SingleGlassEntity class]]){
            DPI300Node* glass=(DPI300Node*)  [faceNode childNodeWithName:glassLayerName];

            if (glass) {
                [glass changeTexture:entity];
                 [glass setHidden:NO];
            }
            //不存在则新增眼镜并且设为当前currentNode
            else{
                 glass=[[GlassNode alloc]initWithEntity:entity];
                [faceNode addChild:glass];
                glass.position=CGPointMake(-faceSize.width*0.02, -faceSize.width/1.88);
                [glass setScale:1.15];
            }
            [self.controller setCurrentNode:glass];
//            if (_randomColor) {
//                glass.color=[Color2Image random];
//            }
            
        }
        else if ([entity isKindOfClass:[NeckEntity class]]){
            //去除body
            BodyNode*body=(BodyNode*)[faceNode childNodeWithName:bodyLayerName];
            [body setHidden:YES];
            
            NeckNode* neck=(NeckNode*)[faceNode childNodeWithName:neckLayerName];
            if (neck) {
                [neck changeTexture:entity];
                 [neck setHidden:NO];
            }
            else{
                neck=[[NeckNode alloc]initWithEntity:entity];
                [faceNode addChild:neck];
                neck.position=[FaceMeasure measure:faceNode.texture].neckPosition;
            }
            [self.controller setCurrentNode:neck];
//            if (_randomColor) {
//                neck.color=[Color2Image random];
//            }
        }
        else if ([entity isKindOfClass:[BodyEntity class]]){
            NeckNode* neck=(NeckNode*)[faceNode childNodeWithName:neckLayerName];
            if (neck) {
                [neck setHidden:YES];
            }
            
            BodyNode*body=(BodyNode*)[faceNode childNodeWithName:bodyLayerName];
            if(body)
            {
                [body changeTexture:entity];
                [body setHidden:NO];

            }
            else{
                body=[[BodyNode alloc]initWithEntity:entity];
                faceNode.color=faceNode.color;
               
                body.color=faceNode.color;
                [faceNode addChild:body];
            }
            
            body.size=CGSizeMake(body.size.width/body.size.height*faceSize.height*0.618, faceSize.height*0.618 );

            
            [self.controller setCurrentNode:body];
//            if (_randomColor) {
//                body.color=[Color2Image random];
//            }
        }
        
        else if ([entity isKindOfClass:[CapEntity class]]||[entity isKindOfClass:[CapWithBackgroundEntity class]]){
            DPI300Node* cap=(DPI300Node*)  [faceNode childNodeWithName:capLayerName];
            if (cap) {
                [cap changeTexture:entity];
                 [cap setHidden:NO];
            }
            //不存在则新增帽子并且设为当前currentNode
            else{
               cap=[[CapNode alloc]initWithEntity:entity];
                [faceNode addChild:cap];
            }
          
            [self.controller setCurrentNode:cap];
//            if (_randomColor) {
//                cap.color=[Color2Image random];
//            }
            
         }
        
        
        
        else if ([entity isKindOfClass:[FrontHairEntity class]]){
            NSSet *set=[scene recordsOfFrontHairUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecordForFrontHair:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                FrontHairNode*accessory = [[FrontHairNode alloc]initWithEntity:entity];
                [faceNode addChild: accessory];
                [_controller setCurrentNode:accessory];
                
            }

        }
        else if ([entity isKindOfClass:[BehindHairEntity class]]){
            NSSet *set=[scene recordsOfBehindHairUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecordForBehindHair:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                BehindHairNode*accessory = [[BehindHairNode alloc]initWithEntity:entity];
                [faceNode addChild: accessory];
                [_controller setCurrentNode:accessory];
                
            }
        }
        
        else if ([entity isKindOfClass:[EyelashEntity class]]){
            EyelashLeftNode* leftEyelash=(EyelashLeftNode*)[[faceNode childNodeWithName:eyeLeftLayerName] childNodeWithName:eyelashLeftLayerName];
             EyelashRightNode* rightEyelash=(EyelashRightNode*)[[faceNode childNodeWithName:eyeRightLayerName] childNodeWithName:eyelashRightLayerName];
            if (leftEyelash) {
                [leftEyelash changeTexture:entity];
                 [leftEyelash setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                leftEyelash=[[EyelashLeftNode alloc]initWithEntity:entity];
                EyeLeftNode*eyeLeft=(EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName ];
                [eyeLeft addChild:leftEyelash];
                leftEyelash.size=CGSizeMake(eyeLeft.size.width, leftEyelash.size.height/leftEyelash.size.width*eyeLeft.size.width);
                leftEyelash.position=CGPointMake(0, eyeLeft.size.height/eyeLeft.yScale*0.5);

                //NSLog(@"左眼位置:%@",NSStringFromCGPoint(leftEyelash.position)));
            }
            [_controller setCurrentNode:leftEyelash];

            if (rightEyelash) {
                [rightEyelash changeTexture:entity];
                 [rightEyelash setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                rightEyelash=[[EyelashRightNode alloc]initWithEntity:entity];
                EyeRightNode*eyeRight=(EyeRightNode*)[faceNode childNodeWithName:eyeRightLayerName ];

                [eyeRight addChild:rightEyelash];
                rightEyelash.size=CGSizeMake(rightEyelash.size.width/rightEyelash.size.height*leftEyelash.size.height,leftEyelash.size.height );
                rightEyelash.position=CGPointMake(0, eyeRight.size.height/eyeRight.yScale*0.5);

                [leftEyelash setBindActionNode:rightEyelash];
                [rightEyelash setBindActionNode:leftEyelash];

            }
            
//            if (_randomColor) {
//              rightEyelash.color=  leftEyelash.color=[Color2Image random];
//            }
        }
        
        else if ([entity isKindOfClass:[EyelidEntity class]]){
            FaceCropNode* crop=(FaceCropNode* )[faceNode childNodeWithName:faceCropLayerName];
            
            EyeLeftlid* leftEyelid=(EyeLeftlid*)[crop childNodeWithName:leftEyelidLayerName] ;
            EyeRightlid* rightEyelid=(EyeRightlid*)[crop childNodeWithName:rightEyelidLayerName];
            if (leftEyelid) {
                [leftEyelid changeTexture:entity];
                [leftEyelid setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                leftEyelid=[[EyeLeftlid alloc]initWithEntity:entity];
                [crop addChild:leftEyelid];
            }
            [_controller setCurrentNode:leftEyelid];
            
            if (rightEyelid) {
                [rightEyelid changeTexture:entity];
                [rightEyelid setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                rightEyelid=[[EyeRightlid alloc]initWithEntity:entity];
                
                [crop addChild:rightEyelid];
               
                [leftEyelid setBindActionNode:rightEyelid];
                [rightEyelid setBindActionNode:leftEyelid];
                
            }
            
//            if (_randomColor) {
//                rightEyelid.color=  leftEyelid.color=[Color2Image random];
//            }
        }

        
        
        else if ([entity isKindOfClass:[WhiskerEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            WhiskerNode* whisker=(WhiskerNode*)[crop childNodeWithName:whiskerLayerName];
            
            //
            BeardNode* beard=(BeardNode*)[faceNode childNodeWithName:beardLayerName];
            [beard removeFromParent];
            //
            
            if (whisker) {
                [whisker changeTexture:entity];
                [whisker setHidden:NO];
            }
            //不存在则新增络腮并且设为当前currentNode(因为素材框转过来后没有可用的node，所以导致无法自动current node)
            else{
                whisker=[[WhiskerNode alloc]initWithEntity:entity];
                whisker.position=CGPointMake(0, -faceSize.height);

                [crop addChild:whisker];
            }
//            if (_randomColor) {
//                whisker.color=[Color2Image random];
//            }
            [_controller setCurrentNode:whisker];

        }
        else if ([entity isKindOfClass:[BeardEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            WhiskerNode* whisker=(WhiskerNode*)[crop childNodeWithName:whiskerLayerName];
            [whisker removeFromParent];
            
            
            
            BeardNode* beard=(BeardNode*)[faceNode childNodeWithName:beardLayerName];
            
            if (beard) {
                [beard changeTexture:entity];
                [beard setHidden:NO];
            }
            //不存在则新增小胡子并且设为当前currentNode(因为素材框转过来后没有可用的node，所以导致无法自动current node)
            else{
                beard=[[BeardNode alloc]initWithEntity:entity];
                [faceNode addChild:beard];
            }
//            if (_randomColor) {
//                beard.color=[Color2Image random];
//            }
            [_controller setCurrentNode:beard];

        }
        
        else if ([entity isKindOfClass:[TattooEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
           TattoNode * tattoo=(TattoNode*)[crop childNodeWithName:tattooLayerName];
            
            if (tattoo) {
                [tattoo changeTexture:entity];
                [tattoo setHidden:NO];
            }
            //不存在则新增络腮并且设为当前currentNode(因为素材框转过来后没有可用的node，所以导致无法自动current node)
            else{
                tattoo=[[TattoNode alloc]initWithImageNamed:entity.selfFileName];
                tattoo.position=CGPointMake(faceSize.width*0.5, -faceSize.height*0.5);
                
                [crop addChild:tattoo];
            }
            [_controller setCurrentNode:tattoo];

        }
        
        
        else if ([entity isKindOfClass:[UnderEyeEntity class]]){
            FaceCropNode*crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            
            
            UnderEyeLeftNode* underEyeLeft=(UnderEyeLeftNode*)[crop childNodeWithName:underEyeLeftLayerName];
            UnderEyeRightNode* underEyeRight=(UnderEyeRightNode*)[crop childNodeWithName:underEyeRightLayerName];
            
            
            if (underEyeLeft) {
                [underEyeLeft changeTexture:entity];
                [underEyeLeft setHidden:NO];
            }
            else{
                underEyeLeft=[[UnderEyeLeftNode alloc]initWithEntity:entity];
                [crop addChild:underEyeLeft];
                [_controller setCurrentNode:underEyeLeft];
            }
            
            if (underEyeRight) {
                [underEyeRight changeTexture:entity];
                [underEyeRight setHidden:NO];
            }
            else{
                underEyeRight=[[UnderEyeRightNode alloc]initWithEntity:entity];
                [crop addChild:underEyeRight];
                
                [underEyeRight setBindActionNode:underEyeLeft];
                [underEyeLeft setBindActionNode:underEyeRight];
                
            }
//            if (_randomColor) {
//                underEyeLeft.color=underEyeRight.color=[Color2Image random];
//            }
            [_controller setCurrentNode:underEyeLeft];
            
        }
        
        
        else if ([entity isKindOfClass:[EarDecorationEntity class]]){
            EarNode*ear=(EarNode*)[faceNode childNodeWithName:earLayerName];
            EarDecorationNode* earDecorationNode=(EarDecorationNode*)[ear childNodeWithName:earDecoLayerName];
            if (earDecorationNode) {
                [earDecorationNode changeTexture:entity];
                [earDecorationNode setHidden:NO];
            }
            else{
                earDecorationNode=[[EarDecorationNode alloc]initWithEntity:entity];
                earDecorationNode.size=CGSizeMake(ear.size.height/ear.yScale*0.6*earDecorationNode.size.width/earDecorationNode.size.height, ear.size.height/ear.yScale*0.6);
                earDecorationNode.position=CGPointMake(0, -earDecorationNode.size.height*0.3);

                [ear addChild:earDecorationNode];
            }
            [_controller setCurrentNode:earDecorationNode];

            
        }
        
        else if ([entity isKindOfClass:[SmallBeardEntity class]]){
            BrowLikeSmallBeard* left=(BrowLikeSmallBeard*)[faceNode childNodeWithName:browLikeSmallBeardLayerName];
            RightBrowLikeSmallBeard* right=(RightBrowLikeSmallBeard*)[faceNode childNodeWithName:rightBrowLikeSmallBeardLayerName];
            [left removeFromParent];
            [right removeFromParent];
            
            
            SmallBeard* smallBeard=(SmallBeard*)[faceNode childNodeWithName:smallBeardLayerName];
            if (smallBeard) {
                [smallBeard changeTexture:entity];
                [smallBeard setHidden:NO];
            }
            else{
                smallBeard=[[SmallBeard alloc]initWithEntity:entity];
                [faceNode addChild:smallBeard];
            }
//            if (_randomColor) {
//                smallBeard.color=[Color2Image random];
//            }
            [_controller setCurrentNode:smallBeard];
            
        }
        else if ([entity isKindOfClass:[BrowLikeSmallBeardEntity class]]){
            BrowLikeSmallBeard* beardLeft=(BrowLikeSmallBeard*)[faceNode childNodeWithName:browLikeSmallBeardLayerName];
            RightBrowLikeSmallBeard* beardRight=(RightBrowLikeSmallBeard*)[faceNode childNodeWithName:rightBrowLikeSmallBeardLayerName];
            
            SmallBeard* smallBeard=(SmallBeard*)[faceNode childNodeWithName:smallBeardLayerName];
            [smallBeard removeFromParent];
            
            if (beardLeft) {
                [beardLeft changeTexture:entity];
                [beardLeft setHidden:NO];
            }
            else{
                beardLeft=[[BrowLikeSmallBeard alloc]initWithEntity:entity];
                [faceNode addChild:beardLeft];
                
                [_controller setCurrentNode:beardLeft];
            }
            
            if (beardRight) {
                [beardRight changeTexture:entity];
                [beardRight setHidden:NO];
            }
            else{
                beardRight=[[RightBrowLikeSmallBeard alloc]initWithEntity:entity];
                [faceNode addChild:beardRight];
                [beardRight setBindActionNode:beardLeft];
                [beardLeft setBindActionNode:beardRight];
                
            }
//            if (_randomColor) {
//                beardLeft.color=beardRight.color=[Color2Image random];
//            }
            [_controller setCurrentNode:beardLeft];

        }
        
        //out face :单双层附件
        else if ([entity isKindOfClass:[SingleAccessoryEntity class]]||[entity isKindOfClass:[DoubleAccessoryEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];

                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryNode*accessory = [[AccessoryNode alloc]initWithEntity:entity];
                [faceNode addChild: accessory];
                [_controller setCurrentNode:accessory];

            }
        }
        
        

        
        //out face :左右附件
        else if ([entity isKindOfClass:[LeftRightAccessoryEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryLeftNode*leftNode = [[AccessoryLeftNode alloc]initWithEntity:entity];
                AccessoryRightNode*rightNode = [[AccessoryRightNode alloc]initWithEntity:entity];

                [leftNode setBindActionNode:rightNode];
                [rightNode setBindActionNode:leftNode];
                [faceNode addChild: leftNode];
                [faceNode addChild: rightNode];

                [_controller setCurrentNode:leftNode];
                
            }
        }
        
        
        //in face :单双层附件
        else if ([entity isKindOfClass:[AccessoryInFaceSingleEntity class]]||[entity isKindOfClass:[AccessoryInFaceDoubleEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);

                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryInFaceNode *accessory = [[AccessoryInFaceNode alloc]initWithEntity:entity];
                [[faceNode childNodeWithName:faceCropLayerName] addChild: accessory];
                [_controller setCurrentNode:accessory];
                
            }
        }
        
        
        
        
        //in face :左右附件
        else if ([entity isKindOfClass:[AccessoryInFaceLeftRightEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);

                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryLeftInFaceNode *leftNode = [[AccessoryLeftInFaceNode alloc]initWithEntity:entity];
                AccessoryRightInFaceNode*rightNode = [[AccessoryRightInFaceNode alloc]initWithEntity:entity];
                
                [leftNode setBindActionNode:rightNode];
                [rightNode setBindActionNode:leftNode];
                [[faceNode childNodeWithName:faceCropLayerName] addChild: leftNode];
                [[faceNode childNodeWithName:faceCropLayerName] addChild: rightNode];
                
                [_controller setCurrentNode:leftNode];
                
            }
        }
        
        
        
    }
}





-(void)changeTextureWithReverse:(BaseEntity*)entity theSceneToChange:(SKScene*) scene{
    
    if (entity) {
        FaceNode* faceNode=(FaceNode*)[scene childNodeWithName:faceLayerName];
        MyScene*scene=(MyScene*)[faceNode scene];
        
        CGSize faceSize=[Pixel2Point pixel2point:faceNode.texture.size] ;
        
        if ([entity isKindOfClass:[FaceEntity class]]) {
            [faceNode changeTextureWithReverse:entity];
            
        }
        else if ([entity isKindOfClass:[MouthEntity class]]){
            MouthNode* mouthNode=(MouthNode*)[faceNode childNodeWithName:mouthLayerName] ;
            [mouthNode changeTextureWithReverse:entity];
            [mouthNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[NoseEntity class]]){
            NoseNode* noseNode=(NoseNode*)[faceNode childNodeWithName:noseLayerName] ;
            [noseNode changeTextureWithReverse:entity];
            
            [noseNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[HairEntity class]]){
            DPI300Node* hairNode=(DPI300Node*)[faceNode childNodeWithName:hairLayerName] ;
            //如果是girlhair则删除girl behind node
            if ([hairNode childNodeWithName:girlBehindHairLayerName]) {
                GirlBehindHair*behind=(GirlBehindHair*)[hairNode childNodeWithName:girlBehindHairLayerName];
                [behind removeFromParent];
            }
            [hairNode changeTextureWithReverse:entity];
            [hairNode setHidden:NO];
        }
        
        else if ([entity isKindOfClass:[GirlHairEntity class]]){
            HairNode* hairNode=(HairNode*)[faceNode childNodeWithName:hairLayerName] ;
            //如果本来就是女发直接changeTextureWithReverse
            if ([hairNode childNodeWithName:girlBehindHairLayerName]) {
                [hairNode changeTextureWithReverse:entity];
            }else{
                GirlBehindHair*behind=[[GirlBehindHair alloc]initWithEntity:entity];
                [behind color:hairNode.color];
                
                [hairNode addChild:behind];
                [hairNode setNewAdded:YES];
                [hairNode changeTextureWithReverse:entity];
            }
            
            [hairNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[EarEntity class]]){
            EarNode* earNode=(EarNode*)[faceNode childNodeWithName:earLayerName] ;
            [earNode changeTextureWithReverse:entity];
            [earNode setHidden:NO];
        }
        else if ([entity isKindOfClass:[EyeEntity class]]||[entity isKindOfClass:[DoubleEyeEntity class]]){
            EyeLeftNode* leftEye=(EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName] ;
            [leftEye changeTextureWithReverse:entity];
            [leftEye setHidden:NO];
            EyeRightNode* rightEye=(EyeRightNode*)leftEye.bindActionNode;
            if (rightEye) {
                [rightEye changeTextureWithReverse:entity];
                [rightEye setHidden:NO];
            }
        }
        
        
        
        else if ([entity isKindOfClass:[BrowEntity class]]){
            BrowLeftNode* leftBrow=(BrowLeftNode*)[faceNode childNodeWithName:browLeftLayerName] ;
            [leftBrow changeTextureWithReverse:entity];
            [leftBrow setHidden:NO];
            BrowRightNode* rightBrow=(BrowRightNode*)leftBrow.bindActionNode;
            if (rightBrow) {
                [rightBrow changeTextureWithReverse:entity];
                [rightBrow setHidden:NO];
            }
        }
        else if ([entity isKindOfClass:[EyeballEntity class]]){
            EyeballCropNode* leftEyeballCrop=(EyeballCropNode*)[[faceNode childNodeWithName:eyeLeftLayerName]childNodeWithName:eyeballCropLayerName ] ;
            EyeBallNode* leftEyeball=(EyeBallNode*)[leftEyeballCrop childNodeWithName:eyeballLayerName] ;
            [leftEyeball changeTextureWithReverse:entity];
            [leftEyeball setHidden:NO];
            EyeBallNode* rightEyeball=(EyeBallNode*)leftEyeball.bindActionNode;
            if (rightEyeball) {
                [rightEyeball changeTextureWithReverse:entity];
                [rightEyeball setHidden:NO];
            }
            [_controller setCurrentNode:leftEyeball];
        }
        
//        else if ([entity isKindOfClass:[WhelkEntity class]]){
//            WhelkNode* whelk=[[WhelkNode alloc]initWithImageNamed:entity.selfFileName];
//            [[faceNode childNodeWithName:faceCropLayerName] addChild:whelk];
//        }
        else if ([entity isKindOfClass:[GlassEntity class]]||
                 [entity isKindOfClass:[SingleGlassEntity class]]){
            DPI300Node* glass=(DPI300Node*)  [faceNode childNodeWithName:glassLayerName];
            
            if (glass) {
                [glass changeTextureWithReverse:entity];
                [glass setHidden:NO];
            }
            //不存在则新增眼镜并且设为当前currentNode
            else{
                glass=[[GlassNode alloc]initWithEntity:entity];
                [faceNode addChild:glass];
                glass.position=CGPointMake(0, -faceSize.width/2.0);
                [glass setNewAdded:YES];

            }
            [self.controller setCurrentNode:glass];
            
            
        }
        else if ([entity isKindOfClass:[NeckEntity class]]){
            BodyNode*body=(BodyNode*)[faceNode childNodeWithName:bodyLayerName];
            if(body)
            {
                [body setHidden:YES];
            }
            
            
            NeckNode* neck=(NeckNode*)[faceNode childNodeWithName:neckLayerName];
            if (neck) {
                [neck changeTextureWithReverse:entity];
                [neck setHidden:NO];
            }
            else{
                neck=[[NeckNode alloc]initWithEntity:entity];
                [faceNode addChild:neck];
                [faceNode setNewAdded:YES];

            }
            [self.controller setCurrentNode:neck];
            
        }
        
        
        else if ([entity isKindOfClass:[BodyEntity class]]){
            NeckNode* neck=(NeckNode*)[faceNode childNodeWithName:neckLayerName];
            if (neck) {
                [neck setHidden:YES];
            }
            
            BodyNode*body=(BodyNode*)[faceNode childNodeWithName:bodyLayerName];
            if(body)
            {
                [body changeTextureWithReverse:entity];
                [body setHidden:NO];
            }
            else{
                body=[[BodyNode alloc]initWithEntity:entity];
                [faceNode addChild:body];
                
                body.color=faceNode.color;
                body.size=CGSizeMake(body.size.width/body.size.height*faceSize.height*0.618, faceSize.height*0.618 );
              
                [body setNewAdded:YES];

            }
            
            [self.controller setCurrentNode:body];
            
        }
        
        
        else if ([entity isKindOfClass:[CapEntity class]]||[entity isKindOfClass:[CapWithBackgroundEntity class]]){
            DPI300Node* cap=(DPI300Node*)  [faceNode childNodeWithName:capLayerName];
            if (cap) {
                [cap changeTextureWithReverse:entity];
                [cap setHidden:NO];
            }
            //不存在则新增帽子并且设为当前currentNode
            else{
                cap=[[CapNode alloc]initWithEntity:entity];
                [faceNode addChild:cap];
                [cap setNewAdded:YES];

            }
            
            [self.controller setCurrentNode:cap];
            
            
        }
        
        
        
        else if ([entity isKindOfClass:[FrontHairEntity class]]){
            FrontHairNode  * frontHair=(FrontHairNode*)  [faceNode childNodeWithName:frontHairLayerName];
            
            if (frontHair) {
                [frontHair changeTextureWithReverse:entity];
                [frontHair setHidden:NO];
            }
            //不存在则新增帽子并且设为当前currentNode
            else{
                frontHair=[[FrontHairNode alloc]initWithEntity:entity];
                [faceNode addChild:frontHair];
                [frontHair setNewAdded:YES];

            }
            [self.controller setCurrentNode:frontHair];
            
        }
        else if ([entity isKindOfClass:[BehindHairEntity class]]){
            BehindHairNode  * behindHair=(BehindHairNode*)  [faceNode childNodeWithName:behindHairLayerName];
            
            if (behindHair) {
                [behindHair changeTextureWithReverse:entity];
                [behindHair setHidden:NO];
            }
            //不存在则新增帽子并且设为当前currentNode
            else{
                behindHair=[[BehindHairNode alloc]initWithEntity:entity];
                [faceNode addChild:behindHair];
                [behindHair setNewAdded:YES];

            }
            [self.controller setCurrentNode:behindHair];
            
        }
        
        else if ([entity isKindOfClass:[EyelashEntity class]]){
            EyelashNode* leftEyelash=(EyelashNode*)[[faceNode childNodeWithName:eyeLeftLayerName] childNodeWithName:eyelashLeftLayerName];
            EyelashNode* rightEyelash=(EyelashNode*)[[faceNode childNodeWithName:eyeRightLayerName] childNodeWithName:eyelashRightLayerName];
            if (leftEyelash) {
                [leftEyelash changeTextureWithReverse:entity];
                [leftEyelash setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                leftEyelash=[[EyelashLeftNode alloc]initWithEntity:entity];
                EyeLeftNode*eyeLeft=(EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName ];
                [eyeLeft addChild:leftEyelash];
                leftEyelash.size=CGSizeMake(eyeLeft.size.width, leftEyelash.size.height/leftEyelash.size.width*eyeLeft.size.width);
                leftEyelash.position=CGPointMake(0, eyeLeft.size.height/eyeLeft.yScale*0.5);
                [eyeLeft setNewAdded:YES];

            }
            [_controller setCurrentNode:leftEyelash];
            
            if (rightEyelash) {
                [rightEyelash changeTextureWithReverse:entity];
                [rightEyelash setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                rightEyelash=[[EyelashRightNode alloc]initWithEntity:entity];
                rightEyelash.anchorPoint=CGPointMake(0.2, 0.5);
                EyeRightNode*eyeRight=(EyeRightNode*)[faceNode childNodeWithName:eyeRightLayerName ];
                
                [eyeRight addChild:rightEyelash];
                rightEyelash.size=CGSizeMake(eyeRight.size.width, rightEyelash.size.height/rightEyelash.size.width*eyeRight.size.width);
                rightEyelash.position=CGPointMake(0, eyeRight.size.height/eyeRight.yScale*0.5);

                [eyeRight setNewAdded:YES];

            }
        }
        
        
        
        
        else if ([entity isKindOfClass:[EyelidEntity class]]){
            FaceCropNode* crop=(FaceCropNode* )[faceNode childNodeWithName:faceCropLayerName];
            
            EyeLeftlid* leftEyelid=(EyeLeftlid*)[crop childNodeWithName:leftEyelidLayerName] ;
            EyeRightlid* rightEyelid=(EyeRightlid*)[crop childNodeWithName:rightEyelidLayerName];
            if (leftEyelid) {
                [leftEyelid changeTexture:entity];
                [leftEyelid setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                leftEyelid=[[EyeLeftlid alloc]initWithEntity:entity];
                [crop addChild:leftEyelid];
                [leftEyelid setNewAdded:YES];

            }
            [_controller setCurrentNode:leftEyelid];
            
            if (rightEyelid) {
                [rightEyelid changeTexture:entity];
                [rightEyelid setHidden:NO];
            }
            //不存在则新增睫毛并且设为当前currentNode
            else{
                rightEyelid=[[EyeRightlid alloc]initWithEntity:entity];
                rightEyelid.anchorPoint=CGPointMake(0.2, 0.5);
                
                [crop addChild:rightEyelid];
                
                [leftEyelid setBindActionNode:rightEyelid];
                [rightEyelid setBindActionNode:leftEyelid];
                [rightEyelid setNewAdded:YES];

            }
            
           
        }
        
        
        else if ([entity isKindOfClass:[WhiskerEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            WhiskerNode* whisker=(WhiskerNode*)[crop childNodeWithName:whiskerLayerName];
            
            if (whisker) {
                [whisker changeTextureWithReverse:entity];
                [whisker setHidden:NO];
            }
            //不存在则新增络腮并且设为当前currentNode(因为素材框转过来后没有可用的node，所以导致无法自动current node)
            else{
                whisker=[[WhiskerNode alloc]initWithEntity:entity];
                whisker.position=CGPointMake(0, -faceSize.height);
                [whisker setNewAdded:YES];

                [crop addChild:whisker];
            }
            [_controller setCurrentNode:whisker];
            
        }
        else if ([entity isKindOfClass:[BeardEntity class]]){
            BeardNode* beard=(BeardNode*)[faceNode childNodeWithName:beardLayerName];
            
            if (beard) {
                [beard changeTextureWithReverse:entity];
                [beard setHidden:NO];
            }
            //不存在则新增小胡子并且设为当前currentNode(因为素材框转过来后没有可用的node，所以导致无法自动current node)
            else{
                beard=[[BeardNode alloc]initWithEntity:entity];
                [faceNode addChild:beard];
                [beard setNewAdded:YES];

            }
            [_controller setCurrentNode:beard];
            
        }
        
        else if ([entity isKindOfClass:[TattooEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            TattoNode * tattoo=(TattoNode*)[crop childNodeWithName:tattooLayerName];
            
            if (tattoo) {
                [tattoo changeTextureWithReverse:entity];
                [tattoo setHidden:NO];
            }
            //不存在则新增络腮并且设为当前currentNode(因为素材框转过来后没有可用的node，所以导致无法自动current node)
            else{
                tattoo=[[TattoNode alloc]initWithImageNamed:entity.selfFileName];
                tattoo.position=CGPointMake(faceSize.width*0.5, -faceSize.height*0.5);
                [tattoo setNewAdded:YES];

                [crop addChild:tattoo];
            }
            [_controller setCurrentNode:tattoo];
            
        }
        
        
        else if ([entity isKindOfClass:[UnderEyeEntity class]]){
            FaceCropNode*crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            
            
            UnderEyeLeftNode* underEyeLeft=(UnderEyeLeftNode*)[crop childNodeWithName:underEyeLeftLayerName];
            UnderEyeRightNode* underEyeRight=(UnderEyeRightNode*)[crop childNodeWithName:underEyeRightLayerName];
            
            if (underEyeLeft) {
                [underEyeLeft changeTextureWithReverse:entity];
                [underEyeLeft setHidden:NO];
            }
            else{
                underEyeLeft=[[UnderEyeLeftNode alloc]initWithEntity:entity];
                [crop addChild:underEyeLeft];
                [_controller setCurrentNode:underEyeLeft];
                [underEyeLeft setNewAdded:YES];

            }
            
            if (underEyeRight) {
                [underEyeRight changeTextureWithReverse:entity];
                [underEyeRight setHidden:NO];
            }
            else{
                underEyeRight=[[UnderEyeRightNode alloc]initWithEntity:entity];
                [crop addChild:underEyeRight];
                [underEyeRight setNewAdded:YES];

                [underEyeRight setBindActionNode:underEyeLeft];
                [underEyeLeft setBindActionNode:underEyeRight];
                
            }
            [_controller setCurrentNode:underEyeLeft];

        }
        
        
        else if ([entity isKindOfClass:[EarDecorationEntity class]]){
            EarNode*ear=(EarNode*)[faceNode childNodeWithName:earLayerName];
            EarDecorationNode* earDecorationNode=(EarDecorationNode*)[ear childNodeWithName:earDecoLayerName];
            if (earDecorationNode) {
                [earDecorationNode changeTextureWithReverse:entity];
            }
            else{
                earDecorationNode=[[EarDecorationNode alloc]initWithEntity:entity];
                earDecorationNode.position=CGPointZero;
                earDecorationNode.size=CGSizeMake(ear.size.height/ear.yScale*0.6*earDecorationNode.size.width/earDecorationNode.size.height, ear.size.height/ear.yScale*0.6);
                earDecorationNode.position=CGPointMake(0,- earDecorationNode.size.height*0.3);

                [ear addChild:earDecorationNode];
                [earDecorationNode setNewAdded:YES];

            }
            [_controller setCurrentNode:earDecorationNode];
            
            
        }
        
        else if ([entity isKindOfClass:[SmallBeardEntity class]]){
            SmallBeard* smallBeard=(SmallBeard*)[faceNode childNodeWithName:smallBeardLayerName];
            if (smallBeard) {
                [smallBeard changeTextureWithReverse:entity];
                [smallBeard setHidden:NO];
            }
            else{
                smallBeard=[[SmallBeard alloc]initWithEntity:entity];
                [faceNode addChild:smallBeard];
                [[faceNode childNodeWithName:browLikeSmallBeardLayerName] removeFromParent];
                [[faceNode childNodeWithName:rightBrowLikeSmallBeardLayerName] removeFromParent];
                [smallBeard setNewAdded:YES];

                
            }
            [_controller setCurrentNode:smallBeard];
            
        }
        else if ([entity isKindOfClass:[BrowLikeSmallBeardEntity class]]){
            BrowLikeSmallBeard* beardLeft=(BrowLikeSmallBeard*)[faceNode childNodeWithName:browLikeSmallBeardLayerName];
            RightBrowLikeSmallBeard* beardRight=(RightBrowLikeSmallBeard*)[faceNode childNodeWithName:rightBrowLikeSmallBeardLayerName];
            
            
            
            if (beardLeft) {
                [beardLeft changeTextureWithReverse:entity];
                [beardLeft setHidden:NO];
            }
            else{
                beardLeft=[[BrowLikeSmallBeard alloc]initWithEntity:entity];
                [faceNode addChild:beardLeft];
                [beardLeft setNewAdded:YES];

                [_controller setCurrentNode:beardLeft];
            }
            
            if (beardRight) {
                [beardRight changeTextureWithReverse:entity];
                [beardRight setHidden:NO];
            }
            else{
                [[faceNode childNodeWithName:beardLayerName] removeFromParent];
                beardRight=[[RightBrowLikeSmallBeard alloc]initWithEntity:entity];
                [faceNode addChild:beardRight];
                [beardRight setBindActionNode:beardLeft];
                [beardLeft setBindActionNode:beardRight];
                [beardRight setNewAdded:YES];

            }
        }
        
        //out face :单双层附件
        else if ([entity isKindOfClass:[SingleAccessoryEntity class]]||[entity isKindOfClass:[DoubleAccessoryEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryNode*accessory = [[AccessoryNode alloc]initWithEntity:entity];
                [faceNode addChild: accessory];
                [_controller setCurrentNode:accessory];
                [accessory setNewAdded:YES];

            }
        }
        
        //out face :左右附件
        else if ([entity isKindOfClass:[LeftRightAccessoryEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryLeftNode*leftNode = [[AccessoryLeftNode alloc]initWithEntity:entity];
                AccessoryRightNode*rightNode = [[AccessoryRightNode alloc]initWithEntity:entity];

                [leftNode setBindActionNode:rightNode];
                [rightNode setBindActionNode:leftNode];
                [faceNode addChild: leftNode];
                [faceNode addChild: rightNode];
                [leftNode setNewAdded:YES];
                [rightNode setNewAdded:YES];

                [_controller setCurrentNode:leftNode];
                
            }
        }
        
        
        //in face :单双层附件
        else if ([entity isKindOfClass:[AccessoryInFaceSingleEntity class]]||[entity isKindOfClass:[AccessoryInFaceDoubleEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryInFaceNode *accessory = [[AccessoryInFaceNode alloc]initWithEntity:entity];
                [[faceNode childNodeWithName:faceCropLayerName] addChild: accessory];
                [_controller setCurrentNode:accessory];
                [accessory setNewAdded:YES];

            }
        }
        
        //in face :左右附件
        else if ([entity isKindOfClass:[AccessoryInFaceLeftRightEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            //还没有此次附件
            if (!hasOne) {
                AccessoryLeftInFaceNode *leftNode = [[AccessoryLeftInFaceNode alloc]initWithEntity:entity];
                AccessoryRightInFaceNode*rightNode = [[AccessoryRightInFaceNode alloc]initWithEntity:entity];
                
                [leftNode setBindActionNode:rightNode];
                [rightNode setBindActionNode:leftNode];
                [[faceNode childNodeWithName:faceCropLayerName] addChild: leftNode];
                [[faceNode childNodeWithName:faceCropLayerName] addChild: rightNode];
                
                [_controller setCurrentNode:leftNode];
                
                [leftNode setNewAdded:YES];
                [rightNode setNewAdded:YES];

            }
        }
        
        
        
    }
}





-(void)reverseAction:(BaseEntity*)entity theSceneToChange:(MyScene*) scene{
    if (entity) {
        FaceNode* faceNode=(FaceNode*)[scene childNodeWithName:faceLayerName];
        //MyScene*scene=(MyScene*)[faceNode scene];
        
        //CGSize faceSize=[Pixel2Point pixel2point:faceNode.texture.size] ;
        
        if ([entity isKindOfClass:[FaceEntity class]]) {
            [faceNode reverseAction];
            
        }
        else if ([entity isKindOfClass:[MouthEntity class]]){
            MouthNode* mouthNode=(MouthNode*)[faceNode childNodeWithName:mouthLayerName] ;
            [mouthNode reverseAction];
        }
        else if ([entity isKindOfClass:[NoseEntity class]]){
            NoseNode* noseNode=(NoseNode*)[faceNode childNodeWithName:noseLayerName] ;
            [noseNode reverseAction];
            
        }
        else if ([entity isKindOfClass:[HairEntity class]]){
            DPI300Node* hairNode=(DPI300Node*)[faceNode childNodeWithName:hairLayerName] ;
            
            [hairNode reverseAction];
        }
        
        else if ([entity isKindOfClass:[GirlHairEntity class]]){
            HairNode* hairNode=(HairNode*)[faceNode childNodeWithName:hairLayerName] ;
            //如果本来就是女发直接reverseAction
            if ([hairNode childNodeWithName:girlBehindHairLayerName]) {
                [hairNode reverseAction];
            }
            
        }
        else if ([entity isKindOfClass:[EarEntity class]]){
            EarNode* earNode=(EarNode*)[faceNode childNodeWithName:earLayerName] ;
            [earNode reverseAction];
        }
        else if ([entity isKindOfClass:[EyeEntity class]]||[entity isKindOfClass:[DoubleEyeEntity class]]){
            EyeLeftNode* leftEye=(EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName] ;
            [leftEye reverseAction];
            EyeRightNode* rightEye=(EyeRightNode*)leftEye.bindActionNode;
            if (rightEye) {
                [rightEye reverseAction];
            }
        }
        
        
        
        else if ([entity isKindOfClass:[BrowEntity class]]){
            BrowLeftNode* leftBrow=(BrowLeftNode*)[faceNode childNodeWithName:browLeftLayerName] ;
            [leftBrow reverseAction];
            BrowRightNode* rightBrow=(BrowRightNode*)leftBrow.bindActionNode;
            if (rightBrow) {
                [rightBrow reverseAction];
            }
        }
        else if ([entity isKindOfClass:[EyeballEntity class]]){
            EyeballCropNode* leftEyeballCrop=(EyeballCropNode*)[[faceNode childNodeWithName:eyeLeftLayerName]childNodeWithName:eyeballCropLayerName ] ;
            EyeBallNode* leftEyeball=(EyeBallNode*)[leftEyeballCrop childNodeWithName:eyeballLayerName] ;
            [leftEyeball reverseAction];
            
            EyeBallNode* rightEyeball=(EyeBallNode*)leftEyeball.bindActionNode;
            if (rightEyeball) {
                [rightEyeball reverseAction];
            }
        }
        
        else if ([entity isKindOfClass:[WhelkEntity class]]){
            WhelkNode* whelk=[[WhelkNode alloc]initWithImageNamed:entity.selfFileName];
            [[faceNode childNodeWithName:faceCropLayerName] addChild:whelk];
        }
        else if ([entity isKindOfClass:[GlassEntity class]]||
                 [entity isKindOfClass:[SingleGlassEntity class]]){
            DPI300Node* glass=(DPI300Node*)  [faceNode childNodeWithName:glassLayerName];
            if (glass) {

                [glass reverseAction];
            }
            
            
        }
        else if ([entity isKindOfClass:[NeckEntity class]]){
            NeckNode* neck=(NeckNode*)[faceNode childNodeWithName:neckLayerName];
            if (neck) {
                [neck reverseAction];
            }
            
        }
        
        else if ([entity isKindOfClass:[BodyEntity class]]){
            BodyNode* body=(BodyNode*)[faceNode childNodeWithName:bodyLayerName];
            if (body) {

                [body reverseAction];
            }
            
        }
        
        else if ([entity isKindOfClass:[CapEntity class]]||[entity isKindOfClass:[CapWithBackgroundEntity class]]){
            DPI300Node* cap=(DPI300Node*)  [faceNode childNodeWithName:capLayerName];
            if (cap) {
                [cap reverseAction];
            }
            
        }
        
        
        
        else if ([entity isKindOfClass:[FrontHairEntity class]]){
            FrontHairNode  * frontHair=(FrontHairNode*)  [faceNode childNodeWithName:frontHairLayerName];
            
            if (frontHair) {
                [frontHair reverseAction];
            }
            
            
        }
        else if ([entity isKindOfClass:[BehindHairEntity class]]){
            BehindHairNode  * behindHair=(BehindHairNode*)  [faceNode childNodeWithName:behindHairLayerName];
            
            if (behindHair) {
                [behindHair reverseAction];
            }
            
            
        }
        
        else if ([entity isKindOfClass:[EyelashEntity class]]){
            EyelashNode* leftEyelash=(EyelashNode*)[[faceNode childNodeWithName:eyeLeftLayerName] childNodeWithName:eyelashLeftLayerName];
            EyelashNode* rightEyelash=(EyelashNode*)[[faceNode childNodeWithName:eyeRightLayerName] childNodeWithName:eyelashRightLayerName];
            if (leftEyelash) {
                [leftEyelash reverseAction];
            }
            
            if (rightEyelash) {
                [rightEyelash reverseAction];
            }
            
        }
        
        
        else if ([entity isKindOfClass:[EyelidEntity class]]){
            FaceCropNode* crop=(FaceCropNode* )[faceNode childNodeWithName:faceCropLayerName];
            
            EyeLeftlid* leftEyelid=(EyeLeftlid*)[crop childNodeWithName:leftEyelidLayerName] ;
            EyeRightlid* rightEyelid=(EyeRightlid*)[crop childNodeWithName:rightEyelidLayerName];
            if (leftEyelid) {
                [leftEyelid reverseAction];
                          }
            
            if (rightEyelid) {
                [rightEyelid reverseAction];
            }
          
        }

        
        
        else if ([entity isKindOfClass:[WhiskerEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            WhiskerNode* whisker=(WhiskerNode*)[crop childNodeWithName:whiskerLayerName];
            
            if (whisker) {
                [whisker reverseAction];
            }
            
        }
        else if ([entity isKindOfClass:[BeardEntity class]]){
            BeardNode* beard=(BeardNode*)[faceNode childNodeWithName:beardLayerName];
            
            if (beard) {
                [beard reverseAction];
            }
            
            
        }
        
        else if ([entity isKindOfClass:[TattooEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            TattoNode * tattoo=(TattoNode*)[crop childNodeWithName:tattooLayerName];
            
            if (tattoo) {
                [tattoo reverseAction];
            }
            
        }
        
        
        else if ([entity isKindOfClass:[UnderEyeEntity class]]){
            FaceCropNode*crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            
            
            UnderEyeLeftNode* underEyeLeft=(UnderEyeLeftNode*)[crop childNodeWithName:underEyeLeftLayerName];
            UnderEyeRightNode* underEyeRight=(UnderEyeRightNode*)[crop childNodeWithName:underEyeRightLayerName];
            
            
            
            if (underEyeLeft) {
                [underEyeLeft reverseAction];
            }
            
            if (underEyeRight) {
                [underEyeRight reverseAction];
            }
            
            
        }
        
        
        else if ([entity isKindOfClass:[EarDecorationEntity class]]){
            EarNode*ear=(EarNode*)[faceNode childNodeWithName:earLayerName];
            EarDecorationNode* earDecorationNode=(EarDecorationNode*)[ear childNodeWithName:earDecoLayerName];
            if (earDecorationNode) {
                [earDecorationNode reverseAction];
            }
            
            
        }
        
        else if ([entity isKindOfClass:[SmallBeardEntity class]]){
            SmallBeard* smallBeard=(SmallBeard*)[faceNode childNodeWithName:smallBeardLayerName];
            if (smallBeard) {
                [smallBeard reverseAction];
            }
            
        }
        else if ([entity isKindOfClass:[BrowLikeSmallBeardEntity class]]){
            BrowLikeSmallBeard* beardLeft=(BrowLikeSmallBeard*)[faceNode childNodeWithName:browLikeSmallBeardLayerName];
            RightBrowLikeSmallBeard* beardRight=(RightBrowLikeSmallBeard*)[faceNode childNodeWithName:rightBrowLikeSmallBeardLayerName];
            
            
            
            if (beardLeft) {
                [beardLeft reverseAction];
            }
            
            if (beardRight) {
                [beardRight reverseAction];
            }
            
        }
        
        
        //out face :单层附件
        else if ([entity isKindOfClass:[SingleAccessoryEntity class]]||[entity isKindOfClass:[DoubleAccessoryEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            
        }
        
        //out face :左右附件
        else if ([entity isKindOfClass:[LeftRightAccessoryEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
        }
        
        
        //in face :单层附件
        else if ([entity isKindOfClass:[AccessoryInFaceSingleEntity class]]||[entity isKindOfClass:[AccessoryInFaceDoubleEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
            
        }
        
        //in face :左右附件
        else if ([entity isKindOfClass:[AccessoryInFaceLeftRightEntity class]]){
            //hasBeenAdded表明此次entity是否已经在scene中添加过了
            NSSet *set=[scene recordsOfAccessoryUsage];
            __block BOOL hasOne=NO;
            [set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                AccessoryRecordObject*object=(AccessoryRecordObject*)obj;
                hasOne=([object.currentEntity isEqual: entity]);
                if (hasOne) {
                    //卸载此附件
                    [scene removeRecord:object];
                    *stop=YES;
                    [_controller setCurrentNode:nil];
                    
                }
            }];
        }
        
    }
}


-(void)removeNode:(BaseEntity*)entity{
    if (entity) {
        MyScene*scene=(MyScene*)[[SKSceneCache singleton] scene];

        FaceNode* faceNode=(FaceNode*)[scene childNodeWithName:faceLayerName];
        
        //CGSize faceSize=[Pixel2Point pixel2point:faceNode.texture.size] ;
        if ([entity isKindOfClass:[FaceEntity class]]) {
            [faceNode changeTexture:entity];
        }
        else if ([entity isKindOfClass:[MouthEntity class]]){
            MouthNode* mouthNode=(MouthNode*)[faceNode childNodeWithName:mouthLayerName] ;
            if (mouthNode) {
                [mouthNode setHidden:YES];
            }
          
            
        }
        
        
        
        else if ([entity isKindOfClass:[NoseEntity class]]){
            NoseNode* noseNode=(NoseNode*)[faceNode childNodeWithName:noseLayerName] ;
            
            if (noseNode) {
                [noseNode setHidden:YES];
            }
            
            
        }
        else if ([entity isKindOfClass:[HairEntity class]]){
            DPI300Node* hairNode=(DPI300Node*)[faceNode childNodeWithName:hairLayerName] ;
           
            [hairNode setHidden:YES];
        }
        
        else if ([entity isKindOfClass:[GirlHairEntity class]]){
            HairNode* hairNode=(HairNode*)[faceNode childNodeWithName:hairLayerName] ;
            //如果本来就是女发直接changetexture
            if ([hairNode childNodeWithName:girlBehindHairLayerName]) {
                [hairNode setHidden:YES];
            }
            
        }
        else if ([entity isKindOfClass:[EarEntity class]]){
            EarNode* earNode=(EarNode*)[faceNode childNodeWithName:earLayerName] ;
            if (earNode) {
                [earNode setHidden:YES];
            }
           
        }
        else if ([entity isKindOfClass:[EyeEntity class]]||[entity isKindOfClass:[DoubleEyeEntity class]]){
            EyeLeftNode* leftEye=(EyeLeftNode*)[faceNode childNodeWithName:eyeLeftLayerName] ;
            if (leftEye) {
                [leftEye setHidden:YES];
            }
           
            
            
            EyeRightNode* rightEye=(EyeRightNode*)leftEye.bindActionNode;
            if (rightEye) {
                [rightEye setHidden:YES];
            }
            
        }
        
        
        
        else if ([entity isKindOfClass:[BrowEntity class]]){
            BrowLeftNode* leftBrow=(BrowLeftNode*)[faceNode childNodeWithName:browLeftLayerName] ;
            if (leftBrow) {
                [leftBrow setHidden:YES];
            }
            
            BrowRightNode* rightBrow=(BrowRightNode*)leftBrow.bindActionNode;
            if (rightBrow) {
                [rightBrow setHidden:YES];
            }
                  }

        else if ([entity isKindOfClass:[EyeballEntity class]]){
            EyeballCropNode* leftEyeballCrop=(EyeballCropNode*)[[faceNode childNodeWithName:eyeLeftLayerName]childNodeWithName:eyeballCropLayerName ] ;
            EyeBallNode* leftEyeball=(EyeBallNode*)[leftEyeballCrop childNodeWithName:eyeballLayerName] ;
            
            if (leftEyeball) {
                [leftEyeball setHidden:YES];
            }
            
            
            EyeBallNode* rightEyeball=(EyeBallNode*)leftEyeball.bindActionNode;
            if (rightEyeball) {
                [rightEyeball setHidden:YES];
            }
            [_controller setCurrentNode:leftEyeball];
        }

        
       
         if ([entity isKindOfClass:[GlassEntity class]]||
                 [entity isKindOfClass:[SingleGlassEntity class]]){
            DPI300Node* glass=(DPI300Node*)  [faceNode childNodeWithName:glassLayerName];
            
            if (glass) {
                [glass setHidden:YES];
            }
        }
        else if ([entity isKindOfClass:[NeckEntity class]]){
       
            
            NeckNode* neck=(NeckNode*)[faceNode childNodeWithName:neckLayerName];
            if (neck) {
                [neck setHidden:YES];
            }
            
        }
        else if ([entity isKindOfClass:[BodyEntity class]]){
        
            
            BodyNode*body=(BodyNode*)[faceNode childNodeWithName:bodyLayerName];
            if(body)
            {
                [body setHidden:YES];
                
            }
         
            
        }
        
        else if ([entity isKindOfClass:[CapEntity class]]||[entity isKindOfClass:[CapWithBackgroundEntity class]]){
            DPI300Node* cap=(DPI300Node*)  [faceNode childNodeWithName:capLayerName];
            if (cap) {
                [cap setHidden:YES];
            }
         
            
        }
        
        
        
        else if ([entity isKindOfClass:[FrontHairEntity class]]){
            FrontHairNode  * frontHair=(FrontHairNode*)  [faceNode childNodeWithName:frontHairLayerName];
            
            if (frontHair) {
                [frontHair setHidden:YES];
            }
          
            
          }
        else if ([entity isKindOfClass:[BehindHairEntity class]]){
            BehindHairNode  * behindHair=(BehindHairNode*)  [faceNode childNodeWithName:behindHairLayerName];
            
            if (behindHair) {
                [behindHair setHidden:YES];
            }
            
        }
        
        else if ([entity isKindOfClass:[EyelashEntity class]]){
            EyelashNode* leftEyelash=(EyelashNode*)[[faceNode childNodeWithName:eyeLeftLayerName] childNodeWithName:eyelashLeftLayerName];
            EyelashNode* rightEyelash=(EyelashNode*)[[faceNode childNodeWithName:eyeRightLayerName] childNodeWithName:eyelashRightLayerName];
            if (leftEyelash) {
                [leftEyelash setHidden:YES];
            }
            
            if (rightEyelash) {
                [rightEyelash setHidden:YES];
            }
        }
        
        else if ([entity isKindOfClass:[EyelidEntity class]]){
            FaceCropNode* crop=(FaceCropNode* )[faceNode childNodeWithName:faceCropLayerName];
            
            EyeLeftlid* leftEyelid=(EyeLeftlid*)[crop childNodeWithName:leftEyelidLayerName] ;
            EyeRightlid* rightEyelid=(EyeRightlid*)[crop childNodeWithName:rightEyelidLayerName];
            if (leftEyelid) {
                [leftEyelid setHidden:YES];
            }
            
            if (rightEyelid) {
                [rightEyelid setHidden:YES];
            }
            
        }
        
        else if ([entity isKindOfClass:[WhiskerEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            WhiskerNode* whisker=(WhiskerNode*)[crop childNodeWithName:whiskerLayerName];
         
            
            if (whisker) {
                [whisker setHidden:YES];
            }
            
        }
        else if ([entity isKindOfClass:[BeardEntity class]]){

            BeardNode* beard=(BeardNode*)[faceNode childNodeWithName:beardLayerName];
            
            if (beard) {
                [beard setHidden:YES];
            }
            
        }
        
        else if ([entity isKindOfClass:[TattooEntity class]]){
            FaceCropNode* crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            TattoNode * tattoo=(TattoNode*)[crop childNodeWithName:tattooLayerName];
            
            if (tattoo) {
                [tattoo setHidden:YES];
            }
         
        }
        
        
        else if ([entity isKindOfClass:[UnderEyeEntity class]]){
            FaceCropNode*crop=(FaceCropNode*)[faceNode childNodeWithName:faceCropLayerName];
            
            
            UnderEyeLeftNode* underEyeLeft=(UnderEyeLeftNode*)[crop childNodeWithName:underEyeLeftLayerName];
            UnderEyeRightNode* underEyeRight=(UnderEyeRightNode*)[crop childNodeWithName:underEyeRightLayerName];
            
            
            
            if (underEyeLeft) {
                [underEyeLeft setHidden:YES];
            }
      
            
            if (underEyeRight) {
                [underEyeRight setHidden:YES];
            }
           
            
        }
        
        
        else if ([entity isKindOfClass:[EarDecorationEntity class]]){
            EarNode*ear=(EarNode*)[faceNode childNodeWithName:earLayerName];
            EarDecorationNode* earDecorationNode=(EarDecorationNode*)[ear childNodeWithName:earDecoLayerName];
            if (earDecorationNode) {
                [earDecorationNode setHidden:YES];
            }
            
        }
        
        else if ([entity isKindOfClass:[SmallBeardEntity class]]){
      
            
            SmallBeard* smallBeard=(SmallBeard*)[faceNode childNodeWithName:smallBeardLayerName];
            if (smallBeard) {
                [smallBeard setHidden:YES];
            }
       
            
        }
        else if ([entity isKindOfClass:[BrowLikeSmallBeardEntity class]]){
            BrowLikeSmallBeard* beardLeft=(BrowLikeSmallBeard*)[faceNode childNodeWithName:browLikeSmallBeardLayerName];
            RightBrowLikeSmallBeard* beardRight=(RightBrowLikeSmallBeard*)[faceNode childNodeWithName:rightBrowLikeSmallBeardLayerName];
            
            
            
            if (beardLeft) {
                [beardLeft setHidden:YES];

            }
          
            if (beardRight) {
                [beardRight setHidden:YES];
            }
        }
       
        
        
        
    }

}

//-(void)RandomColorWithBroadcast:(NSNotification*)sender{
//    
//    self.randomColor=((NSNumber*)[sender.userInfo objectForKey:@"random_color"]).boolValue;
//    
//    
//}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
