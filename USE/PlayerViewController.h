//
//  PlayerViewController.h
//  MatchPlayer
//
//  Created by Jakub Lawicki on 18/10/2013.
//
//

#import "Player.h"

@interface PlayerViewController : NSViewController

@property (nonatomic) Player* player;
@property (nonatomic) IBOutlet NSView* skillsView;
@property (nonatomic) IBOutlet NSTextField* nameLabel;
@property (nonatomic) IBOutlet NSTextField* ageLabel;

- (id)initWithPlayer:(Player*)p;

@end
