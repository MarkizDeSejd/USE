//
//  PlayerSkill.h
//  MatchPlayer
//
//  Created by Jakub Lawicki on 18/10/2013.
//
//

#import <Foundation/Foundation.h>

@interface PlayerSkill : NSObject

@property (nonatomic) NSUInteger current;
@property (nonatomic) NSUInteger formInfluenced;
@property (nonatomic) NSUInteger potential;
@property (nonatomic) NSUInteger trainingDays;
@property (nonatomic) NSString* type;

- (void)normalize; // needed to fix the stupid skill names for GKs

@end
