//
//  BehindHairCollectionViewController.h
//  face plus
//
//  Created by linxudong on 3/14/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "MyCollectionViewController.h"

@interface BehindHairCollectionViewController : MyCollectionViewController
NSMutableSet* getSelectedIndexPathForBehindHair();


void setSelectedIndexPathForBehindHair(NSMutableSet*set);
void resetBehindHairArray();
@end
