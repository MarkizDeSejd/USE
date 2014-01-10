//
//  PlayerAgeComponents.m
//  MatchPlayer
//
//  Created by Jakub Lawicki on 03/11/2012.
//
//

#import "PlayerAge.h"

@implementation PlayerAge {
    NSCalendar *cal;
}

- (PlayerAge*)initWithYears:(NSInteger)y Months:(NSInteger)m Days:(NSInteger)d {
    if (self = [super init]) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        if (d) {
            [comps setDay:d];
        }
        if (m) {
            [comps setMonth:m];
        }
        if (y) {
            [comps setYear:y];
        }
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _reference = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        _age = [cal dateByAddingComponents:comps toDate:_reference options:0];
    }
    return self;
}

- (PlayerAge*)initWithAge:(NSDate *)a {
    if (self = [super init]) {
        cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        _reference = [NSDate dateWithTimeIntervalSinceReferenceDate:0];
        _age = a;
    }
    return self;
}

- (void)addDays:(NSInteger)d {
    if (d) {
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:d];
        _age = [cal dateByAddingComponents:comps toDate:_age options:0];
    }
}

- (PlayerAge*)ageAfterRealDays:(NSInteger)realDays {
    PlayerAge* age = [self copy];
    [age addDays:realDays * 6];
    return age;
}

- (NSDateComponents*)ageComponents {
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents *comps = [cal components:unitFlags fromDate:_reference toDate:_age options:0];
    return comps;
}

- (NSInteger)years {
    return [[self ageComponents] year];
}

- (NSInteger)months {
    return [[self ageComponents] month];
}

- (NSInteger)days {
    return [[self ageComponents] day];
}

#pragma NSCopying

- (id)copyWithZone:(NSZone *)zone {
    PlayerAge *newAge = [[PlayerAge alloc] initWithAge:_age];
    return newAge;
}

#pragma NSObject overrides

- (NSString*)description {
    NSDateComponents *comps = [self ageComponents];
    NSMutableString* ret = [[super description] mutableCopy];
    [ret appendFormat:@"%ldy %ldm %ldd", (long)comps.year, (long)comps.month, (long)comps.day];
    return ret;
}

@end
