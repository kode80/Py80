//
//  KDEPreferencesThemeViewController.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDEPreferencesThemeViewController : NSViewController
<
    NSTableViewDataSource,
    NSTableViewDelegate
>

@property (nonatomic, readwrite, weak) IBOutlet NSTableView *themesTable;
@property (nonatomic, readwrite, weak) IBOutlet NSTableView *themeItemsTable;
@property (nonatomic, readwrite, weak) IBOutlet NSButton *addThemeButton;
@property (nonatomic, readwrite, weak) IBOutlet NSButton *removeThemeButton;

@property (nonatomic, readwrite, weak) IBOutlet NSTextField *fontLabel;
@property (nonatomic, readwrite, weak) IBOutlet NSButton *fontButton;
@property (nonatomic, readwrite, weak) IBOutlet NSColorWell *colorWell;

- (IBAction) addTheme:(id)sender;
- (IBAction) removeTheme:(id)sender;
- (IBAction) pickFont:(id)sender;

- (IBAction) changeColor:(id)sender;
- (IBAction) themeTableTextEditingEnded:(id)sender;

@end
