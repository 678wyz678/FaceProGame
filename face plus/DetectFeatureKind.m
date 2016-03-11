//
//  DetectFeatureKind.m
//  face plus
//
//  Created by linxudong on 14/11/3.
//  Copyright (c) 2014年 Willian. All rights reserved.
//

#import "DetectFeatureKind.h"
#import "GlobalVariable.h"
#import "DefaultEntity.h"
@implementation DetectFeatureKind
+(void)detectFeatureAndAddToCache:(NSString*)featureName indexFilePath:(NSString*)indexFilePath{
    //加载素材缓存单例
    FeatureArray* cacheArray=[FeatureArray singleton];
    NSError *error=nil;
    //检测是否为脸文件 face_[num].png
    NSString *facerRegex=@"^face_[0-9]+\\.";
    NSString *noseRegex=@"^nose_[0-9]+\\.";
    NSString *mouthRegex=@"^mouth_[0-9]+\\.";
    NSString *earRegex=@"^ear_[0-9]+\\.";
   // NSString *eyeRegex=@"^eye_left_[0-9]+\\.";
   // NSString *browRegex=@"^brow_left_[0-9]+\\.";
   // NSString *hairRegex=@"^hair_[0-9]+\\.";
    NSString *frontHairRegex=@"^front_hair_[0-9]+\\.";
    NSString *behindHairRegex=@"^behind_hair_[0-9]+\\.";

    NSString *eyeballRegex=@"^eyeball_[0-9]+\\.";

    //装饰品
   // NSString *whelkRegex=@"^whelk_[0-9]+\\.";
    //眼镜
  //  NSString *glassRegex=@"^glass_[0-9]+\\.";
  //  NSString *singleGlassRegex=@"^glass_single_[0-9]+\\.";

  //  NSString *belowGlassRegex=@"^below_glass_[0-9]+\\.";

    
    //脖子
    NSString *neckRegex=@"^neck_[0-9]+\\.";
   //帽子
  //  NSString *capRegex=@"^cap_[0-9]+\\.";
    //三层帽子(带有背景)
 //   NSString *capWithBackgroundRegex=@"^cap_with_back_[0-9]+\\.";

    //睫毛
 //   NSString *eyelashRegex=@"^eyelash_left_[0-9]+\\.";
    //络腮
    NSString *whiskerRegex=@"^whisker_[0-9]+\\.";
    //小胡子
    NSString *beardRegex=@"^beard_[0-9]+\\.";
    //纹身
   // NSString *tattooRegex=@"^tattoo_[0-9]+\\.";
    
    NSString *girlHairRegex=@"^girl_front_hair_[0-9]+\\.";
    //NSString *underEyeRegex=@"^under_eye_left_[0-9]+\\.";

   // NSString *doubleEyeRegex=@"^eye_left_small_[0-9]+\\.";
    
   // NSString *earDecorationRegex=@"^ear_deco_[0-9]+\\.";
  
  //  NSString* smallBeardRegex=@"^small_beard_[0-9]+\\.";
   // NSString* BrowLikeSmallBeardRegex=@"^brow_like_small_beard_left_[0-9]+\\.";

 
    //NSString*singleAccessoryRegex=@"^accessory_single_[0-9]+\\.";
    //NSString*doubleAccessoryRegex=@"^accessory_double_[0-9]+\\.";
    //NSString*leftRightAccessoryRegex=@"^accessory_left_[0-9]+\\.";
    //NSString*singleAccessoryInFaceRegex=@"^accessory_in_face_single_[0-9]+\\.";
   // NSString*doubleAccessoryInFaceRegex=@"^accessory_in_face_double_[0-9]+\\.";

  //  NSString*leftRightInFaceAccessoryRegex=@"^accessory_left_in_face_[0-9]+\\.";
    NSString *bodyRegex=@"^body_[0-9]+\\.";

    
    
    NSRegularExpression *faceReg=[[NSRegularExpression alloc]initWithPattern:facerRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *noseReg=[[NSRegularExpression alloc]initWithPattern:noseRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *mouthReg=[[NSRegularExpression alloc]initWithPattern:mouthRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *earReg=[[NSRegularExpression alloc]initWithPattern:earRegex options:NSRegularExpressionCaseInsensitive error:&error];
   // NSRegularExpression *eyeReg=[[NSRegularExpression alloc]initWithPattern:eyeRegex options:NSRegularExpressionCaseInsensitive error:&error];
   // NSRegularExpression *browReg=[[NSRegularExpression alloc]initWithPattern:browRegex options:NSRegularExpressionCaseInsensitive error:&error];
    //NSRegularExpression *hairReg=[[NSRegularExpression alloc]initWithPattern:hairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *frontHairReg=[[NSRegularExpression alloc]initWithPattern:frontHairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *behindHairReg=[[NSRegularExpression alloc]initWithPattern:behindHairRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *eyeballReg=[[NSRegularExpression alloc]initWithPattern:eyeballRegex options:NSRegularExpressionCaseInsensitive error:&error];

    
    // NSRegularExpression *whelkReg=[[NSRegularExpression alloc]initWithPattern:whelkRegex options:NSRegularExpressionCaseInsensitive error:&error];
    // NSRegularExpression *glassReg=[[NSRegularExpression alloc]initWithPattern:glassRegex options:NSRegularExpressionCaseInsensitive error:&error];
   // NSRegularExpression *singleGlassReg=[[NSRegularExpression alloc]initWithPattern:singleGlassRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *neckReg=[[NSRegularExpression alloc]initWithPattern:neckRegex options:NSRegularExpressionCaseInsensitive error:&error];
     // NSRegularExpression *capReg=[[NSRegularExpression alloc]initWithPattern:capRegex options:NSRegularExpressionCaseInsensitive error:&error];
  //  NSRegularExpression *capBackReg=[[NSRegularExpression alloc]initWithPattern:capWithBackgroundRegex options:NSRegularExpressionCaseInsensitive error:&error];

    
   // NSRegularExpression *eyelashReg=[[NSRegularExpression alloc]initWithPattern:eyelashRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *whiskerReg=[[NSRegularExpression alloc]initWithPattern:whiskerRegex options:NSRegularExpressionCaseInsensitive error:&error];
    NSRegularExpression *beardReg=[[NSRegularExpression alloc]initWithPattern:beardRegex options:NSRegularExpressionCaseInsensitive error:&error];
    // NSRegularExpression *tattooReg=[[NSRegularExpression alloc]initWithPattern:tattooRegex options:NSRegularExpressionCaseInsensitive error:&error];
      NSRegularExpression *girlHairReg=[[NSRegularExpression alloc]initWithPattern:girlHairRegex options:NSRegularExpressionCaseInsensitive error:&error];
//     NSRegularExpression *underEyeReg=[[NSRegularExpression alloc]initWithPattern:underEyeRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    
//      NSRegularExpression *doubleEyeReg=[[NSRegularExpression alloc]initWithPattern:doubleEyeRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    
//    
//    NSRegularExpression *singleAccessoryReg=[[NSRegularExpression alloc]initWithPattern:singleAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    NSRegularExpression *singleAccessoryInfaceReg=[[NSRegularExpression alloc]initWithPattern:singleAccessoryInFaceRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    NSRegularExpression *doubleAccessoryReg=[[NSRegularExpression alloc]initWithPattern:doubleAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    NSRegularExpression *doubleAccessoryInfaceReg=[[NSRegularExpression alloc]initWithPattern:doubleAccessoryInFaceRegex options:NSRegularExpressionCaseInsensitive error:&error];
//
//    NSRegularExpression *leftRightAccessoryReg=[[NSRegularExpression alloc]initWithPattern:leftRightAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    
//    NSRegularExpression *leftRightInFaceAccessoryReg=[[NSRegularExpression alloc]initWithPattern:leftRightInFaceAccessoryRegex options:NSRegularExpressionCaseInsensitive error:&error];
//

   // NSRegularExpression *earDecorationReg=[[NSRegularExpression alloc]initWithPattern:earDecorationRegex options:NSRegularExpressionCaseInsensitive error:&error];

  //  NSRegularExpression *smallBeardReg=[[NSRegularExpression alloc]initWithPattern:smallBeardRegex options:NSRegularExpressionCaseInsensitive error:&error];
//    NSRegularExpression *browLikeSmallBeardReg=[[NSRegularExpression alloc]initWithPattern:BrowLikeSmallBeardRegex options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSRegularExpression *bodyReg=[[NSRegularExpression alloc]initWithPattern:bodyRegex options:NSRegularExpressionCaseInsensitive error:&error];

    //----------face------------
    if([faceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        FaceEntity* face=[[FaceEntity alloc]initWithShadow:selfFile shadowFile:nil];
        face.updatedForFreeIndexFileName=indexFilePath;
        [cacheArray.faceArray addObject:face];
    }
    //----------nose------------
     if([noseReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
         NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        
        NoseEntity* nose=[[NoseEntity alloc]initWithShadow:selfFile shadowFile:nil];
         nose.updatedForFreeIndexFileName=indexFilePath;
         
        [cacheArray.noseArray addObject:nose];
    }
    //----------mouth------------
    else if ([mouthReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[mouthReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        NSString *mouthShadowFileName=[[NSString alloc]initWithFormat:@"mouth_shadow_%@.png",[featureName substringWithRange:NSMakeRange(6,result.range.length-7)]];

        MouthEntity* mouth=[[MouthEntity alloc]initWithShadow:selfFile shadowFile:[selfFile stringByReplacingOccurrencesOfString:featureName withString:mouthShadowFileName]];
        mouth.updatedForFreeIndexFileName=indexFilePath;
        
        [cacheArray.mouthArray addObject:mouth];
    }
    //----------ear--------------
    else if ([earReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        EarEntity* ear=[[EarEntity alloc]initWithShadow:selfFile shadowFile:nil];
        ear.updatedForFreeIndexFileName=indexFilePath;
       
        [cacheArray.earArray addObject:ear];
    }
//    //--------eye-----------------
//    else if ([eyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
//    {
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[eyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString* eyeRightName=[[NSString alloc]initWithFormat:@"eye_right_%@.png",[featureName substringWithRange:NSMakeRange(9,result.range.length-10)]];
//        EyeEntity * eye=[[EyeEntity alloc]initWithPair:featureName pairFile:eyeRightName];
//        eye.indexFileName=indexFilePath;
//
//        [cacheArray.eyeArray addObject:eye];
//    }
    
    
    
//    //--------double eye-----------------
//    else if ([doubleEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
//    {
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[doubleEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString* num=[featureName substringWithRange:NSMakeRange(15,result.range.length-16)];
//        
//        NSString* selfEyeBig=[[NSString alloc]initWithFormat:@"eye_left_big_%@.png",num];
//        NSString* pairEyeBig=[[NSString alloc]initWithFormat:@"eye_right_big_%@.png",num];
//        NSString* pairEyeSmall=[[NSString alloc]initWithFormat:@"eye_right_small_%@.png",num];
//
//        DoubleEyeEntity * eye=[[DoubleEyeEntity alloc]initWithSelf:featureName selfBigFile:selfEyeBig pairSmallFile:pairEyeSmall pairBigFile:pairEyeBig];
//        eye.indexFileName=indexFilePath;
//        if ([featureName isEqualToString:@"eye_left_small_33.png"]) {
//            [DefaultEntity singleton].eyeEntity=eye;
//        }
//        [cacheArray.eyeArray addObject:eye];
//    }
    
    
//    //--------eyeball-----------------
    else if ([eyeballReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {
        NSTextCheckingResult* result=(NSTextCheckingResult*)[[eyeballReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
       NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];
        
        NSString* eyeballShadow=[[NSString alloc]initWithFormat:@"eyeball_shadow_%@.png",[featureName substringWithRange:NSMakeRange(8,result.range.length-9)]];
      
        EyeballEntity * eyeball=[[EyeballEntity alloc]initWithShadow:selfFile shadowFile:[selfFile stringByReplacingOccurrencesOfString:featureName withString:eyeballShadow]];
        eyeball.updatedForFreeIndexFileName=indexFilePath;

        [cacheArray.eyeballArray addObject:eyeball];
    }
//
////--------brow-----------------
//else if ([browReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
//{
//    NSTextCheckingResult* result=(NSTextCheckingResult*)[[browReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//    NSString* num=[featureName substringWithRange:NSMakeRange(10,result.range.length-11)];
//    NSString* browRightName=[[NSString alloc]initWithFormat:@"brow_right_%@.png",num];
//
//
//    BrowEntity * brow=[[BrowEntity alloc]initWithPair:featureName pairFile:browRightName ];
//    brow.indexFileName=indexFilePath;
//
//    if ([num isEqualToString:@"3"]) {
//        [DefaultEntity singleton].browEntity=brow;
//    }
//    [cacheArray.browArray addObject:brow];
//}
   
    //------front hair------------------
    else if ([frontHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {

        FrontHairEntity* behindHair=[[FrontHairEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"]  shadowFile:nil];
        behindHair.updatedForFreeIndexFileName=indexFilePath;

        [cacheArray.frontHairArray addObject:behindHair];
    }
    //------behind hair------------------
    else if ([behindHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count)
    {

        BehindHairEntity* behindHair=[[BehindHairEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"]  shadowFile:nil];
        behindHair.updatedForFreeIndexFileName=indexFilePath ;

        [cacheArray.behindHairArray addObject:behindHair];
    }
////    //----------whelk--------------
////    else if ([whelkReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
////        WhelkEntity* whelk=[[WhelkEntity alloc]init:featureName];
////        whelk.indexFileName=indexFilePath;
////
////        [cacheArray.whelkArray addObject:whelk];
////    }
////    //----------睫毛eyelash--------------
////    else if ([eyelashReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
////         NSTextCheckingResult* result=(NSTextCheckingResult*)[[eyelashReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
////        
////        
////         NSString* rightEyeLash=[[NSString alloc]initWithFormat:@"eyelash_right_%@.png",[featureName substringWithRange:NSMakeRange(13,result.range.length-14)]];
////        
////        EyelashEntity* eyelash=[[EyelashEntity alloc]initWithPair:featureName pairFile:rightEyeLash];
////        eyelash.indexFileName=indexFilePath;
////
////        [cacheArray.whelkArray addObject:eyelash];
////    }
////    
//    //----------glass--------------
//    else if ([glassReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//  NSTextCheckingResult* result=(NSTextCheckingResult*)[[glassReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        
//        NSString*num=[featureName substringWithRange:NSMakeRange(6,result.range.length-7)];
//  NSString* glassShadow=[[NSString alloc]initWithFormat:@"glass_shadow_%@.png",num];
//        
//        GlassEntity* glass=[[GlassEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone.png"] shadowFile:glassShadow];
//        glass.indexFileName=indexFilePath;
//
//        [cacheArray.glassArray addObject:glass];
//    }
    
    //----------single glass--------------
//    else if ([singleGlassReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//               
//        SingleGlassEntity* glass=[[SingleGlassEntity alloc]init:featureName];
//        glass.indexFileName=indexFilePath;
//
//        [cacheArray.glassArray addObject:glass];
//    }
//    
   

    
    //----------neck--------------
    else if ([neckReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        NeckEntity* neck=[[NeckEntity alloc]init:selfFile];
        neck.updatedForFreeIndexFileName=indexFilePath;
       
        [cacheArray.neckArray addObject:neck];
    }
//    //----------cap--------------
//    else if ([capReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[capReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString* capShadow=[[NSString alloc]initWithFormat:@"cap_shadow_%@.png",[featureName substringWithRange:NSMakeRange(4,result.range.length-5)]];
//
//        CapEntity* glass=[[CapEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone.png"] shadowFile:capShadow];
//        glass.indexFileName=indexFilePath;
//
//        [cacheArray.capArray addObject:glass];
//    }
//    //----------带背景cap--------------
//    else if ([capBackReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[capBackReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString*num=[featureName substringWithRange:NSMakeRange(14,result.range.length-15)];
//        NSString* capShadow=[[NSString alloc]initWithFormat:@"cap_with_back_shadow_%@.png",num];
//        NSString* capBackground=[[NSString alloc]initWithFormat:@"cap_with_back_background_%@.png",num];
//
//        CapWithBackgroundEntity* glass=[[CapWithBackgroundEntity alloc]initWithBackgroundFile:featureName shadowFile:capShadow backgroundFile:capBackground];
//        glass.indexFileName=indexFilePath;
//
//        [cacheArray.capArray addObject:glass];
    //}
    //----------whisker--------------
    else if ([whiskerReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        WhiskerEntity* whisker=[[WhiskerEntity alloc]init:selfFile];
        whisker.updatedForFreeIndexFileName=indexFilePath;

        [cacheArray.beardArray addObject:whisker];
    }
    
    //----------beard--------------
    else if ([beardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        BeardEntity* beard=[[BeardEntity alloc]init:selfFile];
        beard.updatedForFreeIndexFileName=indexFilePath;

        [cacheArray.beardArray addObject:beard];
    }
//    //----------tattoo--------------
//    else if ([tattooReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        TattooEntity* tattoo=[[TattooEntity alloc]init:featureName];
//        tattoo.indexFileName=indexFilePath;
//        [cacheArray.whelkArray addObject:tattoo];
//    }
    //----------girlHair--------------
    else if ([girlHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        NSTextCheckingResult* result=(NSTextCheckingResult*)[[girlHairReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        NSString* behindHair=[[NSString alloc]initWithFormat:@"girl_behind_hair_%@.png",[featureName substringWithRange:NSMakeRange(16,result.range.length-17)]];

        GirlHairEntity* hair=[[GirlHairEntity alloc]initWithGirlBehindHair:selfFile behindHair:[indexFilePath stringByReplacingOccurrencesOfString:featureName withString:behindHair]];
        hair.updatedForFreeIndexFileName=indexFilePath;
        [cacheArray.hairArray addObject:hair];
    }
//    //----------under-eye 眼影--------------
//    else if ([underEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//          NSTextCheckingResult* result=(NSTextCheckingResult*)[[underEyeReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString* rightUnderEye=[[NSString alloc]initWithFormat:@"under_eye_right_%@.png",[featureName substringWithRange:NSMakeRange(15,result.range.length-16)]];
//        
//        UnderEyeEntity* underEye=[[UnderEyeEntity alloc]initWithPair:featureName pairFile:rightUnderEye];
//        underEye.indexFileName=indexFilePath;
//
//        [cacheArray.whelkArray addObject:underEye];
//    }
//    
//    
//
//    
// 
//    
//    //----------耳饰--------------
//    else if ([earDecorationReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[earDecorationReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        
//        NSString*num=[featureName substringWithRange:NSMakeRange(9,result.range.length-10)];
//        NSString* earDecoShadow=[NSString stringWithFormat:@"ear_deco_shadow_%@.png",num];
//        
//        EarDecorationEntity* entity=[[EarDecorationEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone.png"] shadowFile:earDecoShadow];
//
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.whelkArray addObject:entity];
//    }
//   // ----------小胡子（旋转）--------------
//    else if ([browLikeSmallBeardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[browLikeSmallBeardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        
//        NSString*num=[featureName substringWithRange:NSMakeRange(27,result.range.length-28)];
//        NSString* pairName=[NSString stringWithFormat:@"brow_like_small_beard_right_%@.png",num];
//        
//        BrowLikeSmallBeardEntity* entity=[[BrowLikeSmallBeardEntity alloc]initWithPair:featureName pairFile:pairName];
//        
//        entity.indexFileName=indexFilePath;
//        [cacheArray.beardArray addObject:entity];
//    }
//    //----------小胡子（不旋转）--------------
//    else if ([smallBeardReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//               SmallBeardEntity* entity=[[SmallBeardEntity alloc]init:featureName];
//        
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.beardArray addObject:entity];
//    }
//    
//    //----------double Accessory--------------
//    else if ([doubleAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[doubleAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString*num=[featureName substringWithRange:NSMakeRange(17,result.range.length-18)];
//        NSString* shadow=[NSString stringWithFormat:@"accessory_double_shadow_%@.png",num];
//        
//        DoubleAccessoryEntity* entity=[[DoubleAccessoryEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone.png"] shadowFile:shadow];
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.whelkArray addObject:entity];
//    }
//    //----------double Accessory in face--------------
//    else if ([doubleAccessoryInfaceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[doubleAccessoryInfaceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString*num=[featureName substringWithRange:NSMakeRange(25,result.range.length-26)];
//        NSString* shadow=[NSString stringWithFormat:@"accessory_in_face_double_shadow_%@.png",num];
//        
//        AccessoryInFaceDoubleEntity* entity=[[AccessoryInFaceDoubleEntity alloc]initWithShadow:[indexFilePath stringByReplacingOccurrencesOfString:@".png" withString:@"@2x~iphone.png"] shadowFile:shadow];
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.whelkArray addObject:entity];
//    }
//    //----------single Accessory--------------
//    else if ([singleAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        
//        
//        
//        SingleAccessoryEntity* entity=[[SingleAccessoryEntity alloc]init:featureName];
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.whelkArray addObject:entity];
//    }
//    //----------single Accessory in face--------------
//    else if ([singleAccessoryInfaceReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        AccessoryInFaceSingleEntity* entity=[[AccessoryInFaceSingleEntity alloc]init:featureName];
//        entity.indexFileName=indexFilePath;
//        [cacheArray.whelkArray addObject:entity];
//    }
//    //----------leftRight-Accessory--------------
//    else if ([leftRightAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[leftRightAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString*num=[featureName substringWithRange:NSMakeRange(15,result.range.length-16)];
//        NSString* right=[NSString stringWithFormat:@"accessory_right_%@.png",num];
//        
//        
//        LeftRightAccessoryEntity* entity=[[LeftRightAccessoryEntity alloc]initWithPair:featureName pairFile:right];
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.whelkArray addObject:entity];
//    }
//    //----------leftRight-Accessory inface--------------
//    else if ([leftRightInFaceAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
//        NSTextCheckingResult* result=(NSTextCheckingResult*)[[leftRightInFaceAccessoryReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
//        NSString*num=[featureName substringWithRange:NSMakeRange(23,result.range.length-24)];
//        NSString* right=[NSString stringWithFormat:@"accessory_right_in_face_%@.png",num];
//        
//        
//        AccessoryInFaceLeftRightEntity * entity=[[AccessoryInFaceLeftRightEntity alloc]initWithPair:featureName pairFile:right];
//        entity.indexFileName=indexFilePath;
//        
//        [cacheArray.whelkArray addObject:entity];
//    }
//    
//    //----------body--------------
    else if ([bodyReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)].count){
        NSString*selfFile= [indexFilePath stringByReplacingOccurrencesOfString:@"updatedIndexImages" withString:@"updatedImages"];

        NSTextCheckingResult* result=(NSTextCheckingResult*)[[bodyReg matchesInString:featureName options:0 range:NSMakeRange(0, featureName.length)] objectAtIndex:0];
        
        NSString*num=[featureName substringWithRange:NSMakeRange(5,result.range.length-6)];
        
        NSString*shadow=[NSString stringWithFormat:@"body_shadow_%@.png",num];
        BodyEntity* body=[[BodyEntity alloc]initWithShadow:selfFile shadowFile:[indexFilePath stringByReplacingOccurrencesOfString:featureName withString:shadow]];
        body.updatedForFreeIndexFileName=indexFilePath;

        [cacheArray.neckArray addObject:body];
    }
}





@end
