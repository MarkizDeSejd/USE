//
//  PlayerGenerator.h
//  USE
//
//  Created by jakub on 09/01/2014.
//  Copyright (c) 2014 jakub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Player.h"

typedef enum {
    PlayerPositionGK,
    PlayerPositionCB,
    PlayerPositionSB,
    PlayerPositionOSB,
    PlayerPositionDM,
    PlayerPositionM,
    PlayerPositionOM,
    PlayerPositionFW,
    PlayerPositionRandom
} DesiredPosition;

@interface PlayerGenerator : NSObject

+ (Player*)generatePlayerWithQuality:(NSInteger)quality;
+ (Player*)generatePlayerWithQuality:(NSInteger)quality position:(DesiredPosition)pos;

@end
