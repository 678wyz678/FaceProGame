//
//  ExtendPackageDelegate.h
//  face plus
//
//  Created by linxudong on 1/12/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ViewControllerSource;
@interface ExtendPackageDelegate : NSObject
@property NSMutableArray* mouthPackage;
@property (weak,nonatomic)ViewControllerSource* viewControllerSource;

+(instancetype)singleton;

@end
