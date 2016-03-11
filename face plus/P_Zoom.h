//
//  P_Zoom.h
//  face plus
//
//  Created by linxudong on 14/11/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol P_Zoom <NSObject>
@property CGFloat curScaleFactor;
-(void)zoom:(NSNumber*)scaleFactor;
@end
