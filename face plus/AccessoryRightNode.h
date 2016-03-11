//
//  BlushNode.h
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "PairNodes.h"
#import "P_SyncRotate.h"
#import "P_Zoom.h"
@interface AccessoryRightNode : DPI300Node<P_Dragable,P_Zoom,PairNodes,P_SyncRotate>

@end
