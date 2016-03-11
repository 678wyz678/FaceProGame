//
//  EyeballNode.h
//  face plus
//
//  Created by linxudong on 14/11/13.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DPI300Node.h"
#import "P_Crop.h"

@interface EyeballCropNode : SKCropNode<P_Crop>
-(void)calculateBoundaryWithTimer:(NSTimer*)timer;
-(instancetype) initWithEyeballName:(NSString*)eyeballName textureOfParent:(DPI300Node*)parentNode;
@end
