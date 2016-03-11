//
//  FontNode.h
//  face plus
//
//  Created by linxudong on 1/2/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "P_Order.h"
#import "P_Rotate.h"
#import "P_Dragable.h"
#import "P_Colorable.h"
#import "P_Zoom.h"
@interface FontNode : SKLabelNode<P_Order,P_Colorable,P_Dragable,P_Rotate,P_Zoom>
@property (assign)BOOL selectable;
@property (assign)int selectedPriority;
@end
