//
//  PackageArray.h
//  face plus
//
//  Created by linxudong on 1/12/15.
//  Copyright (c) 2015 Willian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageArray : NSObject
@property (assign,nonatomic) NSInteger packageNum;
@property (nonatomic)NSMutableArray* packageArray;
-(instancetype)initWithPackageNum:(NSInteger)packageNum;


- (NSComparisonResult)compare:(PackageArray *)otherObject ;
@end
