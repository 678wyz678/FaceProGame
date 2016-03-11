//
//  BubbleScene.m
//  face plus
//
//  Created by linxudong on 12/16/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "BubbleScene.h"

@implementation BubbleScene
-(void)didSimulatePhysics
{
    [self enumerateChildNodesWithName:@"bubble" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.position.y > [UIScreen mainScreen].bounds.size.height)
            [node removeFromParent];
    }];
}
@end
