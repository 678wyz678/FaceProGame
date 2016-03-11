//
//  BrowRightNode.h
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "PairNodes.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_Colorable.h"
#import "P_SyncRotate.h"
@interface BrowRightNode : DPI300Node<P_SyncRotate, PairNodes,P_Dragable,P_Zoom>
@end
