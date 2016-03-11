//
//  NeckNode.h
//  face plus
//
//  Created by linxudong on 14/12/4.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "P_Rotate.h"
#import "P_Zoom.h"
@interface NeckNode : DPI300Node<P_Colorable,P_Dragable,P_Zoom,P_Rotate>

@end
