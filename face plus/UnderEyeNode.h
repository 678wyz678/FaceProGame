//
//  UnderEyeNode.h
//  face plus
//
//  Created by linxudong on 12/18/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_SyncRotate.h"
#import "P_SyncDrag.h"
@interface UnderEyeNode : DPI300Node<P_Colorable,P_Dragable,P_Zoom,P_SyncDrag,P_SyncRotate>

@end
