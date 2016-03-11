//
//  PackageArray.m
//  face plus
//
//  Created by linxudong on 1/12/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import "PackageArray.h"

@implementation PackageArray
-(instancetype)initWithPackageNum:(NSInteger)packageNum{
    if (self=[super init]) {
        self.packageNum=packageNum;
        _packageArray=[NSMutableArray new];
    }
    return self;
}

- (NSComparisonResult)compare:(PackageArray *)otherObject {
    return [[NSNumber numberWithInteger:_packageNum] compare:[NSNumber numberWithInteger:otherObject.packageNum]];
}
@end
