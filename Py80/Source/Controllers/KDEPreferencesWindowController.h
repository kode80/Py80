//
//  KDEPreferencesWindowController.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class KDEPreferencesGeneralViewController, KDEPreferencesThemeViewController, KDETheme;
@protocol KDEPreferencesWindowControllerDelegate;


@interface KDEPreferencesWindowController : NSWindowController

@property (nonatomic, readwrite, weak) id<KDEPreferencesWindowControllerDelegate> delegate;
@property (nonatomic, readwrite, strong) IBOutlet KDEPreferencesGeneralViewController *generalController;
@property (nonatomic, readwrite, strong) IBOutlet KDEPreferencesThemeViewController *themeController;

- (IBAction) showGeneral:(id)sender;
- (IBAction) showTheme:(id)sender;

@end


@protocol KDEPreferencesWindowControllerDelegate <NSObject>

- (void) preferencesWindowController:(KDEPreferencesWindowController *)controller
                      didUpdateTheme:(KDETheme *)theme;

@end