//
//  P_SyncRotate.h
//  face plus
//
//  Created by linxudong on 1/1/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol P_SyncRotate <NSObject>
@property CGFloat curAngle;
-(void)syncRotate:(NSNumber*)angle;
@end
