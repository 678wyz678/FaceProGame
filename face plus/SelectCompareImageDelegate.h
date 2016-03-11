//
//  SelectCompareImageDelegate.h
//  face plus
//
//  Created by linxudong on 1/18/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SCNavigationController.h"
@class ViewController;
@interface SelectCompareImageDelegate : NSObject<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SCNavigationControllerDelegate>
@property (weak,nonatomic)ViewController*controller;

-(instancetype)initWithController:(ViewController*)controller;
@end
