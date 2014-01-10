//
//  Player.m
//  Freekick
//
//  Created by Jakub Lawicki on 20.10.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

@implementation Player

- (NSString*)description {
    return [self verboseDescription];
}

- (void)normalize {
    [self.skills makeObjectsPerformSelector:@selector(normalize)];

    NSUInteger idx = [self.training indexOfObjectPassingTest:^BOOL(NSString* obj, NSUInteger idx, BOOL *stop) {
        *stop = [obj isEqualToString:@"ha"] || [obj isEqualToString:@"rb"] || [obj isEqualToString:@"sp"];
        return *stop;
    }];
    if (idx != NSNotFound) {
        NSMutableArray* newTraining = [NSMutableArray array];
        for (NSString* trainingName in self.training) {
            if ([trainingName isEqualToString:@"ha"]) {
                [newTraining addObject:@"re"];
            } else if ([trainingName isEqualToString:@"rb"]) {
                [newTraining addObject:@"ct"];
            } else if ([trainingName isEqualToString:@"sp"]) {
                [newTraining addObject:@"or"];
            } else {
                [newTraining addObject:trainingName];
            }
        }
        [self setTraining:[newTraining copy]];
    }
    
    if ([self.training count] == 0) {
        NSLog(@"*** Warning *** %@ %@ doesn't have any training set!", self.firstName, self.lastName);
    }
}

@end
