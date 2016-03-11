//
//  AccessoryNode.h
//  face plus
//
//  Created by linxudong on 15/1/28.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_Rotate.h"
@interface AccessoryNode : DPI300Node<P_Colorable,P_Dragable,P_Order,P_Zoom,P_Rotate>

@end
