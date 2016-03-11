//
//  ColorPickerPanelViewController.m
//  face plus
//
//  Created by Willian on 14/11/20.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "ColorPickerPanelViewController.h"
#import "UIColor+Library.h"
#import "ColorPicker.h"
#import <pop/POP.h>

@interface ColorPickerPanelViewController ()

@end

@implementation ColorPickerPanelViewController

NSString *cellIdentifier = @"color";
int colorCount = 19;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    //UINib *cellNib = [UINib nibWithNibName:@"ColorPickerPanelViewController" bundle:nil];
    //[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:cellIdentifier];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Collection View
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.layer.borderWidth = 0.f;
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    UIColor *color = cell.backgroundColor;
    id<ColorPickerDelegate> delegate = [[ColorPicker sharedInstance] delegate];
    if ([delegate conformsToProtocol:@protocol(ColorPickerDelegate)] &&
        [delegate respondsToSelector:@selector(shouldChangeColorTo:)]) {
        return [delegate shouldChangeColorTo:color];
    }
    return NO;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    POPSpringAnimation *upAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    upAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    upAnimation.springBounciness = 20;
    POPBasicAnimation *downAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    downAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(.8f, .8f)];
    downAnimation.duration = 0.1;
    [downAnimation setCompletionBlock:^(POPAnimation *a, BOOL b) {
        [cell.viewForBaselineLayout.layer pop_addAnimation:upAnimation forKey:@"color-picker.cell.up"];
    }];
    [cell.viewForBaselineLayout.layer pop_addAnimation:downAnimation forKey:@"color-picker.cell.down"];


    UIColor *color = cell.backgroundColor;
    [cell.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    cell.layer.borderWidth = 2.f;
    [ColorPicker didChangeColorTo:color];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return colorCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(cell == nil){
        cell = [[UICollectionViewCell alloc] init];
    }
    [cell.layer setCornerRadius:6.f];
    cell.backgroundColor = [ASCFlatUIColor colorWithFlatUIColorType:indexPath.row];
    return cell;
}
#pragma mark Events



@end
