//
//  KDEPreferencesWindowController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPreferencesWindowController.h"
#import "KDEPreferencesGeneralViewController.h"
#import "KDEPreferencesThemeViewController.h"


@interface KDEPreferencesWindowController () <NSToolbarDelegate>

@end


@implementation KDEPreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self.window.toolbar setSelectedItemIdentifier:@"General"];
    [self showGeneral:nil];
}

- (IBAction) showGeneral:(id)sender
{
    self.window.contentViewController = self.generalController;
}

- (IBAction) showTheme:(id)sender
{
    self.window.contentViewController = self.themeController;
}

@end
