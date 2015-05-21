//
//  KDEDocumentTracker.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/21/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KDEDocumentTrackerDelegate;


@interface KDEDocumentTracker : NSObject

@property (nonatomic, readonly, copy) NSArray *documentExtensions;
@property (nonatomic, readonly, copy) NSString *activeFilePath;
@property (nonatomic, readonly, assign) BOOL activeFileIsNew;
@property (nonatomic, readonly, assign) BOOL activeFileNeedsSaving;

- (instancetype) initWithDocumentExtensions:(NSArray *)documentExtensions
                         userDefaultsPrefix:(NSString *)userDefaultsPrefix
                                   delegate:(id<KDEDocumentTrackerDelegate>)delegate;

- (void) checkUserDefaultsForPreviousActiveFile;
- (void) writeActiveFileToUserDefaults;

- (void) newDocument;
- (BOOL) openDocumentForWindow:(NSWindow *)window;
- (void) openDocumentAtPath:(NSString *)path;
- (BOOL) saveDocumentForWindow:(NSWindow *)window;
- (BOOL) saveDocumentAsForWindow:(NSWindow *)window;
- (void) revertDocumentToSaved;

- (void) markActiveFileAsNeedingSave;

@end


@protocol KDEDocumentTrackerDelegate <NSObject>

- (void) documentTrackerActiveFileNeedsSaveDidChange:(KDEDocumentTracker *)tracker;

- (BOOL) documentTrackerActiveFileNeedingSaveCanChange:(KDEDocumentTracker *)tracker;
- (BOOL) documentTrackerActiveFileNeedingSaveCanRevert:(KDEDocumentTracker *)tracker;
- (void) documentTrackerActiveFileDidChange:(KDEDocumentTracker *)tracker;
- (BOOL) documentTrackerSaveActiveFile:(KDEDocumentTracker *)tracker;

@end
