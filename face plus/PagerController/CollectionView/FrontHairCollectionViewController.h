//
//  FrontBehindHairCollectionViewController.h
//  face plus
//
//  Created by linxudong on 3/14/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "MyCollectionViewController.h"

@interface FrontHairCollectionViewController : MyCollectionViewController
NSMutableSet* getSelectedIndexPathForFrontHair();


void setSelectedIndexPathForFrontHair(NSMutableSet*set);
void resetFrontHairArray();
@end
