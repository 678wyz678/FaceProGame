//
//  SmallBeard.h
//  face plus
//
//  Created by linxudong on 15/1/26.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "DPI300Node.h"

#import "DPI300Node.h"
#import "P_Colorable.h"
#import "P_Dragable.h"
#import "P_Zoom.h"
#import "P_Rotate.h"
@interface SmallBeard : DPI300Node<P_Zoom,P_Dragable,P_Colorable,P_Rotate>
@end