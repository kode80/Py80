//
//  KDEPreferencesThemeViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPreferencesThemeViewController.h"

@interface KDEPreferencesThemeViewController ()

@end

@implementation KDEPreferencesThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

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
    
}

- (IBAction) changeFont:(id)sender
{
    NSFont *font = [NSFont systemFontOfSize:11.0f];
    font = [[NSFontManager sharedFontManager] convertFont:font];
    self.fontButton.title = [NSString stringWithFormat:@"%@, %@pt", font.fontName, @(font.pointSize)];
}

- (NSUInteger) validModesForFontPanel:(NSFontPanel *)fontPanel
{
    return NSFontPanelFaceModeMask | NSFontPanelSizeModeMask;
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return 8;
}

- (void) tableViewSelectionDidChange:(NSNotification *)notification
{
}

#pragma mark - NSTableViewDelegate

- (NSView *) tableView:(NSTableView *)tableView
    viewForTableColumn:(NSTableColumn *)tableColumn
                   row:(NSInteger)row
{
    NSTableCellView *view = [tableView makeViewWithIdentifier:@"cell"
                                                        owner:self];
    
    view.textField.stringValue = [tableColumn.identifier stringByAppendingFormat:@" Cell #%@", @(row)];
    
    return view;
}

@end
