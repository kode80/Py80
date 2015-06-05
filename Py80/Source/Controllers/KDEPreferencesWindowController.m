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


@interface KDEPreferencesWindowController () <NSToolbarDelegate, KDEPreferencesThemeViewControllerDelegate>

@end


@implementation KDEPreferencesWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.themeController.delegate = self;
    
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

- (void) themeViewController:(KDEPreferencesThemeViewController *)controller didUpdateTheme:(KDETheme *)theme
{
    if( [self.delegate respondsToSelector:@selector(preferencesWindowController:didUpdateTheme:)])
    {
        [self.delegate preferencesWindowController:self
                                    didUpdateTheme:theme];
    }
}

@end
