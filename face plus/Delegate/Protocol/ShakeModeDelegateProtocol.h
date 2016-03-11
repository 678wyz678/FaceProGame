//
//  ShakeModeDelegateProtocol.h
//  face plus
//
//  Created by linxudong on 14/12/2.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ShakeModeDelegateProtocol <NSObject>
@property BOOL isInMode;
-(void)toggleMode;
//摇动设备
-(void)shakeTheDevice;
@end
