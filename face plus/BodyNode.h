//
//  BodyNode.h
//  face plus
//
//  Created by linxudong on 15/2/2.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DPI300Node.h"
#import "P_Zoom.h"
#import "P_Dragable.h"
#import "P_Colorable.h"
#import "P_Rotate.h"
@interface BodyNode : DPI300Node<P_Colorable,P_Dragable,P_Rotate,P_Zoom>

@end
