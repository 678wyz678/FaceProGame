//
//  EarDecorationNode.h
//  face plus
//
//  Created by linxudong on 1/16/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "P_Rotate.h"
#import "P_Zoom.h"
@interface EarDecorationNode : DPI300Node<P_Colorable,P_Dragable,P_Order,P_Zoom,P_Rotate>
@end
