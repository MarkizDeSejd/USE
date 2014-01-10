//
//  AppDelegate.m
//  USE
//
//  Created by jakub on 09/01/2014.
//  Copyright (c) 2014 jakub. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayerGenerator.h"
#import "PlayerViewController.h"

@implementation AppDelegate {
    PlayerViewController* playerViewController;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [self.levelButton removeAllItems];
    [self.levelButton addItemsWithTitles:@[@"weak", @"dec", @"good", @"exc", @"sup", @"bri"]];
    [self.levelButton setTitle:NSLocalizedString(@"SELECT_QUALITY_KEY", @"A text indicating to the user that he needs to select the quality of the player")];
    
    [self.positionButton removeAllItems];
    [self.positionButton addItemsWithTitles:@[@"GK", @"CB", @"SB", @"OSB", @"DM", @"M", @"OM", @"FW"]];
    [self.positionButton setTitle:NSLocalizedString(@"SELECT_POSITION_KEY", @"A text indicating to the user that he needs to select the desired position for the new player")];
    
    [self.generateButton setTitle:NSLocalizedString(@"GENERATE_BUTTON_TITLE_KEY", @"A text on the generate button")];
    
    playerViewController = [[PlayerViewController alloc] init];
    [self.playerView addSubview:playerViewController.view];
    [playerViewController.view setFrame:[self.playerView bounds]];
}

#pragma mark -
#pragma mark Actions

- (IBAction)onLevelButtonSelected:(id)sender {
    
}

- (IBAction)onPositionButtonSelected:(id)sender {
    
}

- (IBAction)onGenerateButtonPressed:(id)sender {
    NSInteger idx = [self.levelButton indexOfSelectedItem];
    NSLog(@"Index: %li", (long)idx);
    NSInteger pos = [self.positionButton indexOfSelectedItem];
    
    if (idx < 6) { // only care if a number selected
        Player* p = [PlayerGenerator generatePlayerWithQuality:idx
                                                      position:(DesiredPosition)pos];
        // display it
        NSLog(@"Player: %@", p);
        [playerViewController setPlayer:p];
    }
}

@end
