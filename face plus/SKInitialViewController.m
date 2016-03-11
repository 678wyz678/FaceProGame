//
//  SKInitialViewController.m
//  face plus
//
//  Created by linxudong on 12/15/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "SKInitialViewController.h"
#import <SpriteKit/SpriteKit.h>
#import "BubbleScene.h"
#import "UIView+PopAnimation.h"
@interface SKInitialViewController ()
@property SKScene* scene;
@property NSArray* roleArray;
@end

@implementation SKInitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BubbleScene* scene=[[BubbleScene alloc] initWithSize:self.view.frame.size];
    scene.physicsWorld.gravity=CGVectorMake(0, 0.22);
    scene.backgroundColor=self.view.backgroundColor;
   
    self.scene=scene;
    
    _roundView.layer.cornerRadius=55;
    _roundView.backgroundColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:1];
     [_skView presentScene:scene];
    
    _roleArray=@[@"role_1",@"role_2",@"role_3"];
    
    // Do any additional setup after loading the view.
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
   
    SKAction *makeRocks = [SKAction sequence: @[
                                                [SKAction performSelector:@selector(generateBubble) onTarget:self],
                                                [SKAction waitForDuration:1.250 withRange:0.15]
                                                ]];
    [self.scene runAction: [SKAction repeatActionForever:makeRocks]];

    //[_roundView startGlowingWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] intensity:0.14];
    [_roundView breathPOP];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}
- (void)viewWillAppear:(BOOL)animated   {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden= YES;

}
-(void)generateBubble{
    CGFloat radius=skRand(16, 100);
    SKShapeNode *bubble = [SKShapeNode shapeNodeWithCircleOfRadius:radius];
    bubble.strokeColor=[UIColor whiteColor];
    //bubble.glowWidth=3.5;
    bubble.blendMode=SKBlendModeAlpha;
    //bubble.alpha=0.6;
   bubble.fillColor=[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6];
    NSUInteger randomIndex = arc4random() % [_roleArray count];
    //bubble.fillTexture=[SKTexture textureWithImageNamed:[_roleArray objectAtIndex:randomIndex]];
    bubble.zPosition=10;
    bubble.position= CGPointMake(skRand(0, 320),-28);

    bubble.name = @"bubble";
    bubble.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:28];
    bubble.physicsBody.usesPreciseCollisionDetection = YES;
    
    SKSpriteNode* image=[[SKSpriteNode alloc]initWithImageNamed:[_roleArray objectAtIndex:randomIndex]];
    
    [bubble addChild:image];
    image.size=CGSizeMake(2*radius*0.81, 2*radius*0.81);
    image.position=CGPointZero;
    [self.scene addChild:bubble];
  
}

static inline CGFloat skRand(CGFloat low, CGFloat high) {
    return skRandf() * (high - low) + low;
}
static inline CGFloat skRandf() {
    return rand() / (CGFloat) RAND_MAX;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
