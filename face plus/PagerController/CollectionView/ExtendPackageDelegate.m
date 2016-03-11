//
//  ExtendPackageDelegate.m
//  face plus
//
//  Created by linxudong on 1/12/15.
//  Copyright (c) 2015 Willian. All rights reserved.


#import "ExtendPackageDelegate.h"
#import "ImportAllEntity.h"
#import "PackageArray.h"
#import "FeaturePackageArray.h"
#import "PackageIndexArray.h"
#import "ViewControllerSource.h"
static ExtendPackageDelegate* instance;
static BOOL isLoaded;
@implementation NSString (Contains)

- (BOOL)myContainsString:(NSString*)other {
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end

@interface ExtendPackageDelegate()
@end

@implementation ExtendPackageDelegate

+(instancetype)singleton{
    if (!instance) {
        instance=[[ExtendPackageDelegate alloc]init];
    }
    return instance;
}

-(instancetype)init{
    if (self=[super init]) {
        _mouthPackage=[NSMutableArray new];
        [self loadPackage];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPackage) name:@"Refresh_Package" object:nil];
    }
    return self;
}

-(void)refreshPackage{
    [self loadPackage];
    [self.viewControllerSource initPackageDictionary];
}

-(void)loadPackage{

    [FeaturePackageArray reset];
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9]+_" options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    
    //开始迭代
    NSString *bundleRoot = [[NSBundle mainBundle] bundlePath];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString* imageRoot=[bundleRoot stringByAppendingPathComponent:@"/PIndex"];
    
    //NSMutableArray *allFeatures = [[NSMutableArray alloc] init];
    
    // Enumerators are recursive
    NSDirectoryEnumerator *enumerator = [fm enumeratorAtPath:imageRoot] ;
    NSString *filePath;
    NSString *currentLocationPath=nil;
    PackageArray* tempArray=[[PackageArray alloc]initWithPackageNum:1];
    int loopTime=0;
    while ((filePath = [enumerator nextObject]) != nil){
        loopTime++;
        // If we have the right type of file, add it to the list
        // Make sure to prepend the directory path
        if([[filePath pathExtension] isEqualToString:@"png"]){
            //所属包名
            NSString*firstComponent=[filePath pathComponents][0];
            //文件全名
            NSString*fileName=[filePath lastPathComponent];
            //文件去前缀名
            NSString*fileNameWithOutPreExtension= [regex stringByReplacingMatchesInString:fileName options:0 range:NSMakeRange(0, [fileName length]) withTemplate:@""];
            NSString*fileRealPath=[NSString stringWithFormat:@"/PIndex/%@",filePath];
            NSString*shopIndexPath=[NSString stringWithFormat:@"/PShopIndex/%@",filePath];
            //不带文件名的路径
            NSString*locationPath=  [filePath stringByReplacingOccurrencesOfString:fileName withString:@""];
            //遇到新文件夹
            if (loopTime==1) {
                currentLocationPath=locationPath;
            }
            

            if (![locationPath isEqualToString:currentLocationPath]) {
                if ([currentLocationPath myContainsString:@"嘴"]) {
                    [[FeaturePackageArray singleton].mouthArray addObject:tempArray];
                }
                
                else  if ([currentLocationPath myContainsString:@"身体"]) {
                    [[FeaturePackageArray singleton].neckArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"帽子"]) {
                    [[FeaturePackageArray singleton].capArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"眼睛"]) {
                    [[FeaturePackageArray singleton].eyeArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"配件"]) {
                    [[FeaturePackageArray singleton].whelkArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"后发"]) {
                    [[FeaturePackageArray singleton].behindHairArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"头发"]) {
                    [[FeaturePackageArray singleton].hairArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"前发"]) {
                    [[FeaturePackageArray singleton].frontHairArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"大胡子"]) {
                    [[FeaturePackageArray singleton].whiskerArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"小胡子"]) {
                    [[FeaturePackageArray singleton].beardArray addObject:tempArray];
                }
                else   if ([currentLocationPath myContainsString:@"鼻子"]) {
                    [[FeaturePackageArray singleton].noseArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"眼镜"]) {
                    [[FeaturePackageArray singleton].glassArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"耳饰"]) {
                    [[FeaturePackageArray singleton].whelkArray addObject:tempArray];
                }
                else  if ([currentLocationPath myContainsString:@"眼珠"]) {
                    [[FeaturePackageArray singleton].eyeballArray addObject:tempArray];
                }

                
                
                currentLocationPath=locationPath;
                tempArray=[[PackageArray alloc]initWithPackageNum:1];
            }
            
            
            //查询package num
            
            if ([firstComponent isEqualToString:@"动物导出"]) {
                if (!isLoaded) {
                    [[PackageIndexArray singleton].animalIndexFiles addObject:shopIndexPath];
                }
                tempArray.packageNum=[[NSUserDefaults standardUserDefaults] integerForKey:@"package_animal_1"]<0?-1:1;
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"package_all"]<0) {
                    tempArray.packageNum=-1;
                }
            }
            else if ([firstComponent isEqualToString:@"摇滚套装"]) {
                if (!isLoaded) {
                    [[PackageIndexArray singleton].rockIndexFiles addObject:shopIndexPath];
                }
                tempArray.packageNum=[[NSUserDefaults standardUserDefaults] integerForKey:@"package_rock_1"]<0?-2:2;
                if ([[NSUserDefaults standardUserDefaults] integerForKey:@"package_all"]<0) {
                    tempArray.packageNum=-2;
                }
            }

                    else if ([firstComponent isEqualToString:@"僵尸套装"]) {
               if (!isLoaded) {
               [[PackageIndexArray singleton].zombieIndexFiles addObject:shopIndexPath];
               }
               tempArray.packageNum=[[NSUserDefaults standardUserDefaults] integerForKey:@"package_zombie_1"]<0?-3:3;
                        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"package_all"]<0) {
                            tempArray.packageNum=-3;
                        }
            }
            
                    else if ([firstComponent isEqualToString:@"未来套装"]) {
                        if (!isLoaded) {
                            [[PackageIndexArray singleton].futureIndexFiles addObject:shopIndexPath];
                        }
                        tempArray.packageNum=[[NSUserDefaults standardUserDefaults] integerForKey:@"package_future_1"]<0?-4:4;
                        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"package_all"]<0) {
                            tempArray.packageNum=-4;
                        }
             }
            

                   else if ([firstComponent isEqualToString:@"身体"]) {
               if (!isLoaded) {
                   [[PackageIndexArray singleton].bodyIndexFiles addObject:shopIndexPath];
               }
               tempArray.packageNum=[[NSUserDefaults standardUserDefaults] integerForKey:@"package_body_1"]<0?-5:5;
                       if ([[NSUserDefaults standardUserDefaults] integerForKey:@"package_all"]<0) {
                           tempArray.packageNum=-5;
                       }
           }
            
            
            [ExtendPackageDelegate detectFeatureAndAddToCache:fileNameWithOutPreExtension indexFilePath:fileRealPath imageFullName:fileName packageArray:tempArray];

        }
    }
    
    
    //最后一组未能在上面被识别
        if ([currentLocationPath myContainsString:@"嘴"]) {
            [[FeaturePackageArray singleton].mouthArray addObject:tempArray];
        }
        
        else  if ([currentLocationPath myContainsString:@"身体"]) {
            [[FeaturePackageArray singleton].neckArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"帽子"]) {
            [[FeaturePackageArray singleton].capArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"眼睛"]) {
            [[FeaturePackageArray singleton].eyeArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"配件"]) {
            [[FeaturePackageArray singleton].whelkArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"后发"]) {
            [[FeaturePackageArray singleton].behindHairArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"头发"]) {
            [[FeaturePackageArray singleton].hairArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"前发"]) {
            [[FeaturePackageArray singleton].frontHairArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"胡子"]) {
            [[FeaturePackageArray singleton].beardArray addObject:tempArray];
        }
        else   if ([currentLocationPath myContainsString:@"鼻子"]) {
            [[FeaturePackageArray singleton].noseArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"眼镜"]) {
            [[FeaturePackageArray singleton].glassArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"耳饰"]) {
            [[FeaturePackageArray singleton].whelkArray addObject:tempArray];
        }
        else  if ([currentLocationPath myContainsString:@"眼珠"]) {
            [[FeaturePackageArray singleton].eyeballArray addObject:tempArray];
        }
        
        
        
    

    
    
    //迭代结束
    isLoaded=YES;
    

    
}


+(void)detectFeatureAndAddToCache:(NSString*)featureName indexFilePath:(NSString*)indexFilePath imageFullName:(NSString*)fullName packageArray:(PackageArray*)packageArray{
    NSError *error = nil;
    NSRegularExpression *preRegex = [NSRegularExpression regularExpressionWithPattern:@"^[a-zA-Z0-9]+_" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *newSearchString = [preRegex firstMatchInString:fullName options:0 range:NSMakeRange(0, [fullName length])];
    NSString *preFix = [[fullName substringWithRange:newSearchString.range] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    
    
    //加载素材缓存单例
    //检测是否为脸文件 face_[num].png
    // NSString *facerRegex=@"^face_[0-9]+\\.";
    NSString *noseRegex=@"^nose_[0-9]+\\.";
    NSString *mouthRegex=@"^mouth_[0-9]+\\.";
    NSString *earRegex=@"^ear_[0-9]+\\.";
    NSString *eyeRegex=@"^eye_left_[0-9]+\\.";
    NSString *browRegex=@"^brow_left_[0-9]+\\.";
    // NSString *hairRegex=@"^hair_[0-9]+\\.";
    NSString *frontHairRegex=@"^front_hair_[0-9]+\\.";
    NSString *behindHairRegex=@"^behind_hair_[0-9]+\\.";
    
    NSString *eyeballRegex=@"^eyeball_[0-9]+\\.";
    
    //装饰品
    NSString *whelkRegex=@"^whelk_[0-9]+\\.";
    //眼镜
    NSString *glassRegex=@"^glass_[0-9]+\\.";
    NSString *singleGlassRegex=@"^glass_single_[0-9]+\\.";
    
    //  NSString *belowGlassRegex=@"^below_glass_[0-9]+\\.";
    
    
    //脖子
    NSString *neckRegex=@"^neck_[0-9]+\\.";
    //帽子
    NSString *capRegex=@"^cap_[0-9]+\\.";
    //三层帽子(带有背景)
    NSString *capWithBackgroundRegex=@"^cap_with_back_[0-9]+\\.";
    
    //睫毛
    NSString *eyelashRegex=@"^eyelash_left_[0-9]+\\.";
    //络腮
    NSString *whiskerRegex=@"^whisker_[0-9]+\\.";
    //小胡子
    NSString *beardRegex=@"^beard_[0-9]+\\.";
    //纹身
    NSString *tattooRegex=@"^tattoo_[0-9]+\\.";
    
    //NSString *girlHairRegex=@"^girl_front_hair_[0-9]+\\.";
    NSString *underEyeRegex=@"^under_eye_left_[0-9]+\\.";
    
    NSString *doubleEyeRegex=@"^eye_left_small_[0-9]+\\.";
    
    NSString *earDecorationRegex=@"^ear_deco_[0-9]+\\.";
    
    NSString* smallBeardRegex=@"^small_beard_[0-9]+\\.";
    NSString* BrowLikeSmallBeardRegex=@"^brow_like_small_beard_left_[0-9]+\\.";
    
    
    NSString*singleAccessoryRegex=@"^accessory_single_[0-9]+\\.";
    NSString*doubleAccessoryRegex=@"^accessory_double_[0-9]+\\.";
    NSString*leftRightAccessoryRegex=@"^accessory_left_[0-9]+\\.";
    NSString*singleAccessoryInFaceRegex=@"^accessory_in_face_single_[0-9]+\\.";
    NSString*doubleAccessoryInFaceRegex=@"^accessory_in_face_double_[0-9]+\\.";
    
    NSString*leftRightInFaceAccessoryRegex=@"^accessory_left_in_face_[0-9]+\\.";
    NSString *bodyRegex=@"^body_[0-9]+\\.";

    //    NSRegularExpression *faceReg=[[NSRegularExpression alloc]initWithPattern:facerRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *noseReg=[[NSRegularExpression alloc]initWithPattern:noseRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *mouthReg=[[NSRegularExpression alloc]initWithPattern:mouthRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *earReg=[[NSRegularExpression alloc]initWithPattern:earRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *eyeReg=[[NSRegularExpression alloc]initWithPattern:eyeRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *browReg=[[NSRegularExpression alloc]initWithPattern:browRegex options:NSRegularExpressionCaseInsensitive error:&error];
    //NSRegularExpression *hairReg=[[NSRegularExpression alloc]initWithPattern:hairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *frontHairReg=[[NSRegularExpression alloc]initWithPattern:frontHairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *behindHairReg=[[NSRegularExpression alloc]initWithPattern:behindHairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *eyeballReg=[[NSRegularExpression alloc]initWithPattern:eyeballRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    NSRegularExpression *whelkReg=[[NSRegularExpression alloc]initWithPattern:whelkRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *glassReg=[[NSRegularExpression alloc]initWithPattern:glassRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *singleGlassReg=[[NSRegularExpression alloc]initWithPattern:singleGlassRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *neckReg=[[NSRegularExpression alloc]initWithPattern:neckRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *capReg=[[NSRegularExpression alloc]initWithPattern:capRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *capBackReg=[[NSRegularExpression alloc]initWithPattern:capWithBackgroundRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    NSRegularExpression *eyelashReg=[[NSRegularExpression alloc]initWithPattern:eyelashRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *whiskerReg=[[NSRegularExpression alloc]initWithPattern:whiskerRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *beardReg=[[NSRegularExpression alloc]initWithPattern:beardRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *tattooReg=[[NSRegularExpression alloc]initWithPattern:tattooRegex options:NSRegularExpressionCaseInsensitive error:&error];
    //      NSRegularExpression *girlHairReg=[[NSRegularExpression alloc]initWithPattern:girlHairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *underEyeReg=[[NSRegularExpression alloc]initWithPattern:underEyeRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *doubleEyeReg=[[NSRegularExpression alloc]initWithPattern:doubleEyeRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    NSRegularExpression *singleAccessoryReg=[[NSRegularExpression alloc]initWithPattern:singleAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *singleAccessoryInfaceReg=[[NSRegularExpression alloc]initWithPattern:singleAccessoryInFaceRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *doubleAccessoryReg=[[NSRegularExpression alloc]initWithPattern:doubleAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *doubleAccessoryInfaceReg=[[NSRegularExpression alloc]initWithPattern:doubleAccessoryInFaceRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *leftRightAccessoryReg=[[NSRegularExpression alloc]initWithPattern:leftRightAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *leftRightInFaceAccessoryReg=[[NSRegularExpression alloc]initWithPattern:leftRightInFaceAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    NSRegularExpression *earDecorationReg=[[NSRegularExpression alloc]initWithPattern:earDecorationRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *smallBeardReg=[[NSRegularExpression alloc]initWithPattern:smallBeardRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *browLikeSmallBeardReg=[[NSRegularExpression alloc]initWithPattern:BrowLikeSmallBeardRegex options:NSRegularExpressionCaseInsensitive error:&error];
     NSRegularExpression *bodyReg=[[NSRegularExpression alloc]initWithPattern:bodyRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    //    //----------face------------
    //    if([faceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
    //
    //        FaceEntity* face=[[FaceEntity alloc]initWithShadow:fullName shadowFile:nil];
    //        [cacheArray.faceArray addObject:face];
    //    }
    //----------nose------------
    if([noseReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        
        NoseEntity* nose=[[NoseEntity alloc]initWithShadow:fullName shadowFile:nil];
        nose.indexFileName=indexFilePath;
        [packageArray.packageArray addObject:nose];
    }
    //----------mouth------------
    else if ([mouthReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[mouthReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString *mouthShadowFileName=[[NSString alloc]initWithFormat:@"%@_mouth_shadow_%@.png",preFix,[featureName substringWithRange:NSMakeRange(6,result.range.length-7)]];
        
        MouthEntity* mouth=[[MouthEntity alloc]initWithShadow:fullName shadowFile:mouthShadowFileName];
        mouth.indexFileName=indexFilePath;
        
        
        [packageArray.packageArray addObject:mouth];
    }
    //----------ear--------------
    else if ([earReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        EarEntity* ear=[[EarEntity alloc]initWithShadow:fullName shadowFile:nil];
        ear.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:ear];
    }
    //--------eye-----------------
    else if ([eyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[eyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString* eyeRightName=[[NSString alloc]initWithFormat:@"%@_eye_right_%@.png",preFix,[featureName substringWithRange:NSMakeRange(9,result.range.length-10)]];
        EyeEntity * eye=[[EyeEntity alloc]initWithPair:fullName pairFile:eyeRightName];
        eye.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:eye];
    }
    
    
    
    //--------double eye-----------------
    else if ([doubleEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[doubleEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString* num=[featureName substringWithRange:NSMakeRange(15,result.range.length-16)];
        
        NSString* selfEyeBig=[[NSString alloc]initWithFormat:@"%@_eye_left_big_%@.png",preFix,num];
        NSString* pairEyeBig=[[NSString alloc]initWithFormat:@"%@_eye_right_big_%@.png",preFix,num];
        NSString* pairEyeSmall=[[NSString alloc]initWithFormat:@"%@_eye_right_small_%@.png",preFix,num];
        DoubleEyeEntity * eye=[[DoubleEyeEntity alloc]initWithSelf:fullName selfBigFile:selfEyeBig pairSmallFile:pairEyeSmall pairBigFile:pairEyeBig];
        eye.indexFileName=indexFilePath;
        
        
        [packageArray.packageArray addObject:eye];
    }
    
    
    //--------eyeball-----------------
    else if ([eyeballReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[eyeballReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString* eyeballShadow=[[NSString alloc]initWithFormat:@"%@_eyeball_shadow_%@.png",preFix,[featureName substringWithRange:NSMakeRange(8,result.range.length-9)]];
        
        EyeballEntity * eyeball=[[EyeballEntity alloc]initWithShadow:fullName shadowFile:eyeballShadow];
        eyeball.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:eyeball];
    }
    
    //--------brow-----------------
    else if ([browReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[browReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString* num=[featureName substringWithRange:NSMakeRange(10,result.range.length-11)];
        NSString* browRightName=[[NSString alloc]initWithFormat:@"%@_brow_right_%@.png",preFix,num];
        
        
        BrowEntity * brow=[[BrowEntity alloc]initWithPair:fullName pairFile:browRightName ];
        brow.indexFileName=indexFilePath;
        
        
        [packageArray.packageArray addObject:brow];
    }
    //------hair------------------
    //    else if ([hairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    //    {
    //
    //        HairEntity* hair=[[HairEntity alloc]initWithShadow:fullName shadowFile:nil];
    //        hair.indexFileName=[NSString stringWithFormat:@"%@%@",@"/index/hair/",featureName];
    //
    //        [cacheArray.hairArray addObject:hair];
    //    }
    //------front hair------------------
    else if ([frontHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        
        FrontHairEntity* hair=[[FrontHairEntity alloc]initWithShadow:fullName shadowFile:nil];
        hair.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:hair];
    }
    //------behind hair------------------
    else if ([behindHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        
        BehindHairEntity* behindHair=[[BehindHairEntity alloc]initWithShadow:fullName shadowFile:nil];
        behindHair.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:behindHair];
    }
    //----------whelk--------------
    else if ([whelkReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        WhelkEntity* whelk=[[WhelkEntity alloc]init:fullName];
        whelk.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:whelk];
    }
    //----------睫毛eyelash--------------
    else if ([eyelashReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[eyelashReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        
        NSString* rightEyeLash=[[NSString alloc]initWithFormat:@"%@_eyelash_right_%@.png",preFix,[featureName substringWithRange:NSMakeRange(13,result.range.length-14)]];
        
        EyelashEntity* eyelash=[[EyelashEntity alloc]initWithPair:fullName pairFile:rightEyeLash];
        eyelash.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:eyelash];
    }
    
    //----------glass--------------
    else if ([glassReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[glassReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString*num=[featureName substringWithRange:NSMakeRange(6,result.range.length-7)];
        NSString* glassShadow=[[NSString alloc]initWithFormat:@"%@_glass_shadow_%@.png",preFix,num];
        
        GlassEntity* glass=[[GlassEntity alloc]initWithShadow:fullName shadowFile:glassShadow];
        glass.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:glass];
    }
    
    //----------single glass--------------
    else if ([singleGlassReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        
        SingleGlassEntity* glass=[[SingleGlassEntity alloc]init:fullName];
        glass.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:glass];
    }
    
    
    
    
    //----------neck--------------
    else if ([neckReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NeckEntity* neck=[[NeckEntity alloc]init:fullName];
        neck.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:neck];
    }
    //----------cap--------------
    else if ([capReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[capReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString* capShadow=[[NSString alloc]initWithFormat:@"%@_cap_shadow_%@.png",preFix,[featureName substringWithRange:NSMakeRange(4,result.range.length-5)]];
        
        CapEntity* glass=[[CapEntity alloc]initWithShadow:fullName shadowFile:capShadow];
        glass.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:glass];
    }
    //----------带背景cap--------------
    else if ([capBackReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[capBackReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString*num=[featureName substringWithRange:NSMakeRange(14,result.range.length-15)];
        NSString* capShadow=[[NSString alloc]initWithFormat:@"%@_cap_with_back_shadow_%@.png",preFix,num];
        NSString* capBackground=[[NSString alloc]initWithFormat:@"%@_cap_with_back_background_%@.png",preFix,num];
        
        CapWithBackgroundEntity* glass=[[CapWithBackgroundEntity alloc]initWithBackgroundFile:fullName shadowFile:capShadow backgroundFile:capBackground];
        glass.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:glass];
    }
    //----------whisker--------------
    else if ([whiskerReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        WhiskerEntity* whisker=[[WhiskerEntity alloc]init:fullName];
        whisker.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:whisker];
    }
    
    //----------beard--------------
    else if ([beardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        BeardEntity* beard=[[BeardEntity alloc]init:fullName];
        beard.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:beard];
    }
    //----------tattoo--------------
    else if ([tattooReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        TattooEntity* tattoo=[[TattooEntity alloc]init:fullName];
        tattoo.indexFileName=indexFilePath;
        [packageArray.packageArray addObject:tattoo];
    }
    //----------girlHair--------------
    //    else if ([girlHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
    //
    //        NSTextCheckingResult* result=(NSTextCheckingResult*)[[girlHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
    //        NSString* behindHair=[[NSString alloc]initWithFormat:@"girl_behind_hair_%@.png",[featureName substringWithRange:NSMakeRange(16,result.range.length-17)]];
    //
    //        GirlHairEntity* hair=[[GirlHairEntity alloc]initWithGirlBehindHair:featureName behindHair:behindHair];
    //        [cacheArray.hairArray addObject:hair];
    //    }
    //----------under-eye 眼影--------------
    else if ([underEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[underEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString* rightUnderEye=[[NSString alloc]initWithFormat:@"%@_under_eye_right_%@.png",preFix,[featureName substringWithRange:NSMakeRange(15,result.range.length-16)]];
        
        UnderEyeEntity* underEye=[[UnderEyeEntity alloc]initWithPair:fullName pairFile:rightUnderEye];
        underEye.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:underEye];
    }
    
    
    
    //----------耳饰--------------
    else if ([earDecorationReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[earDecorationReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString*num=[featureName substringWithRange:NSMakeRange(9,result.range.length-10)];
        NSString* earDecoShadow=[NSString stringWithFormat:@"%@_ear_deco_shadow_%@.png",preFix,num];
        
        EarDecorationEntity* entity=[[EarDecorationEntity alloc]initWithShadow:fullName shadowFile:earDecoShadow];
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    //----------小胡子（旋转）--------------
    else if ([browLikeSmallBeardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[browLikeSmallBeardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString*num=[featureName substringWithRange:NSMakeRange(27,result.range.length-28)];
        NSString* pairName=[NSString stringWithFormat:@"%@_brow_like_small_beard_right_%@.png",preFix,num];
        
        BrowLikeSmallBeardEntity* entity=[[BrowLikeSmallBeardEntity alloc]initWithPair:fullName pairFile:pairName];
        
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    //----------小胡子（不旋转）--------------
    else if ([smallBeardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        SmallBeardEntity* entity=[[SmallBeardEntity alloc]init:fullName];
        
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    
    //----------double Accessory--------------
    else if ([doubleAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[doubleAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString*num=[featureName substringWithRange:NSMakeRange(17,result.range.length-18)];
        NSString* shadow=[NSString stringWithFormat:@"%@_accessory_double_shadow_%@.png",preFix,num];
        
        DoubleAccessoryEntity* entity=[[DoubleAccessoryEntity alloc]initWithShadow:fullName shadowFile:shadow];
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    //----------double Accessory in face--------------
    else if ([doubleAccessoryInfaceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[doubleAccessoryInfaceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString*num=[featureName substringWithRange:NSMakeRange(25,result.range.length-26)];
        NSString* shadow=[NSString stringWithFormat:@"%@_accessory_in_face_double_shadow_%@.png",preFix,num];
        
        AccessoryInFaceDoubleEntity* entity=[[AccessoryInFaceDoubleEntity alloc]initWithShadow:fullName shadowFile:shadow];
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    //----------single Accessory--------------
    else if ([singleAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        
        
        SingleAccessoryEntity* entity=[[SingleAccessoryEntity alloc]init:fullName];
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    //----------single Accessory in face--------------
    else if ([singleAccessoryInfaceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        AccessoryInFaceSingleEntity* entity=[[AccessoryInFaceSingleEntity alloc]init:fullName];
        entity.indexFileName=indexFilePath;
        [packageArray.packageArray addObject:entity];
    }
    //----------leftRight-Accessory--------------
    else if ([leftRightAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[leftRightAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString*num=[featureName substringWithRange:NSMakeRange(15,result.range.length-16)];
        NSString* right=[NSString stringWithFormat:@"%@_accessory_right_%@.png",preFix,num];
        
        
        LeftRightAccessoryEntity* entity=[[LeftRightAccessoryEntity alloc]initWithPair:fullName pairFile:right];
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }
    //----------leftRight-Accessory inface--------------
    else if ([leftRightInFaceAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[leftRightInFaceAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString*num=[featureName substringWithRange:NSMakeRange(23,result.range.length-24)];
        NSString* right=[NSString stringWithFormat:@"%@_accessory_right_in_face_%@.png",preFix,num];
        
        
        AccessoryInFaceLeftRightEntity * entity=[[AccessoryInFaceLeftRightEntity alloc]initWithPair:fullName pairFile:right];
        entity.indexFileName=indexFilePath;
        
        [packageArray.packageArray addObject:entity];
    }

    
    //----------body--------------
    else if ([bodyReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[bodyReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString*num=[featureName substringWithRange:NSMakeRange(5,result.range.length-6)];
        
        NSString*shadow=[NSString stringWithFormat:@"%@_body_shadow_%@.png",preFix,num];
        BodyEntity* body=[[BodyEntity alloc]initWithShadow:fullName shadowFile:shadow];
        body.indexFileName=indexFilePath;
        [packageArray.packageArray addObject:body];
    }

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
