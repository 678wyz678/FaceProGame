//
//  MyCollectionViewLayout.m
//  face plus
//
//  Created by linxudong on 15/2/13.
//  Copyright (c) 2015年 Willian. All rights reserved.
//

#import "MyCollectionViewLayout.h"

@implementation MyCollectionViewLayout
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *unfilteredPoses = [super layoutAttributesForElementsInRect:rect];
    id filteredPoses[unfilteredPoses.count];
    NSUInteger filteredPosesCount = 0;
    for (UICollectionViewLayoutAttributes *pose in unfilteredPoses) {
        if (CGRectIntersectsRect(rect, pose.frame)) {
            filteredPoses[filteredPosesCount++] = pose;
        }
    }
    return [NSArray arrayWithObjects:filteredPoses count:filteredPosesCount];
}


-(CGFloat)minimumInteritemSpacing{
    return 0.f;
}
-(CGFloat)minimumLineSpacing{
    return 0.f;
}
-(UIEdgeInsets)sectionInset{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(CGSize)headerReferenceSize{
    return CGSizeZero;
}
-(CGSize)footerReferenceSize{
    return CGSizeZero;
}
@end
