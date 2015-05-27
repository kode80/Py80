//
//  KDEDocumentTracker.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/21/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEDocumentTracker.h"


@interface KDEDocumentTracker ()

@property (nonatomic, readwrite, weak) id<KDEDocumentTrackerDelegate> delegate;

@property (nonatomic, readwrite, copy) NSArray *documentExtensions;
@property (nonatomic, readwrite, copy) NSString *activeFilePath;
@property (nonatomic, readwrite, assign) BOOL activeFileIsNew;
@property (nonatomic, readwrite, assign) BOOL activeFileNeedsSaving;

@property (nonatomic, readonly, strong) NSString *userDefaultsKeyActiveFilePath;

@end


@implementation KDEDocumentTracker

- (void) dealloc
{
    [self writeActiveFileToUserDefaults];
}

- (instancetype) initWithDocumentExtensions:(NSArray *)documentExtensions
                         userDefaultsPrefix:(NSString *)userDefaultsPrefix
                                   delegate:(id<KDEDocumentTrackerDelegate>)delegate
{
    self = [super init];
    
    if( self &&
        documentExtensions.count &&
        userDefaultsPrefix &&
        delegate)
    {
        self.documentExtensions = documentExtensions;
        self.delegate = delegate;
        
        _userDefaultsKeyActiveFilePath = [userDefaultsPrefix stringByAppendingString:@"DocumentTrackerActiveFilePath"];
    }
    
    return self;
}

#pragma mark - Accessors

- (void) setActiveFileNeedsSaving:(BOOL)activeFileNeedsSaving
{
    if( _activeFileNeedsSaving != activeFileNeedsSaving)
    {
        _activeFileNeedsSaving = activeFileNeedsSaving;
        [self.delegate documentTrackerActiveFileNeedsSaveDidChange:self];
    }
}

#pragma mark - Public

- (void) checkUserDefaultsForPreviousActiveFile
{
    NSString *previousActiveFilePath = [[NSUserDefaults standardUserDefaults] stringForKey:self.userDefaultsKeyActiveFilePath];
    BOOL previousActiveFileExists = previousActiveFilePath &&
                                    [[NSFileManager defaultManager] fileExistsAtPath:previousActiveFilePath];
    
    self.activeFilePath = previousActiveFileExists ? previousActiveFilePath : [self defaultFileName];
    self.activeFileIsNew = previousActiveFileExists == NO;
    self.activeFileNeedsSaving = NO;
    
    [self.delegate documentTrackerActiveFileDidChange:self];
}

- (void) writeActiveFileToUserDefaults
{
    [[NSUserDefaults standardUserDefaults] setObject:self.activeFileIsNew ? nil : self.activeFilePath
                                              forKey:self.userDefaultsKeyActiveFilePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void) newDocument
{
    if( [self canChangeActiveFile])
    {
        self.activeFilePath = [self defaultFileName];
        self.activeFileNeedsSaving = NO;
        self.activeFileIsNew = YES;
        
        [self.delegate documentTrackerActiveFileDidChange:self];
    }
}

- (BOOL) openDocumentForWindow:(NSWindow *)window
{
    if( [self canChangeActiveFile])
    {
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        panel.allowedFileTypes = self.documentExtensions;
        panel.allowsMultipleSelection = NO;
        panel.canChooseDirectories = NO;

        NSInteger result = [panel runModal];

        if (result == NSFileHandlingPanelOKButton)
        {
            [self openDocumentAtPath:panel.URL.filePathURL.path];
        }
        
        return result == NSFileHandlingPanelOKButton;
    }
    
    return NO;
}

- (void) openDocumentAtPath:(NSString *)path
{
    // TODO: add file exists check and delegate method for alerting when file doesn't exist
    
    if( [self canChangeActiveFile])
    {
        self.activeFilePath = path;
        self.activeFileNeedsSaving = NO;
        self.activeFileIsNew = NO;

        [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:path]];
        
        [self.delegate documentTrackerActiveFileDidChange:self];
    }
}

- (BOOL) saveDocumentForWindow:(NSWindow *)window
{
    if( self.activeFileIsNew)
    {
        return [self saveDocumentAsForWindow:window];
    }
    else if( [self.delegate documentTrackerSaveActiveFile:self])
    {
        self.activeFileNeedsSaving = NO;
        self.activeFileIsNew = NO;
        return YES;
    }
    
    return NO;
}

- (BOOL) saveDocumentAsForWindow:(NSWindow *)window
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = self.documentExtensions;
    panel.nameFieldStringValue = self.activeFilePath.lastPathComponent;
    
    NSInteger result = [panel runModal];

    if (result == NSFileHandlingPanelOKButton)
    {
        NSString *oldPath = self.activeFilePath;
        self.activeFilePath = panel.URL.filePathURL.path;

        if( [self.delegate documentTrackerSaveActiveFile:self])
        {
            self.activeFileIsNew = NO;
            self.activeFileNeedsSaving = NO;
            [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:[NSURL fileURLWithPath:self.activeFilePath]];
            
            return YES;
        }
        else
        {
            self.activeFilePath = oldPath;
        }
    }
    
    return NO;
}

- (void) revertDocumentToSaved
{
    if( self.activeFileIsNew == NO &&
        self.activeFileNeedsSaving &&
        [self.delegate documentTrackerActiveFileNeedingSaveCanRevert:self])
    {
        self.activeFileNeedsSaving = NO;
        [self.delegate documentTrackerActiveFileDidChange:self];
    }
}

- (void) markActiveFileAsNeedingSave
{
    self.activeFileNeedsSaving = YES;
}

#pragma mark - Private

- (NSString *) defaultFileName
{
    return [@"Untitled" stringByAppendingPathExtension:self.documentExtensions[ 0]];
}

- (BOOL) canChangeActiveFile
{
    return self.activeFileNeedsSaving == NO || [self.delegate documentTrackerActiveFileNeedingSaveCanChange:self];
}

@end
