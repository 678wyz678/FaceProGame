//
//  CapNode.h
//  face plus
//
//  Created by linxudong on 12/7/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_Colorable.h"
#import "P_Rotate.h"
@interface CapNode : DPI300Node<P_Dragable,P_Zoom,P_Colorable,P_Rotate>

@end
