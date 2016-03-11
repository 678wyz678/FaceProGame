//
//  P_Crop.h
//  face plus
//
//  Created by linxudong on 12/14/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DPI300Node;
@protocol P_Crop <NSObject>
-(void)calculateBoundary:(DPI300Node*)parentNode;
@end
