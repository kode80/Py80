//
//  KDEPreferencesThemeViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPreferencesThemeViewController.h"

#import "KDEPy80Preferences.h"
#import "KDETheme.h"


@interface KDEPreferencesThemeViewController ()

@property (nonatomic, readwrite, strong) NSDictionary *themes;
@property (nonatomic, readwrite, strong) NSArray *themeNames;
@property (nonatomic, readwrite, strong) NSArray *themePaths;
@property (nonatomic, readwrite, strong) KDETheme *currentTheme;
@property (nonatomic, readwrite, strong) NSArray *currentThemeItemNames;
@property (nonatomic, readonly, strong) NSString *currentThemeItemName;

@end


@implementation KDEPreferencesThemeViewController

- (void) viewWillAppear
{
    [super viewWillAppear];
    [self reloadThemes];
}

- (void) viewWillDisappear
{
    [super viewWillDisappear];
    [self saveCurrentTheme];
}

#pragma mark - Accessors

- (void) setCurrentTheme:(KDETheme *)currentTheme
{
    if( _currentTheme != currentTheme)
    {
        _currentTheme = currentTheme;
        self.currentThemeItemNames = [currentTheme.itemNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [self reloadTableView:self.themeItemsTable];
        
        NSString *name = [self.themes allKeysForObject:currentTheme].firstObject;
        [KDEPy80Preferences sharedPreferences].currentThemePath = self.themePaths[ [self.themeNames indexOfObject:name]];
    }
}

- (NSString *) currentThemeItemName
{
    return self.currentThemeItemNames[ self.themeItemsTable.selectedRow];
}

#pragma mark - Actions

- (IBAction) addTheme:(id)sender
{
    NSInteger row = self.themesTable.selectedRow;
    [[KDEPy80Preferences sharedPreferences] duplicateThemeNamed:self.themeNames[ row]];
    [self reloadThemes];
}

- (IBAction) removeTheme:(id)sender
{
    if( self.themeNames.count > 1)
    {
        NSInteger row = self.themesTable.selectedRow;
        [[KDEPy80Preferences sharedPreferences] deleteThemeNamed:self.themeNames[ row]];
        [self reloadThemes];
    }
}

- (IBAction) pickFont:(id)sender
{
    NSFontManager *manager = [NSFontManager sharedFontManager];
    
    manager.target = self;
    manager.action = @selector(changeFont:);
    [manager setSelectedFont:[NSFont systemFontOfSize:11.0f]
                  isMultiple:NO];
    [manager orderFrontFontPanel:nil];
}

- (IBAction) changeColor:(id)sender
{
    NSColor *color = [[sender color] colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
    [self.currentTheme setColor:color
                    forItemName:self.currentThemeItemName];
    [self reloadTableView:self.themeItemsTable];
    
    [self informDelegateOfThemeUpdates];
}

- (IBAction) changeFont:(id)sender
{
    NSFont *font = [NSFont systemFontOfSize:11.0f];
    font = [[NSFontManager sharedFontManager] convertFont:font];
    
    [self updateFontButtonWithFont:font];
    [self.currentTheme setFont:font
                   forItemName:self.currentThemeItemName];
    [self reloadTableView:self.themeItemsTable];
    
    [self informDelegateOfThemeUpdates];
}

- (IBAction) themeTableTextEditingEnded:(id)sender
{
    NSTextField *label = sender;
    NSInteger row = [self.themesTable rowForView:sender];
    NSString *oldName = self.themeNames[ row];
    
    BOOL renamed = [[KDEPy80Preferences sharedPreferences] renameThemeNamed:oldName
                                                                         to:label.stringValue];
    
    if( renamed)
    {
        [self reloadThemes];
    }
    else
    {
        label.stringValue = oldName;
    }
}

- (NSUInteger) validModesForFontPanel:(NSFontPanel *)fontPanel
{
    return NSFontPanelFaceModeMask | NSFontPanelSizeModeMask;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    if( tableView == self.themesTable)
    {
        return self.themeNames.count;
    }
    else if( tableView == self.themeItemsTable)
    {
        return self.currentThemeItemNames.count;
    }
    return 0;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
    NSTableView *tableView = notification.object;
    NSInteger row = tableView.selectedRow;
    
    if( tableView == self.themesTable)
    {
        [self saveCurrentTheme];
        self.currentTheme = self.themes[ self.themeNames[ row]];
    }
    else if( tableView == self.themeItemsTable)
    {
        NSString *itemName = self.currentThemeItemName;
        
        [self updateFontButtonWithFont:[self.currentTheme fontForItemName:itemName]];
        self.colorWell.color = [self.currentTheme colorForItemName:itemName];
    }
}

#pragma mark - NSTableViewDelegate

- (NSView *) tableView:(NSTableView *)tableView
    viewForTableColumn:(NSTableColumn *)tableColumn
                   row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:@"cell"
                                                        owner:self];
    
    if( tableView == self.themesTable)
    {
        view.textField.stringValue = self.themeNames[ row];
    }
    else if( tableView == self.themeItemsTable)
    {
        NSString *itemName = self.currentThemeItemNames[ row];
        NSFont *font = [self.currentTheme fontForItemName:itemName];
        NSColor *color = [self.currentTheme colorForItemName:itemName];
        
        view.textField.stringValue = itemName;
        if( font && color)
        {
            view.textField.textColor = color;
        }
    }
    
    return view;
}

#pragma mark - Private

- (void) updateFontButtonWithFont:(NSFont *)font
{
    if( font == nil)
    {
        self.fontLabel.textColor = [NSColor disabledControlTextColor];
        self.fontButton.title = @"None";
        self.fontButton.enabled = NO;
    }
    else
    {
        self.fontLabel.textColor = [NSColor blackColor];
        self.fontButton.title = [NSString stringWithFormat:@"%@, %@pt", font.fontName, @(font.pointSize)];
        self.fontButton.enabled = YES;
    }
}

- (void) reloadTableView:(NSTableView *)tableView
{
    NSInteger row = tableView.selectedRow;
    [tableView reloadData];
    
    row = MIN( row, [tableView numberOfRows] - 1);
    
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
           byExtendingSelection:NO];
}

- (void) reloadThemes
{
    NSArray *themePaths = [[KDEPy80Preferences sharedPreferences] pathsOfAvailableThemes];
    NSString *currentThemePath = [[KDEPy80Preferences sharedPreferences] currentThemePath];
    NSString *currentThemeName = [[currentThemePath lastPathComponent] stringByDeletingPathExtension];
    
    NSMutableArray *themeNames = [NSMutableArray array];
    NSMutableDictionary *themes = [NSMutableDictionary dictionary];
    NSString *name;

    for( NSString *path in themePaths)
    {
        name = [[path lastPathComponent] stringByDeletingPathExtension];
        themes[ name] = [[KDETheme alloc] initWithJSONAtPath:path];
        [themeNames addObject:name];
    }
    
    self.themePaths = themePaths;
    self.themeNames = [NSArray arrayWithArray:themeNames];
    self.themes = [NSDictionary dictionaryWithDictionary:themes];
    self.currentTheme = self.themes[ currentThemeName];
    
    [self reloadTableView:self.themesTable];
    
    self.removeThemeButton.enabled = self.themeNames.count > 1;
}

- (void) saveCurrentTheme
{
    if( self.currentTheme)
    {
        NSString *name = [self.themes allKeysForObject:self.currentTheme].firstObject;
        NSUInteger index = [self.themeNames indexOfObject:name];

        [self.currentTheme writeJSONToPath:self.themePaths[ index]];
    }
}

- (void) informDelegateOfThemeUpdates
{
    if( [self.delegate respondsToSelector:@selector(themeViewController:didUpdateTheme:)])
    {
        [self.delegate themeViewController:self
                            didUpdateTheme:self.currentTheme];
    }
}

@end
