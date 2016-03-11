//
//  P_MultipleNode.h
//  face plus
//
//  Created by linxudong on 14/12/1.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
//空头协议，只是用来辨别是否支持多个node同时存在于node树
@protocol P_MultipleNode <NSObject>
+(NSMutableArray*) multipleNodeStack;
@end
