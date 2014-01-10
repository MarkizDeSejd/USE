//
//  PlayerViewController.m
//  MatchPlayer
//
//  Created by Jakub Lawicki on 18/10/2013.
//
//

#import "PlayerAge.h"
#import "PlayerSkill.h"
#import "PlayerViewController.h"

#define ARC4RANDOM_MAX 0x100000000

float randomFloat() {
    return ((double)arc4random() / ARC4RANDOM_MAX);
}

@interface PlayerViewController ()

@end

@implementation PlayerViewController {
    NSArray* _potentialEstimation;
}

- (id)initWithPlayer:(Player *)p {
    if (self = [super init]) {
        _player = p;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:[NSString stringWithFormat:@"%@ %@", self.player.firstName, self.player.lastName]];
}

- (void)setPlayer:(Player *)player {
    _player = player;
    _potentialEstimation = [self calculatePotentialRaises];

    [self.nameLabel setStringValue:[NSString stringWithFormat:@"%@ %@", player.firstName, player.lastName]];
    [self.ageLabel setStringValue:[NSString stringWithFormat:@"%@y %@m %@d", player.years, player.months, player.days]];
    
    [self setupSkillsView];
}

#pragma mark Private

- (void)setupSkillsView {
    // in case we are refreshing, remove all children
    [[self.skillsView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // now add the columns descriptions
    NSTextField* columnsLabel = [[NSTextField alloc] init];
    [columnsLabel setStringValue:@"Skill    C        P        TD       E"];
    [columnsLabel setFrame:CGRectMake(0, self.skillsView.frame.size.height - 20.0f, self.skillsView.frame.size.width, 20.0f)];
    [self.skillsView addSubview:columnsLabel];
    
    // then add the skills
    for (PlayerSkill* skill in self.player.skills) {
        [self setupLabelWithSkill:skill];
    }
}

- (void)setupLabelWithSkill:(PlayerSkill*)skill {
    NSUInteger skillIndex = [self.player.skills indexOfObject:skill];
    NSTextField* newLabel = [[NSTextField alloc] init];
    NSUInteger estimation =
    skill.potential + [(NSNumber*)_potentialEstimation[skillIndex] unsignedIntegerValue];
    NSMutableAttributedString* attributedSkills = [[NSMutableAttributedString alloc] initWithString:skill.type];
    //add spaces and values
    [attributedSkills appendAttributedString:[[NSAttributedString alloc] initWithString:@"      "]];
    [attributedSkills appendAttributedString:[self skillStringForValue:skill.current]];
    [attributedSkills appendAttributedString:[[NSAttributedString alloc] initWithString:@"      "]];
    [attributedSkills appendAttributedString:[self skillStringForValue:skill.potential]];
    [attributedSkills appendAttributedString:[[NSAttributedString alloc] initWithString:@"      "]];
    [attributedSkills appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%2lu", (unsigned long)skill.trainingDays]]];
    [attributedSkills appendAttributedString:[[NSAttributedString alloc] initWithString:@"      "]];
    [attributedSkills appendAttributedString:[self skillStringForValue:estimation]];
    
    [newLabel setStringValue:[attributedSkills string]];
    // for positioning we need last subview of the container
    NSTextField* lastSubview = [[self.skillsView subviews] lastObject];
    CGRect newFrame = CGRectMake(0, lastSubview.frame.origin.y - lastSubview.frame.size.height, self.skillsView.frame.size.width, 20.0f);
    [newLabel setFrame:newFrame];
    [self.skillsView addSubview:newLabel];
}

- (NSAttributedString*)skillStringForValue:(NSUInteger)val {
    NSString* valueAsString = [NSString stringWithFormat:@"%lu", (unsigned long)val];
    NSMutableAttributedString* ret = [[NSMutableAttributedString alloc] initWithString:valueAsString];
//    [ret addAttribute:NSForegroundColorAttributeName
//                value:[Shared colorForInt:val]
//                range:NSMakeRange(0, [ret length])];
    return [ret copy];
}

#pragma mark YouthAnalyzer

- (NSArray*)calculatePotentialRaises {
    NSUInteger avgRaises[[self.player.skills count]];
    // calculate how many days the player has left as a youth
    PlayerAge* newAge = [[PlayerAge alloc] initWithYears:15 Months:0 Days:0];
    PlayerAge* seniorAge = [[PlayerAge alloc] initWithYears:21 Months:0 Days:0];
    PlayerAge* pAge = [[PlayerAge alloc] initWithYears:[self.player.years integerValue]
                                                Months:[self.player.months integerValue]
                                                  Days:[self.player.days integerValue]];
    NSCalendar* cal = [NSCalendar currentCalendar];
    NSDateComponents* dayComps = [cal components:NSDayCalendarUnit
                                        fromDate:newAge.age
                                          toDate:seniorAge.age
                                         options:0];
    NSInteger totalDays = [dayComps day];
    dayComps = [cal components:NSDayCalendarUnit
                      fromDate:newAge.age
                        toDate:pAge.age
                       options:0];
    NSInteger playerDays = [dayComps day];
    float percent = 1 - ((float)playerDays / (float)totalDays);
    
    BOOL isKeeper = [self.player.type isEqualToString:@"goalkeeper"];
    int avgRaise = isKeeper ? 60 : 80;
    float randomizator = (randomFloat() - 0.5f) * 20;
    
    float potRaises = (avgRaise + randomizator) * percent;
    
    
    int numberOfRaises = round(potRaises / 3);
    int sumPotsSquare = 0;
    int i, x;
    for (i = 0; i < [self.player.skills count]; i++) {
        PlayerSkill* skill = self.player.skills[i];
        sumPotsSquare += skill.potential * skill.potential;
    }
    
    // get order of the skills, starting from the biggest
    NSArray* orderedSkills = [self.player.skills sortedArrayUsingComparator:^NSComparisonResult(PlayerSkill* obj1, PlayerSkill* obj2) {
        NSComparisonResult ret;
        if (obj1.potential > obj2.potential) {
            ret = (NSComparisonResult)NSOrderedAscending;
        } else if (obj1.potential < obj2.potential) {
            ret = (NSComparisonResult)NSOrderedDescending;
        } else {
            ret = (NSComparisonResult)NSOrderedSame;
        }
        return ret;
    }];
    
    NSUInteger potOrder[[self.player.skills count]];
    for (i = 0; i < [self.player.skills count]; i++) {
        potOrder[i] = [self.player.skills indexOfObject:orderedSkills[i]];
    }
    int numberOfCalculations = 100;
    NSUInteger raises[[self.player.skills count]];
    NSUInteger potentials[[self.player.skills count]];
    for (i = 0; i < [self.player.skills count]; i++) {
        potentials[i] = [(PlayerSkill*)self.player.skills[i] potential];
    }
    for (x = 0; x < numberOfCalculations; x++) {
        int sumPotsSquareCurrent = sumPotsSquare;
        float potRaisesCurrent = potRaises;
        // calculate raises
        int estNumberOfRaises = 0;
        NSUInteger pos = 0;
        for (i = 0; i < [self.player.skills count]; i++) {
            // we calculate raises for the biggest pontential first
            pos = potOrder[i];
            
            float potSquare = potentials[pos] * potentials[pos];
            float potSquareFactor = potSquare / sumPotsSquareCurrent;
            potSquareFactor *=  potRaisesCurrent;
            float randomizer = (randomFloat() - 0.5f) * 4;
            float input = potSquareFactor + randomizer;
            int maximum = MAX(input , 0);
            
            raises[pos] = maximum;
            if (raises[pos] > 0) {
                estNumberOfRaises++;
                // cannot be more than 100
                if (potentials[pos] + raises[pos] > 100) {
                    raises[pos] = 100 - potentials[pos];
                    if (raises[pos] == 0) {
                        estNumberOfRaises--;
                    }
                    sumPotsSquareCurrent -= potentials[pos] * potentials[pos]; // calculate the others without it
                    potRaisesCurrent -= raises[pos]; // calculate the others without it
                }
            }
        }
        
        for (i = 0; i < [self.player.skills count]; i++) {
            pos = potOrder[i];
            // reduces raises to number of raises
            if (numberOfRaises < estNumberOfRaises && numberOfRaises < i) {
                raises[pos] = 0;
            }
            if (x > 0) {
                avgRaises[pos] = (avgRaises[pos] * x + raises[pos]) / (x + 1);
                raises[pos] = 0;
            }
        }
        
        if (x == 0) {
            for (i = 0; i < [self.player.skills count]; i++) {
                avgRaises[i] = raises[i];
            }
        }
    }
    
    for (i = 0; i < [self.player.skills count]; i++) {
        raises[i] = round(avgRaises[i]);
        //NSLog(@"raises[%i] = %d", i, raises[i]);
    }
    
    NSMutableArray* ret = [NSMutableArray array];
    for (i = 0; i < [self.player.skills count]; i++) {
        [ret addObject:[NSNumber numberWithUnsignedInteger:raises[i]]];
    }
    return [ret copy];
}

@end
