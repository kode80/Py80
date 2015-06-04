//
//  KDEPreferencesThemeViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPreferencesThemeViewController.h"

#import "KDETheme.h"


@interface KDEPreferencesThemeViewController ()

@property (nonatomic, readwrite, strong) NSDictionary *themes;
@property (nonatomic, readwrite, strong) NSArray *themeNames;
@property (nonatomic, readwrite, strong) KDETheme *currentTheme;
@property (nonatomic, readwrite, strong) NSArray *currentThemeItemNames;
@property (nonatomic, readonly, strong) NSString *currentThemeItemName;

@end


@implementation KDEPreferencesThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *themePath = [[NSBundle mainBundle] pathForResource:@"DefaultTheme"
                                                          ofType:@"json"];
    KDETheme *theme = [[KDETheme alloc] initWithJSONAtPath:themePath];
    self.themes = @{ @"Default" : theme };
    self.themeNames = @[ @"Default" ];
    self.currentTheme = theme;
}

#pragma mark - Accessors

- (void) setCurrentTheme:(KDETheme *)currentTheme
{
    if( _currentTheme != currentTheme)
    {
        _currentTheme = currentTheme;
        self.currentThemeItemNames = [currentTheme.itemNames sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [self reloadTableView:self.themeItemsTable];
    }
}

- (NSString *) currentThemeItemName
{
    return self.currentThemeItemNames[ self.themeItemsTable.selectedRow];
}

#pragma mark - Actions

- (IBAction) addTheme:(id)sender
{
    
}

- (IBAction) removeTheme:(id)sender
{
    
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
}

- (IBAction) changeFont:(id)sender
{
    NSFont *font = [NSFont systemFontOfSize:11.0f];
    font = [[NSFontManager sharedFontManager] convertFont:font];
    
    [self updateFontButtonWithFont:font];
    [self.currentTheme setFont:font
                   forItemName:self.currentThemeItemName];
    [self reloadTableView:self.themeItemsTable];
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
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:row]
           byExtendingSelection:NO];
}

@end
