//
//  GlassNode.h
//  face plus
//
//  Created by linxudong on 14/11/17.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Dragable.h"
#import "P_Colorable.h"
#import "P_Zoom.h"
#import "P_Rotate.h"
@interface GlassNode : DPI300Node<P_Dragable,P_Zoom,P_Colorable,P_Rotate>

@end
