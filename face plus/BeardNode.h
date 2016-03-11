//
//  BeardNode.h
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//
#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_Rotate.h"
@interface BeardNode:DPI300Node<P_Zoom,P_Dragable,P_Colorable,P_Rotate>
@end
