//
//  SoundDelegate.m
//  face plus
//
//  Created by linxudong on 12/30/14.
//  Copyright (c) 2014 Willian. All rights reserved.
//

#import "SoundDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
static NSMutableDictionary* normalSoundDictionary;
static NSMutableArray* elecArray;

static NSMutableArray* chordArray;
@implementation SoundDelegate
-(instancetype)init{
    if (self=[super init]) {

        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Constants" ofType:@"plist"]];
      NSDictionary*  soundKeyValueDictionary = [dictionary objectForKey:@"soundArray"];
        NSArray*  chordArrayFromPlist = [dictionary objectForKey:@"ChordArray"];

        normalSoundDictionary=[[NSMutableDictionary alloc]init];
        elecArray=[NSMutableArray new];
        chordArray=[NSMutableArray new];
        
        
        [soundKeyValueDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
            //normal包
            SystemSoundID soundID;
            NSURL* url=[NSURL fileURLWithPath:
                        [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"normal_%@",obj] ofType:@"wav"]];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
            NSNumber*numberIDOfSound=[NSNumber numberWithUnsignedInt:soundID];
            [normalSoundDictionary setValue:numberIDOfSound forKey:key];
        
            
        }];
        
        SystemSoundID soundID;
        NSURL* url=[NSURL fileURLWithPath:
                    [[NSBundle mainBundle] pathForResource:@"dianzi_sound_shake" ofType:@"wav"]];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        NSNumber*numberIDOfSound=[NSNumber numberWithUnsignedInt:soundID];
        [normalSoundDictionary setValue:numberIDOfSound forKey:@"dianzi_shake"];

        
        
        [chordArrayFromPlist enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            SystemSoundID soundID;
            NSURL* url=[NSURL fileURLWithPath:
                        [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"/chords/%@",obj] ofType:@"wav"]];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
            NSNumber*numberIDOfSound=[NSNumber numberWithUnsignedInt:soundID];
            [chordArray addObject:numberIDOfSound];
            
            
            //elec电子包
            url=[NSURL fileURLWithPath:
                 [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"/chords/dianzi/%@",obj] ofType:@"wav"]];
            
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
            [elecArray addObject:[NSNumber numberWithUnsignedInteger:soundID]];
        }];
        
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlaySoundDirective:) name:@"PLAY_SOUND" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivePlayChord:) name:@"PLAY_CHORD" object:nil];
        
    }
    return self;
}
-(void)receivePlayChord:(NSNotification*)sender{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"]) {
        NSInteger index=  ((NSNumber*)[sender.userInfo objectForKey:@"index"]).integerValue;
        //转换cell index为chord和弦index
        NSInteger chordIndex=index%12;
        [self playChord:chordIndex];
    }
}

-(void)receivePlaySoundDirective:(NSNotification*)sender{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"PlaySound"]) {
        NSString*soundKey=[sender.userInfo objectForKey:@"SOUND_KEY"];
        [self playSound:soundKey];
    }
    
  
}

-(void)playSound:(NSString*)soundKey{
    
    if ([soundKey isEqual:@"shake"]&&[[NSUserDefaults standardUserDefaults] boolForKey:@"ElecEffect"]) {
        AudioServicesPlaySystemSound(((NSNumber*)[normalSoundDictionary objectForKey:@"dianzi_shake"]).unsignedIntValue);
        return;
    }
        AudioServicesPlaySystemSound(((NSNumber*)[normalSoundDictionary objectForKey:soundKey]).unsignedIntValue);
    
   }
-(void)playChord:(NSInteger)index{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ElecEffect"]) {

    AudioServicesPlaySystemSound(((NSNumber*)([elecArray objectAtIndex:index])).unsignedIntValue);
}
    else{
        AudioServicesPlaySystemSound(((NSNumber*)([chordArray objectAtIndex:index])).unsignedIntValue);

    }
}

-(void)dealloc{
    [normalSoundDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        AudioServicesDisposeSystemSoundID(((NSNumber*)obj).unsignedIntValue);
    }];
    [elecArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        AudioServicesDisposeSystemSoundID(((NSNumber*)obj).unsignedIntValue);
    }];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
