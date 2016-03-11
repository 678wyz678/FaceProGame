//
//  FirstScreenControllerViewController.m
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "FirstScreenControllerViewController.h"
#import "FirstScreenScene.h"
#import "GetListOfFiles.h"
#import "FeatureArray.h"
#import "ImportAllEntity.h"
#import "DetectFeatureKind.h"
#import <SCLAlertView-Objective-C/SCLAlertView.h>
#import <math.h>
#import "DefaultEntity.h"
#import "SKSceneCache.h"
#import "MyScene.h"
#import "ExtendPackageDelegate.h"
#import "GlobalNavigationViewController.h"
#import "SKNode+RecurseHideGaussian.h"
#define shareBodyArrayName @"shareBodyBounce"

@interface MyFileSearchObject : NSObject
@property NSString* pureFileName;
@property NSString* filePath;
@end
@implementation MyFileSearchObject
-(instancetype)initWithPureFileName:(NSString*)fileName filePath:(NSString*)filePath{
    if (self=[super init]) {
        _filePath=filePath;
        _pureFileName=fileName;
    }
    return self;
}
@end

@interface FirstScreenControllerViewController ()
@property FirstScreenScene* scene;
@property SCLAlertView* alertView;
@property (nonatomic,assign)BOOL imagesLoaded;
@end

@implementation FirstScreenControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _scene=[[FirstScreenScene alloc]initWithSize:[UIScreen mainScreen].bounds.size];
    [_skView presentScene:_scene];
    [ExtendPackageDelegate singleton];
    _scene.backgroundColor=[UIColor colorWithRed:0xf5/255.f green:0xf5/255.f blue:0xf5/255.f alpha:1];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadImages];
    });
    _alertView = [[SCLAlertView alloc] init];

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    self.skView.frameInterval=4.0;
    self.scene.physicsWorld.gravity=CGVectorMake(0, 0);
    [self.scene reset];
    
    [self loadHistory];

}
-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
   CGPoint location= [sender locationInView:_skView];
   CGPoint convertedPoint= [_scene convertPointFromView:location];
   NSArray * tappedNodes= [_scene nodesAtPoint:convertedPoint];
    
    [tappedNodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKSpriteNode*tappedNode=(SKSpriteNode*)obj;

        if ([tappedNode.name isEqualToString:@"Start"]) {
            
            if(!_imagesLoaded){
            [_alertView showWaiting:self title:[NSString stringWithFormat:@"%@...",NSLocalizedString(@"waiting", "等待语")] subTitle:[NSString stringWithFormat:@"%@...",NSLocalizedString(@"loading", "加载")] closeButtonTitle:nil duration:0.0 block:^{
dispatch_async(dispatch_get_main_queue(), ^{
    
    GlobalNavigationViewController*navigationController=  (GlobalNavigationViewController*) self.navigationController;
    [navigationController showMainController];

});
              
                
            }];
            }
            else{
                GlobalNavigationViewController*navigationController=  (GlobalNavigationViewController*) self.navigationController;
                [navigationController showMainController];
            }
            
            *stop=YES;

            

        }
        else if ([tappedNode.name isEqualToString:@"setting"]||[tappedNode.name isEqualToString:@"gallery"]||
                 [tappedNode.name isEqualToString:@"team"]){
            SKAction*action1=[SKAction rotateByAngle:M_PI/7.0f duration:0.12];
            SKAction*action2=[SKAction rotateByAngle:-M_PI/7.0f duration:0.12];
            SKAction*action3=[SKAction rotateByAngle:M_PI/7.0f duration:0.12];
            SKAction*action4=[SKAction rotateByAngle:-M_PI/7.0f duration:0.12];
            tappedNode.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:1.f];
            tappedNode.physicsBody.dynamic=YES;
            SKAction* sequence=[SKAction sequence:@[action1,action2,action3,action4]];
            [tappedNode runAction:sequence completion:^{
                self.scene.physicsWorld.gravity=CGVectorMake(0, -10);
                if ([tappedNode.name isEqualToString:@"setting"]) {
                    NSString*Controller=@"GlobalSetting";
                    NSString*Storyboard=@"Main";
                    NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
                }
               else if ([tappedNode.name isEqualToString:@"gallery"]) {
                    NSString*Controller=@"Gallery_Controller";
                    NSString*Storyboard=@"Main";
                   NSNumber*Param=[NSNumber numberWithBool:YES];
                   
                    NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard,Param);
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
                }
               else if ([tappedNode.name isEqualToString:@"team"]) {
                   NSString*Controller=@"team_controller";
                   NSString*Storyboard=@"Other";
                   NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard);
                   [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
               }
                
                *stop=YES;

            }];

            *stop=YES;
        }
        else if([tappedNode.name isEqualToString:@"store"]){
            NSString*Controller=@"Store";
            NSString*Storyboard=@"Main";
            NSDictionary*dict=NSDictionaryOfVariableBindings(Controller,Storyboard);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SHOW_CONTROLLER" object:self userInfo:dict];
            *stop=YES;

        }
        
        else if ([tappedNode isKindOfClass:[MyScene class]]){
            *stop=YES;

            MyScene*scene=(MyScene*)tappedNode;
            if (scene) {

                GlobalNavigationViewController*navigationController=  (GlobalNavigationViewController*) self.navigationController;
                [navigationController showMainControllerWithSceneName:scene.name];
            
            }
        }
        
        
    }];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.skView.frameInterval=100;
    [self removeHistory];
}
-(void)removeHistory{
    [[self.scene children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode*node=(SKNode*)obj;
        if ([node.name isEqualToString:@"scene_wrapper"]) {
           
            [node removeFromParent];
        }
    }];
}

-(void)loadHistory{
    //先清除所有已有的scene
    
    [[self.scene children] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SKNode*node=(SKNode*)obj ;
        if ([node.name isEqualToString:@"scene_wrapper"]) {
            [node removeFromParent];
        }
    }];
    
   
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString* newPath=  [documentsDirectory stringByAppendingPathComponent:@"SavedImages"];
    NSArray * fileList=[[NSUserDefaults standardUserDefaults] valueForKey:@"FIRST_SCREEN_STACK"];//[GetListOfFiles getListOfFiles :newPath];
    NSInteger loopTime=(fileList.count>=5)?5:fileList.count;
    for (NSInteger i=0; i<loopTime; i++) {
        [self addScene:fileList[fileList.count-1-i] currentSceneIndex:i];
    }
    
}

-(void)addScene:(NSString*)sceneName  currentSceneIndex:(NSInteger)index{
    CGSize SCREEN_SIZE=[UIScreen mainScreen].bounds.size;

    CGFloat zRotation=M_PI/6.f;
    CGPoint location=CGPointMake(SCREEN_SIZE.width/-3.0f, -SCREEN_SIZE.height*0.07);

    switch (index) {
        case 0:
            break;
        case 1:
            zRotation=0;
            location=CGPointMake(0.f, SCREEN_SIZE.height*0.03);
            break;
        case 2:
            zRotation=-M_PI/6.f;
            location=CGPointMake(SCREEN_SIZE.width/2.88f, SCREEN_SIZE.height*0.008);
            break;
            
            
        case 3:
            zRotation=M_PI/14.f;
            location=CGPointMake(SCREEN_SIZE.width/-5.2f, SCREEN_SIZE.height*0.08);
            break;
        case 4:
            zRotation=-M_PI/14.f;
            location=CGPointMake(SCREEN_SIZE.width/5.2f, SCREEN_SIZE.height*0.1);
            break;
        default:
            break;
    }
    
    NSString*fileName= sceneName;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",fileName]];
    
    
    MyScene*scene = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile] ;
    
  
    
    SKNode*wrapper=[SKNode node];
    wrapper.name=@"scene_wrapper";
    if (scene) {
        scene.name=sceneName;
        [[scene childNodeWithName:@"line_container"] removeFromParent];
        [[scene childNodeWithName:@"background"] removeFromParent];
        [[scene childNodeWithName:@"star_wrapper"] removeFromParent];
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_7_1) {
            //IOS7有背景层
            [[self.scene childNodeWithName:@"background"] removeFromParent];
        }
        
        [[scene childNodeWithName:@"font"] removeFromParent];
        [scene hideGaussian];
        
        
        
        scene.anchorPoint=CGPointMake(0, 0);
        [wrapper addChild:scene];
        [self.skView.scene addChild:wrapper];
        NSInteger i=index;
        wrapper.zPosition=-i*100-300;
        [wrapper setScale:0.0001];
        wrapper.alpha=0;
        [wrapper setZRotation:zRotation];
        wrapper.position=location;
        SKAction*action1=[SKAction scaleTo:0.45 duration:0.65];
        SKAction*action2=[SKAction fadeAlphaTo:1  duration:0.85];
        [wrapper runAction:[SKAction group:@[action1,action2]]];
    }
    
}


//加载图片包
-(void)loadImages{
    FeatureArray* cacheArray=[FeatureArray singleton];
    
    
    for (int i=325; i<=408; i++) {
        FaceEntity* face=[[FaceEntity alloc]initWithShadow:[NSString stringWithFormat:@"face_%d.png",i] shadowFile:nil];
        face.indexFileName=[NSString stringWithFormat:@"/index/face/face_%d.png",i];
        if (i==7) {
            
            [DefaultEntity singleton].faceEntity=face;
            
        }
        [cacheArray.faceArray addObject:face];
    }
    for (int i=1; i<=324; i++) {
        FaceEntity* face=[[FaceEntity alloc]initWithShadow:[NSString stringWithFormat:@"face_%d.png",i] shadowFile:nil];
        face.indexFileName=[NSString stringWithFormat:@"/index/face/face_%d.png",i];
        if (i==7) {
            
            [DefaultEntity singleton].faceEntity=face;

        }
        [cacheArray.faceArray addObject:face];
    }
    
    
    for (int i=1; i<=244; i++) {
        GirlHairEntity*entity=[[GirlHairEntity alloc]initWithGirlBehindHair:[NSString stringWithFormat:@"girl_front_hair_%d.png",i] behindHair:[NSString stringWithFormat:@"girl_behind_hair_%d.png",i]];
        entity.indexFileName=[NSString stringWithFormat:@"/index/hair/GirlHair/girl_front_hair_%d.png",i];
        [cacheArray.hairArray addObject:entity];
        if (i==3) {
            [DefaultEntity singleton].hairEntity=entity;
        }
    }
    
    for (int i=201; i<=228; i++) {
        BrowEntity* browEntity=[[BrowEntity alloc]initWithPair:[NSString stringWithFormat:@"brow_left_%d.png",i] pairFile:[NSString stringWithFormat:@"brow_right_%d.png",i]];
        browEntity.indexFileName=[NSString stringWithFormat:@"/index/brow/brow_left_%d.png",i];
        [cacheArray.browArray addObject:browEntity];
        if (i==3) {
            [DefaultEntity singleton].browEntity=browEntity;
        }
    }
    for (int i=2; i<=200; i++) {
        BrowEntity* browEntity=[[BrowEntity alloc]initWithPair:[NSString stringWithFormat:@"brow_left_%d.png",i] pairFile:[NSString stringWithFormat:@"brow_right_%d.png",i]];
        browEntity.indexFileName=[NSString stringWithFormat:@"/index/brow/brow_left_%d.png",i];
        [cacheArray.browArray addObject:browEntity];
        if (i==3) {
            [DefaultEntity singleton].browEntity=browEntity;
        }
    }
    for (int i=53; i<=59; i++) {
        CapWithBackgroundEntity* capEntity=[[CapWithBackgroundEntity alloc]initWithBackgroundFile:[NSString stringWithFormat:@"cap_with_back_%d.png",i]  shadowFile:[NSString stringWithFormat:@"cap_with_back_shadow_%d.png",i] backgroundFile:[NSString stringWithFormat:@"cap_with_back_background_%d.png",i]];
        capEntity.indexFileName=[NSString stringWithFormat:@"/index/cap/WithBackground/cap_with_back_%d.png",i];
        [cacheArray.capArray addObject:capEntity];
    }
    for (int i=1; i<=52; i++) {
        CapWithBackgroundEntity* capEntity=[[CapWithBackgroundEntity alloc]initWithBackgroundFile:[NSString stringWithFormat:@"cap_with_back_%d.png",i]  shadowFile:[NSString stringWithFormat:@"cap_with_back_shadow_%d.png",i] backgroundFile:[NSString stringWithFormat:@"cap_with_back_background_%d.png",i]];
        capEntity.indexFileName=[NSString stringWithFormat:@"/index/cap/WithBackground/cap_with_back_%d.png",i];
        [cacheArray.capArray addObject:capEntity];
    }
    for (int i=2; i<=27; i++) {
        EarEntity* earEntity=[[EarEntity alloc]init:[NSString stringWithFormat:@"ear_%d.png",i]];
        earEntity.indexFileName=[NSString stringWithFormat:@"/index/ear/ear_%d.png",i];
        [cacheArray.earArray addObject:earEntity];
        if (i==19) {
            [DefaultEntity singleton].earEntity=earEntity;
        }
    }
    
    
    
    for (int i=121; i<=154; i++) {
        DoubleEyeEntity* doubleEye=[[DoubleEyeEntity alloc]initWithSelf:[NSString stringWithFormat:@"eye_left_small_%d.png",i] selfBigFile:[NSString stringWithFormat:@"eye_left_big_%d.png",i] pairSmallFile:[NSString stringWithFormat:@"eye_right_small_%d.png",i] pairBigFile:[NSString stringWithFormat:@"eye_right_big_%d.png",i]];
        doubleEye.indexFileName=[NSString stringWithFormat:@"/index/eye/Double/eye_left_small_%d.png",i];
        [cacheArray.eyeArray addObject:doubleEye];
        if (i==2) {
            [DefaultEntity singleton].eyeEntity=doubleEye;
        }
    }
    for (int i=2; i<=113; i++) {
        DoubleEyeEntity* doubleEye=[[DoubleEyeEntity alloc]initWithSelf:[NSString stringWithFormat:@"eye_left_small_%d.png",i] selfBigFile:[NSString stringWithFormat:@"eye_left_big_%d.png",i] pairSmallFile:[NSString stringWithFormat:@"eye_right_small_%d.png",i] pairBigFile:[NSString stringWithFormat:@"eye_right_big_%d.png",i]];
        doubleEye.indexFileName=[NSString stringWithFormat:@"/index/eye/Double/eye_left_small_%d.png",i];
        [cacheArray.eyeArray addObject:doubleEye];
        if (i==2) {
            [DefaultEntity singleton].eyeEntity=doubleEye;
        }
    }
    for (int i=16; i<=22; i++) {
        EyeEntity* entity=[[EyeEntity alloc]initWithPair:[NSString stringWithFormat:@"eye_left_%d.png",i] pairFile:[NSString stringWithFormat:@"eye_right_%d.png",i]];
        entity.indexFileName=[NSString stringWithFormat:@"/index/eye/Single/eye_left_%d.png",i];
        [cacheArray.eyeArray addObject:entity];

    }
    for (int i=117; i<=120; i++) {
        DoubleEyeEntity* doubleEye=[[DoubleEyeEntity alloc]initWithSelf:[NSString stringWithFormat:@"eye_left_small_%d.png",i] selfBigFile:[NSString stringWithFormat:@"eye_left_big_%d.png",i] pairSmallFile:[NSString stringWithFormat:@"eye_right_small_%d.png",i] pairBigFile:[NSString stringWithFormat:@"eye_right_big_%d.png",i]];
        doubleEye.indexFileName=[NSString stringWithFormat:@"/index/eye/Double/eye_left_small_%d.png",i];
        [cacheArray.eyeArray addObject:doubleEye];
    }
    
    
    
    for (int i=2; i<=48; i++) {
        EyeballEntity*eyeball=[[EyeballEntity alloc]initWithShadow:[NSString stringWithFormat:@"eyeball_%d.png",i] shadowFile:[NSString stringWithFormat:@"eyeball_shadow_%d.png",i]];
        eyeball.indexFileName=[NSString stringWithFormat:@"/index/eye/eyeball/eyeball_%d.png",i];
        if (i==12) {
            [DefaultEntity singleton].eyeballEntity=eyeball;
        }
        [cacheArray.eyeballArray addObject:eyeball];
    }
    
   
    for (int i=40; i<=44; i++) {
        GlassEntity*entity=[[GlassEntity alloc]initWithShadow:[NSString stringWithFormat:@"glass_%d.png",i] shadowFile:[NSString stringWithFormat:@"glass_shadow_%d.png",i]];
        entity.indexFileName=[NSString stringWithFormat:@"/index/glass/glass_%d.png",i];
        [cacheArray.glassArray addObject:entity];
    }
    for (int i=1; i<=39; i++) {
        GlassEntity*entity=[[GlassEntity alloc]initWithShadow:[NSString stringWithFormat:@"glass_%d.png",i] shadowFile:[NSString stringWithFormat:@"glass_shadow_%d.png",i]];
        entity.indexFileName=[NSString stringWithFormat:@"/index/glass/glass_%d.png",i];
        [cacheArray.glassArray addObject:entity];
    }
    for (int i=185; i<=208; i++) {
        MouthEntity* mouth=[[MouthEntity alloc]initWithShadow:[NSString stringWithFormat:@"mouth_%d.png",i] shadowFile:[NSString stringWithFormat:@"mouth_shadow_%d.png",i]];
        mouth.indexFileName=[NSString stringWithFormat:@"/index/mouth/mouth_%d.png",i];
        [cacheArray.mouthArray addObject:mouth];
        if (i==4) {
            [DefaultEntity singleton].mouthEntity=mouth;
        }
    }
    for (int i=1; i<=184; i++) {
        MouthEntity* mouth=[[MouthEntity alloc]initWithShadow:[NSString stringWithFormat:@"mouth_%d.png",i] shadowFile:[NSString stringWithFormat:@"mouth_shadow_%d.png",i]];
        mouth.indexFileName=[NSString stringWithFormat:@"/index/mouth/mouth_%d.png",i];
        [cacheArray.mouthArray addObject:mouth];
        if (i==4) {
            [DefaultEntity singleton].mouthEntity=mouth;
        }
    }
    for (int i=2; i<=11; i++) {
        NeckEntity* neck=[[NeckEntity alloc]init:[NSString stringWithFormat:@"neck_%d.png",i]];
        neck.indexFileName=[NSString stringWithFormat:@"/index/neck/neck_%d.png",i];
        [cacheArray.neckArray addObject:neck];
        if (i==4) {
            [DefaultEntity singleton].neckEntity=neck;
        }
    }
    
    
    for (int i=153; i<=176; i++) {
        NoseEntity* nose=[[NoseEntity alloc]init:[NSString stringWithFormat:@"nose_%d.png",i]];
        nose.indexFileName=[NSString stringWithFormat:@"/index/nose/nose_%d.png",i];
        [cacheArray.noseArray addObject:nose];
        if (i==54) {
            [DefaultEntity singleton].noseEntity=nose;
        }
    }
    
    for (int i=1; i<=152; i++) {
        NoseEntity* nose=[[NoseEntity alloc]init:[NSString stringWithFormat:@"nose_%d.png",i]];
        nose.indexFileName=[NSString stringWithFormat:@"/index/nose/nose_%d.png",i];
        [cacheArray.noseArray addObject:nose];
        if (i==54) {
            [DefaultEntity singleton].noseEntity=nose;
        }
    }
    
    for (int i=2; i<=66; i++) {
        FrontHairEntity* frontHair=[[FrontHairEntity alloc]init:[NSString stringWithFormat:@"front_hair_%d.png",i]];
        frontHair.indexFileName=[NSString stringWithFormat:@"/index/hair/front_hair/front_hair_%d.png",i];
        [cacheArray.frontHairArray addObject:frontHair];
       
    }
    for (int i=2; i<=76; i++) {
        BehindHairEntity* behindHair=[[BehindHairEntity alloc]init:[NSString stringWithFormat:@"behind_hair_%d.png",i]];
        behindHair.indexFileName=[NSString stringWithFormat:@"/index/hair/behind_hair/behind_hair_%d.png",i];
        [cacheArray.behindHairArray addObject:behindHair];
        
    }
    
    
    
    //化妆包
    
    for (int i=2; i<=21; i++) {
        EyelashEntity* eyelash=[[EyelashEntity alloc]initWithPair:[NSString stringWithFormat:@"eyelash_left_%d.png",i] pairFile:[NSString stringWithFormat:@"eyelash_right_%d.png",i]];
        eyelash.indexFileName=[NSString stringWithFormat:@"/index/eye/eyelash/%@",[NSString stringWithFormat:@"eyelash_left_%d.png",i]];

        [cacheArray.whelkArray addObject:eyelash];
    }
    for (int i=17; i<=28; i++) {
        NSString* featureName=[NSString stringWithFormat:@"eyelid_left_%d.png",i];
        NSString* pairName=[NSString stringWithFormat:@"eyelid_right_%d.png",i];
        EyelidEntity* entity=[[EyelidEntity alloc]initWithPair:featureName pairFile:pairName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/eye/eyelid/%@",featureName];
        [cacheArray.whelkArray addObject:entity];
    }
    
    for (int i=1; i<=16; i++) {
        UnderEyeEntity* underEye=[[UnderEyeEntity alloc]initWithPair:[NSString stringWithFormat:@"under_eye_left_%d.png",i] pairFile:[NSString stringWithFormat:@"under_eye_right_%d.png",i]];
        underEye.indexFileName=[NSString stringWithFormat:@"/index/eye/under_eye/%@",[NSString stringWithFormat:@"under_eye_left_%d.png",i]];
        [cacheArray.whelkArray addObject:underEye];
    }
    for (int i=13; i<=36; i++) {
        
        
        NSString* right=[NSString stringWithFormat:@"accessory_right_in_face_%d.png",i];
        NSString* left=[NSString stringWithFormat:@"accessory_left_in_face_%d.png",i];

        
        AccessoryInFaceLeftRightEntity * entity=[[AccessoryInFaceLeftRightEntity alloc]initWithPair:left pairFile:right];
        entity.indexFileName=[NSString stringWithFormat:@"/index/accessory/InFace/left/falinwen/%@",[NSString stringWithFormat:@"accessory_left_in_face_%d.png",i]];
        
        [cacheArray.whelkArray addObject:entity];
        
      }
    
    for (int i=25; i<=71; i++) {
        NSString* featureName=[NSString stringWithFormat:@"accessory_in_face_single_%d.png",i];
        AccessoryInFaceSingleEntity * entity=[[AccessoryInFaceSingleEntity alloc]init:featureName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/accessory/InFace/single/%@",featureName];
        [cacheArray.whelkArray addObject:entity];
        
    }
    
    
    for (int i=1; i<=12; i++) {
        
        
        NSString* right=[NSString stringWithFormat:@"accessory_right_in_face_%d.png",i];
        NSString* left=[NSString stringWithFormat:@"accessory_left_in_face_%d.png",i];
        
        
        AccessoryInFaceLeftRightEntity * entity=[[AccessoryInFaceLeftRightEntity alloc]initWithPair:left pairFile:right];
        entity.indexFileName=[NSString stringWithFormat:@"/index/accessory/InFace/left/blush/%@",[NSString stringWithFormat:@"accessory_left_in_face_%d.png",i]];
        
        [cacheArray.whelkArray addObject:entity];
        
    }
    for (int i=37; i<=41; i++) {
        
        
        NSString* right=[NSString stringWithFormat:@"accessory_right_in_face_%d.png",i];
        NSString* left=[NSString stringWithFormat:@"accessory_left_in_face_%d.png",i];
        
        
        AccessoryInFaceLeftRightEntity * entity=[[AccessoryInFaceLeftRightEntity alloc]initWithPair:left pairFile:right];
        entity.indexFileName=[NSString stringWithFormat:@"/index/accessory/InFace/left/blush/%@",[NSString stringWithFormat:@"accessory_left_in_face_%d.png",i]];
        
        [cacheArray.whelkArray addObject:entity];
        
    }
    
    
    for (int i=9; i<=25; i++) {
        NSString* featureName=[NSString stringWithFormat:@"accessory_single_%d.png",i];
        SingleAccessoryEntity * entity=[[SingleAccessoryEntity alloc]init:featureName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/accessory/single/whelk/%@",featureName];
        [cacheArray.whelkArray addObject:entity];
        
    }
    
    for (int i=17; i<=32; i++) {
        NSString* featureName=[NSString stringWithFormat:@"ear_deco_%d.png",i];
        EarDecorationEntity * entity=[[EarDecorationEntity alloc]initWithShadow:featureName shadowFile:[NSString stringWithFormat:@"ear_deco_shadow_%d.png",i]];
        entity.indexFileName=[NSString stringWithFormat:@"/index/ear_deco/%@",featureName];
        [cacheArray.whelkArray addObject:entity];
        
    }
    for (int i=1; i<=9; i++) {
        NSString* featureName=[NSString stringWithFormat:@"accessory_double_%d.png",i];
        DoubleAccessoryEntity * entity=[[DoubleAccessoryEntity alloc]initWithShadow:featureName shadowFile:[NSString stringWithFormat:@"accessory_double_shadow_%d.png",i]];
        entity.indexFileName=[NSString stringWithFormat:@"/index/accessory/double/head_deco/%@",featureName];
        [cacheArray.whelkArray addObject:entity];
        
    }
    
    for (int i=2; i<=22; i++) {
        NSString* featureName=[NSString stringWithFormat:@"beard_%d.png",i];
        BeardEntity * entity=[[BeardEntity alloc]init:featureName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/beard/Beard/%@",featureName];
        [cacheArray.whiskerArray addObject:entity];
    }
    for (int i=1; i<=17; i++) {
        NSString* featureName=[NSString stringWithFormat:@"whisker_%d.png",i];
        WhiskerEntity * entity=[[WhiskerEntity alloc]init:featureName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/beard/Whisker/%@",featureName];
        [cacheArray.whiskerArray addObject:entity];
    }
    for (int i=5; i<=22; i++) {
        NSString* featureName=[NSString stringWithFormat:@"brow_like_small_beard_left_%d.png",i];
        NSString* pairName=[NSString stringWithFormat:@"brow_like_small_beard_right_%d.png",i];

        BrowLikeSmallBeardEntity * entity=[[BrowLikeSmallBeardEntity alloc]initWithPair:featureName pairFile:pairName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/beard/BrowLikeSmallBeard/%@",featureName];
        [cacheArray.beardArray addObject:entity];
    }
    
    for (int i=1; i<=45; i++) {
        NSString* featureName=[NSString stringWithFormat:@"small_beard_%d.png",i];
        
        SmallBeardEntity * entity=[[SmallBeardEntity alloc]init:featureName];
        entity.indexFileName=[NSString stringWithFormat:@"/index/beard/SmallBeard/%@",featureName];
        [cacheArray.beardArray addObject:entity];
    }
 
    NSArray*arrayOfBody=[[NSUserDefaults standardUserDefaults] arrayForKey:shareBodyArrayName];
    [arrayOfBody enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString* num=obj;
        BodyEntity*entity=[[BodyEntity alloc]initWithShadow:[NSString stringWithFormat:@"my_body_%@.png",obj] shadowFile:[NSString stringWithFormat:@"my_body_shadow_%@.png",num]];
        entity.indexFileName=[NSString stringWithFormat:@"/PIndex/身体/my_body_%@.png",num];
        [cacheArray.neckArray addObject:entity];

    }];
    
   
    
    
    
    
    //开始迭代
    NSFileManager*fm=[[NSFileManager alloc]init];
    NSArray   *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString  *documentsDirectory = [paths objectAtIndex:0];
    NSString* imageRoot=[documentsDirectory stringByAppendingPathComponent:@"updatedIndexImages"];
    
    NSMutableArray *allFeatures = [[NSMutableArray alloc] init];
    
    // Enumerators are recursive
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:imageRoot] ;
    NSString *filePath;
    
    while ((filePath = [enumerator nextObject]) != nil){
        
        // If we have the right type of file, add it to the list
        // Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:@"png"]){
            MyFileSearchObject * object=[[MyFileSearchObject alloc]initWithPureFileName:[filePath lastPathComponent] filePath:[imageRoot stringByAppendingPathComponent:filePath]];
            [allFeatures addObject:object ];
        }
    }
    //迭代结束
    
    
    
    [allFeatures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        //CGFloat progressNum=idx*100/allFeatures.count;
            MyFileSearchObject * object=(MyFileSearchObject*)obj;
                    //查找素材
        NSLog(@"detect");
            [DetectFeatureKind detectFeatureAndAddToCache:object.pureFileName indexFilePath:object.filePath];
        
        
    }];
    self.imagesLoaded=YES;
    
}

-(void)setImagesLoaded:(BOOL)imagesLoaded{
    _imagesLoaded=imagesLoaded;
    if (imagesLoaded&&_alertView) {
        [_alertView executeCompletionBlockForWaiting];
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
@end
