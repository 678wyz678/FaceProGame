//
//  IconButton.h
//  face plus
//
//  Created by linxudong on 12/29/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IconButton : UIButton
@property (nonatomic,assign)NSUInteger index;
@property (nonatomic)NSNumber* indexT;

@property(nonatomic,assign)BOOL isSelected;


@property(nonatomic,assign)BOOL selectState;
@end
