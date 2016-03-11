//
//  EyeRightlid.h
//  face plus
//
//  Created by linxudong on 15/2/12.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "PairNodes.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_Colorable.h"
#import "P_SyncRotate.h"
@interface EyeRightlid : DPI300Node<P_SyncRotate, PairNodes,P_Dragable,P_Zoom>

@end
