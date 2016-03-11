//
//  ColorPickerPanelViewController.h
//  face plus
//
//  Created by Willian on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPickerPanelViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;





@end
