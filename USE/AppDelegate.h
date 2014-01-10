//
//  AppDelegate.h
//  USE
//
//  Created by jakub on 09/01/2014.
//  Copyright (c) 2014 jakub. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic) IBOutlet NSPopUpButton *levelButton;
@property (nonatomic) IBOutlet NSPopUpButton *positionButton;
@property (nonatomic) IBOutlet NSButton *generateButton;
@property (nonatomic) IBOutlet NSView *playerView;

- (IBAction)onLevelButtonSelected:(id)sender;
- (IBAction)onPositionButtonSelected:(id)sender;
- (IBAction)onGenerateButtonPressed:(id)sender;

@end
