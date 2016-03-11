//
//  EyeBallNode.h
//  face plus
//
//  Created by linxudong on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "PairNodes.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_SyncDrag.h"
#import "P_Rotate.h"
@interface EyeBallNode : DPI300Node<P_Colorable,PairNodes,P_Dragable,P_Zoom,P_Rotate,P_SyncDrag>
-(void)receiveReverseRotationNotification:(NSNotification*)sender;
@end
