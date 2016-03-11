//
//  face_node.h
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "DPI300Node.h"
#import "P_Colorable.h"
@interface FaceNode : DPI300Node<P_Colorable>
-(void)centerPosition;
-(void)correctPositionForScaleSlider:(NSNumber*)scaleSliderValue;
@end
