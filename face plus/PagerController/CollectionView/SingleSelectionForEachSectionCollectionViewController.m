//
//  SingleSelectionForEachSectionCollectionViewController.m
//  face plus
//
//  Created by linxudong on 15/2/4.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "SingleSelectionForEachSectionCollectionViewController.h"

@interface SingleSelectionForEachSectionCollectionViewController ()

@end

@implementation SingleSelectionForEachSectionCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.allowsMultipleSelection=YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    NSArray * selectedIndexPathArray = self.collectionView.indexPathsForSelectedItems;
    
    for (NSIndexPath * selectedIndexPath in selectedIndexPathArray) {
        if ((selectedIndexPath.section == indexPath.section) && (selectedIndexPath.row != indexPath.row)) {
            [self.collectionView deselectItemAtIndexPath:selectedIndexPath  animated:NO];
        }
    }
    
    [super collectionView:collectionView didSelectItemAtIndexPath:indexPath];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
