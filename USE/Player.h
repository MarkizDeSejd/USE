//
//  Player.h
//  Freekick
//
//  Created by Jakub Lawicki on 20.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

@interface Player : NSObject

@property(nonatomic, strong) NSString* playerId;
@property(nonatomic, strong) NSString* type;
@property(nonatomic, strong) NSString* firstName;
@property(nonatomic, strong) NSString* lastName;
@property(nonatomic, strong) NSString* nickName;
@property(nonatomic, strong) NSNumber* youth;
@property(nonatomic, strong) NSNumber* years;
@property(nonatomic, strong) NSNumber* months;
@property(nonatomic, strong) NSNumber* days;
@property(nonatomic, strong) NSArray* skills;
@property(nonatomic, strong) NSString* preferredFoot;
@property(nonatomic, strong) NSString* form;
@property(nonatomic, strong) NSNumber* trend;
@property(nonatomic, strong) NSNumber* leagueCurrent;
@property(nonatomic, strong) NSNumber* leagueExhausted;
@property(nonatomic, strong) NSNumber* leagueInjury;
@property(nonatomic, strong) NSNumber* leagueSuspension;
@property(nonatomic, strong) NSNumber* cupCurrent;
@property(nonatomic, strong) NSNumber* cupExhausted;
@property(nonatomic, strong) NSNumber* cupInjury;
@property(nonatomic, strong) NSNumber* cupSuspension;
@property(nonatomic, strong) NSString* experience;
@property(nonatomic, strong) NSString* loyalty;
@property(nonatomic, strong) NSString* desiredPosition;
@property(nonatomic, strong) NSString* commitment;
@property(nonatomic, strong) NSString* attackerChoice;
@property(nonatomic, strong) NSString* midfielderChoice;
@property(nonatomic, strong) NSString* defenderChoice;
@property(nonatomic, strong) NSNumber* totalSalary;
@property(nonatomic) NSUInteger ratingSalary;
@property(nonatomic) NSUInteger adjustmentSalary;
@property(nonatomic, strong) NSNumber* purchasePrice;
@property(nonatomic, strong) NSDate* joinDate;
@property(nonatomic, strong) NSString* nation;
@property(nonatomic, strong) NSString* homeClubId;
@property(nonatomic, strong) NSArray* personalities;
@property(nonatomic) NSNumber* revealSkills;
@property(nonatomic) NSNumber* underEvaluation;
@property(nonatomic) NSNumber* nationalTeamSenior;
@property(nonatomic) NSNumber* nationalTeamYouth;
@property(nonatomic) NSNumber* nationalTeamProspectSenior;
@property(nonatomic) NSNumber* nationalTeamProspectYouth;
@property(nonatomic) int number;
@property(nonatomic) NSArray* training;

- (void)normalize;

@end
