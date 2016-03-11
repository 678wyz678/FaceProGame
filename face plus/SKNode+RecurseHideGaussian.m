//
//  SKNode+RecurseHideGaussian.m
//  face plus
//
//  Created by linxudong on 15/2/13.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "SKNode+RecurseHideGaussian.h"
#import "FeatureLayer.h"
@implementation SKNode (RecurseHideGaussian)
-(void)hideGaussian{
    
    NSArray*children=self.children;
    if (children.count>0) {
        [children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SKNode* node=(SKNode*)obj;
            if ([node.name isEqualToString:gaussianBlurLayerName]) {
                [node setHidden:YES];
            }
            [node hideGaussian];
        }];
    }
}
@end
