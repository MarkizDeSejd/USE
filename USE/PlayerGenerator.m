//
//  PlayerGenerator.m
//  USE
//
//  Created by jakub on 09/01/2014.
//  Copyright (c) 2014 jakub. All rights reserved.
//

#import "PlayerAge.h"
#import "PlayerGenerator.h"
#import "PlayerSkill.h"


float GLOBAL_SPECIALITY_CHANCE = 0.1f;
NSInteger YOUTH_STARTING_AGE = 15;
u_int32_t CURRENT_TO_POTENTIAL_DIFF_MAX = 30;

static NSArray* outfielderSkills = nil;
static NSArray* goalkeeperSkills = nil;
static NSArray* allSkillsArray = nil;

static NSDictionary* rootDict;
static NSArray* GKArray;
static NSArray* CBArray;
static NSArray* SBArray;
static NSArray* OSBArray;
static NSArray* DMArray;
static NSArray* MArray;
static NSArray* OMArray;
static NSArray* FWArray;
static NSDictionary* namesDict;

NSRange rangeFromString(NSString* str) {
    NSRange r;
    NSArray* arr = [str componentsSeparatedByString:@"-"];
    r.location = [arr[0] integerValue];
    r.length = [arr[1] integerValue];
    return r;
}

NSUInteger randomUnsignedInRange(NSRange r) {
    unsigned diff = (unsigned)r.length - (unsigned)r.location;
    return arc4random_uniform(diff) + r.location;
}

@implementation PlayerGenerator

+ (Player*)generatePlayerWithQuality:(NSInteger)quality {
    return [self generatePlayerWithQuality:quality
                                  position:PlayerPositionRandom
                             specialChance:GLOBAL_SPECIALITY_CHANCE];
}

+ (Player*)generatePlayerWithQuality:(NSInteger)quality position:(DesiredPosition)pos {
    return [self generatePlayerWithQuality:quality
                                  position:pos
                             specialChance:GLOBAL_SPECIALITY_CHANCE];
}

+ (NSString*)positionToString:(DesiredPosition)pos {
    NSString* ret;
    switch (pos) {
        case PlayerPositionGK:
            ret = @"GK";
            break;
        case PlayerPositionCB:
            ret = @"CB";
            break;
        case PlayerPositionSB:
            ret = @"SB";
            break;
        case PlayerPositionOSB:
            ret = @"OSB";
            break;
        case PlayerPositionDM:
            ret = @"DM";
            break;
        case PlayerPositionM:
            ret = @"M";
            break;
        case PlayerPositionOM:
            ret = @"OM";
            break;
        case PlayerPositionFW:
            ret = @"FW";
            break;
        default:
            NSLog(@"ERROR: unknown position: %d", pos);
            break;
    }
    return ret;
}

+ (Player*)generatePlayerWithQuality:(NSInteger)quality
                            position:(DesiredPosition)position
                       specialChance:(float)specialChance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self initArrays];
    });
    
    NSArray* limitsArray;
    NSArray* allLimits = [rootDict allKeys];
    NSString* chosenPosition;
    if (position == PlayerPositionRandom) {
        chosenPosition = allLimits[arc4random_uniform([allLimits count])];
        limitsArray = rootDict[chosenPosition];
    } else {
        // stay random for now
        chosenPosition = [self positionToString:position];
        limitsArray = rootDict[chosenPosition];
    }
    
    NSDictionary* qualityDict = limitsArray[quality];
    
    // the actual randomization takes place here
    
    // choose name
    NSArray* allNames = namesDict[@"Names"];
    NSArray* allSurnames = namesDict[@"Surnames"];
    NSString* name = allNames[arc4random_uniform([allNames count])];
    NSString* surname = allSurnames[arc4random_uniform([allSurnames count])];
    
    Player* p = [[Player alloc] init];
    [p setFirstName:name];
    [p setLastName:surname];
    [p setType:chosenPosition];
    
    // choose age
    NSInteger additionalMonths = arc4random_uniform(4);
    NSInteger additinalDays = arc4random_uniform(30);
    [p setYears:[NSNumber numberWithInteger:YOUTH_STARTING_AGE]];
    [p setMonths:[NSNumber numberWithInteger:additionalMonths]];
    [p setDays:[NSNumber numberWithInteger:additinalDays]];
    
    // randomize skills
    NSRange range;
    NSUInteger potential, current;
    NSString* skillType;
    NSMutableArray* tempSkillsArray = [NSMutableArray array];
    
    NSArray* arrayToIterate = [chosenPosition isEqualToString:@"GK"] ? [self goalkeeperSkills] : [self outfielderSkills];
    for (NSString* key in [arrayToIterate reverseObjectEnumerator]) {
        skillType = key;
        range = rangeFromString(qualityDict[key]);
        potential = randomUnsignedInRange(range);
        NSUInteger diff = (NSUInteger)arc4random_uniform(MIN(CURRENT_TO_POTENTIAL_DIFF_MAX, (u_int32_t)potential));
        current = MAX(10, potential - diff);
        PlayerSkill* skill = [[PlayerSkill alloc] init];
        [skill setType:skillType];
        [skill setPotential:potential];
        [skill setCurrent:current];
        [tempSkillsArray addObject:skill];
    }
    [p setSkills:[tempSkillsArray copy]];
    
    return p;
}

#pragma mark -
#pragma mark Helpers

+ (NSArray*)outfielderSkills {
    if (!outfielderSkills) {
        outfielderSkills = @[@"SC", @"OP", @"BC", @"PA", @"AE", @"CO", @"TA", @"DP"];
    }
    return outfielderSkills;
}

+ (NSArray*)goalkeeperSkills {
    if (!goalkeeperSkills) {
        goalkeeperSkills = @[@"RE", @"GP", @"IN", @"CT", @"OR"];
    }
    return goalkeeperSkills;
}

+ (NSArray*)allSkillsArray {
    if (!allSkillsArray) {
        allSkillsArray = [[self outfielderSkills] arrayByAddingObjectsFromArray:[self goalkeeperSkills]];
    }
    return allSkillsArray;
}

+ (void)initArrays {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"YouthLimits" ofType:@"plist"];
    rootDict = [[NSDictionary alloc] initWithContentsOfFile:path];
    GKArray = rootDict[@"GK"];
    CBArray = rootDict[@"CB"];
    SBArray = rootDict[@"SB"];
    OSBArray = rootDict[@"OSB"];
    DMArray = rootDict[@"DM"];
    MArray = rootDict[@"M"];
    OMArray = rootDict[@"OM"];
    FWArray = rootDict[@"FW"];
    
    path = [[NSBundle mainBundle] pathForResource:@"Names" ofType:@"plist"];
    namesDict = [[NSDictionary alloc] initWithContentsOfFile:path];
}

@end
