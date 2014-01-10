//
//  PlayerAgeComponents.h
//  MatchPlayer
//
//  Created by Jakub Lawicki on 03/11/2012.
//
//

#import <Foundation/Foundation.h>

@interface PlayerAge : NSObject <NSCopying>

@property (nonatomic) NSDate *age;
@property (nonatomic) NSDate *reference;
@property (nonatomic, readonly) NSInteger years;
@property (nonatomic, readonly) NSInteger months;
@property (nonatomic, readonly) NSInteger days;

- (PlayerAge*)initWithYears:(NSInteger)y Months:(NSInteger)m Days:(NSInteger)d;
- (PlayerAge*)initWithAge:(NSDate*)a;
- (void)addDays:(NSInteger)d;

- (PlayerAge*)ageAfterRealDays:(NSInteger)realDays;

@end
