//
//  PlayerSkill.m
//  MatchPlayer
//
//  Created by Jakub Lawicki on 18/10/2013.
//
//

#import "PlayerSkill.h"

@implementation PlayerSkill

- (NSString*)description {
    return [self verboseDescription];
}

- (void)normalize {
    if ([self.type isEqualToString:@"ha"]) {
        [self setType:@"re"];
    } else if ([self.type isEqualToString:@"rb"]) {
        [self setType:@"ct"];
    } else if ([self.type isEqualToString:@"sp"]) {
        [self setType:@"or"];
    }
}

@end
