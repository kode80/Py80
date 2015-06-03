//
//  AppDelegate.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "AppDelegate.h"
#import "KDEPython.h"
#import "KDEPy80Context.h"
#import "KDEOutputView.h"
#import "KDEDocumentTracker.h"
#import "KDEExceptionView.h"
#import "KDEExceptionFormatter.h"
#import "KDEImageStore.h"

#import "SyntaxKit.h"

#import "KDEPyCompletion.h"
#import "KDEPyCallSignature.h"
#import "KDEPyException.h"
#import "KDEPyProfilerStat.h"
#import "KDEMainViewController.h"
#import "KDECompletionWindowController.h"
#import "KDEProfilerViewController.h"


typedef NS_ENUM( NSInteger, KDESaveAlertResponse)
{
    KDESaveAlertResponseSave,
    KDESaveAlertResponseDontSave,
    KDESaveAlertResponseCancel
};



@interface AppDelegate ()
<
    KDEPy80ContextDelegate,
    KDEDocumentTrackerDelegate
>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, readwrite, strong) KDEDocumentTracker *docTracker;
@property (nonatomic, readwrite, strong) NSDateFormatter *logDateFormatter;
@property (nonatomic, readwrite, strong) KDEImageStore *imageStore;
@property (nonatomic, readwrite, strong) KDEProfilerViewController *profilerViewController;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.titleVisibility = NSWindowTitleHidden;
    self.window.contentViewController = self.mainViewController;
    
    self.profilerViewController = [[KDEProfilerViewController alloc] initWithNibName:nil
                                                                              bundle:nil];
    
    [self.mainViewController presentViewControllerAsSheet:self.profilerViewController];
    
    // IB autosave name doesn't work with view controllers /shakes fist
    self.window.frameAutosaveName = @"Py80 Main Window";
    
    
    self.logDateFormatter = [NSDateFormatter new];
    self.logDateFormatter.dateFormat = @"dd-MM-YY HH:mm:ss.SSS";
    
    self.imageStore = [KDEImageStore new];
    
    self.docTracker = [[KDEDocumentTracker alloc] initWithDocumentExtensions:@[ @"py"]
                                                          userDefaultsPrefix:@"py_"
                                                                    delegate:self];
    [self.docTracker checkUserDefaultsForPreviousActiveFile];
    
    [KDEPy80Context sharedContext].delegate = self;
    
    self.runButton.enabled = NO;
    self.infoField.stringValue = @"Initializing Python...";
    [[KDEPython sharedPython] setupEnvironmentWithCompletion:^(BOOL result){
        self.runButton.enabled = YES;
        [self updateInfoField];
    }];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender
{
    if( self.docTracker.activeFileNeedsSaving)
    {
        KDESaveAlertResponse response = [self runModalSaveAlert];
        
        if( response == KDESaveAlertResponseSave)
        {
            return [self.docTracker saveDocumentForWindow:self.window] ? NSTerminateNow : NSTerminateCancel;
        }
        else if( response == KDESaveAlertResponseCancel)
        {
            return NSTerminateCancel;
        }
    }
    
    return NSTerminateNow;
}

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
    if( self.profilerViewController.presentingViewController != nil)
    {
        return NO;
    }
    
    if( menuItem.action == @selector(runCode:))
    {
        return [KDEPython sharedPython].isInitialized;
    }
    else if( menuItem.action == @selector(profileCode:))
    {
        return [KDEPython sharedPython].isInitialized;
    }
    else if( menuItem.action == @selector(saveDocument:))
    {
        return self.docTracker.activeFileIsNew || self.docTracker.activeFileNeedsSaving;
    }
    else if( menuItem.action == @selector(saveDocumentAs:))
    {
        return self.docTracker.activeFileIsNew == NO;
    }
    else if( menuItem.action == @selector(revertDocumentToSaved:))
    {
        return self.docTracker.activeFileIsNew == NO && self.docTracker.activeFileNeedsSaving;
    }
    else if( menuItem.action == @selector(resetOutputMagnification:))
    {
        return self.mainViewController.outputView.enclosingScrollView.magnification != 1.0f;
    }
    else if( menuItem.action == @selector(saveOutputContents:))
    {
        return self.mainViewController.outputView.hasContent;
    }
    else if( menuItem.action == @selector(openPreviousDocument:))
    {
        return [[NSDocumentController sharedDocumentController] recentDocumentURLs].count > 1;
    }
    
    return [[NSApplication sharedApplication] validateMenuItem:menuItem];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [self.docTracker writeActiveFileToUserDefaults];
}

- (IBAction)newDocument:(id)sender
{
    [self.docTracker newDocument];
}

- (IBAction)openDocument:(id)sender
{
    [self.docTracker openDocumentForWindow:self.window];
}

- (IBAction)saveDocument:(id)sender
{
    [self.docTracker saveDocumentForWindow:self.window];
}

- (IBAction)saveDocumentAs:(id)sender
{
    [self.docTracker saveDocumentAsForWindow:self.window];
}

- (IBAction)revertDocumentToSaved:(id)sender
{
    [self.docTracker revertDocumentToSaved];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    BOOL isDirectory;
    if( [filename.pathExtension isEqualToString:@"py"] &&
        [[NSFileManager defaultManager] fileExistsAtPath:filename isDirectory:&isDirectory] &&
        isDirectory == NO)
    {
        [self.docTracker openDocumentAtPath:filename];
        return YES;
    }
    
    return NO;
}

- (IBAction) runCode:(id)sender
{
    [self.imageStore reset];
    self.mainViewController.exceptionView.hidden = YES;
    [[KDEPython sharedPython] loadModuleFromSourceString:self.mainViewController.codeView.string
                                             runFunction:@"main"
                                                 profile:NO];
}

- (IBAction) profileCode:(id)sender
{
    [self.imageStore reset];
    self.mainViewController.exceptionView.hidden = YES;
    [[KDEPython sharedPython] loadModuleFromSourceString:self.mainViewController.codeView.string
                                             runFunction:@"main"
                                                 profile:YES];
}

- (IBAction) resetOutputMagnification:(id)sender
{
    self.mainViewController.outputView.enclosingScrollView.animator.magnification = 1.0f;
}

- (IBAction) saveOutputContents:(id)sender
{
    [self.mainViewController saveOutputContents:sender];
}

- (IBAction) openPreviousDocument:(id)sender
{
    NSArray *urls = [[NSDocumentController sharedDocumentController] recentDocumentURLs];;
    if( urls.count > 1)
    {
        NSURL *url = urls[1];
        [self.docTracker openDocumentAtPath:url.filePathURL.path];
    }
}

- (IBAction) insertPath:(id)sender
{
    [self.mainViewController insertPath:sender];
}

- (void) updateInfoField
{
    if( [KDEPython sharedPython].isInitialized)
    {
        NSString *fileName = self.docTracker.activeFilePath.lastPathComponent;
        NSString *fileStatus = self.docTracker.activeFileNeedsSaving ? @"*" : @"";
        self.infoField.stringValue = [NSString stringWithFormat:@"Py80: %@ %@", fileName, fileStatus];
    }
}

- (KDESaveAlertResponse) runModalSaveAlert
{
    NSAlert *alert = [NSAlert new];
    alert.messageText = [NSString stringWithFormat:@"Do you want to save the changes made to \"%@\"?", self.docTracker.activeFilePath.lastPathComponent];
    alert.informativeText = @"Your changes will be lost if you don't save them.";
    [alert addButtonWithTitle:@"Save"];
    [alert addButtonWithTitle:@"Don't save"];
    [alert addButtonWithTitle:@"Cancel"];
    
    switch( [alert runModal])
    {
        case NSAlertFirstButtonReturn: return KDESaveAlertResponseSave;
        case NSAlertSecondButtonReturn: return KDESaveAlertResponseDontSave;
        default:
        case NSAlertThirdButtonReturn: return KDESaveAlertResponseCancel;
    }
}

#pragma mark - KDEDocumentTrackerDelegate

- (void) documentTrackerActiveFileNeedsSaveDidChange:(KDEDocumentTracker *)tracker
{
    [self updateInfoField];
}

- (void) documentTrackerActiveFileDidChange:(KDEDocumentTracker *)tracker
{
    NSString *path = tracker.activeFileIsNew ? [[NSBundle mainBundle] pathForResource:@"Default" ofType:@"py"] :
                                               tracker.activeFilePath;
    
    self.mainViewController.codeView.string = [NSString stringWithContentsOfFile:path
                                                                        encoding:NSUTF8StringEncoding
                                                                           error:NULL];
    [self updateInfoField];
}

- (BOOL) documentTrackerActiveFileNeedingSaveCanChange:(KDEDocumentTracker *)tracker
{
    KDESaveAlertResponse response = [self runModalSaveAlert];
    BOOL canChange = response == KDESaveAlertResponseSave || response == KDESaveAlertResponseDontSave;
    
    if( response == KDESaveAlertResponseSave)
    {
        return [tracker saveDocumentForWindow:self.window];
    }
    
    return canChange;
}

- (BOOL) documentTrackerActiveFileNeedingSaveCanRevert:(KDEDocumentTracker *)tracker
{
    NSAlert *alert = [NSAlert new];
    alert.messageText = [NSString stringWithFormat:@"Do you want to revert \"%@\" to the last saved version?", self.docTracker.activeFilePath.lastPathComponent];
    alert.informativeText = @"Your unsaved changes will be lost if you choose to revert.";
    [alert addButtonWithTitle:@"Revert"];
    [alert addButtonWithTitle:@"Cancel"];
    
    return [alert runModal] == NSAlertFirstButtonReturn;
}

- (BOOL) documentTrackerSaveActiveFile:(KDEDocumentTracker *)tracker
{
    BOOL success = [self.mainViewController.codeView.string writeToFile:tracker.activeFilePath
                                                             atomically:YES
                                                               encoding:NSUTF8StringEncoding
                                                                  error:NULL];
    [self updateInfoField];
    
    return success;
}

#pragma mark - ASKSyntaxViewControllerDelegate

- (void) syntaxViewControllerTextDidChange:(ASKSyntaxViewController *)controller
{
    [self.docTracker markActiveFileAsNeedingSave];
}

- (NSMenu *)textView:(NSTextView *)view menu:(NSMenu *)menu forEvent:(NSEvent *)event atIndex:(NSUInteger)charIndex
{
    [menu insertItem:[NSMenuItem separatorItem]
             atIndex:0];
    [menu insertItemWithTitle:@"Insert path..."
                       action:@selector(insertPath:)
                keyEquivalent:@""
                      atIndex:0];
    
    return menu;
}

#pragma mark - KDEPy80ContextDelegate

- (void) py80Context:(KDEPy80Context *)context logMessage:(NSString *)message
{
    NSString *date = [self.logDateFormatter stringFromDate:[NSDate date]];
    NSString *formattedMessage = [NSString stringWithFormat:@"%@ %@\n", date, message];

    NSFont *font = [NSFont fontWithName:@"Monaco"
                                   size:11.0f];
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:formattedMessage
                                                                               attributes:@{ NSFontAttributeName : font }];
    [output addAttributes:@{ NSForegroundColorAttributeName : [NSColor grayColor] }
                    range:NSMakeRange( 0, date.length)];
    
    [self.mainViewController.console.textStorage appendAttributedString:output];
}

- (void) py80ContextClearLog:(KDEPy80Context *)context
{
    self.mainViewController.console.string = @"";
}

- (NSString *) py80ContextGetClipboard:(KDEPy80Context *)context
{
    NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
    NSArray *classes = @[ [NSString class]];
    
    if( [pasteboard canReadObjectForClasses:classes
                                    options:@{}])
    {
        return [pasteboard readObjectsForClasses:classes
                                         options:@{}][0];
    }
    
    return nil;
}

- (void) py80Context:(KDEPy80Context *)context
        setClipboard:(NSString *)string
{
    [[NSPasteboard generalPasteboard] clearContents];
    [[NSPasteboard generalPasteboard] writeObjects:@[ [NSString stringWithString:string]]];
}

- (void) py80ContextClearDrawing:(KDEPy80Context *)context
{
    [self.mainViewController.outputView clear];
}

- (void) py80Context:(KDEPy80Context *)context
        setStrokeRed:(CGFloat)red
               green:(CGFloat)green
                blue:(CGFloat)blue
               alpha:(CGFloat)alpha
{
    self.mainViewController.outputView.strokeColor = [NSColor colorWithDeviceRed:red
                                                                           green:green
                                                                            blue:blue
                                                                           alpha:alpha];
}

- (void) py80Context:(KDEPy80Context *)context
          setFillRed:(CGFloat)red
               green:(CGFloat)green
                blue:(CGFloat)blue
               alpha:(CGFloat)alpha
{
    self.mainViewController.outputView.fillColor = [NSColor colorWithDeviceRed:red
                                                                         green:green
                                                                          blue:blue
                                                                         alpha:alpha];
}

- (void) py80Context:(KDEPy80Context *)context
      setStrokeWidth:(CGFloat)width
{
    self.mainViewController.outputView.strokeWidth = width;
}

- (void) py80Context:(KDEPy80Context *)context
             setFont:(NSString *)fontName
                size:(CGFloat)size
{
    [self.mainViewController.outputView setFontName:fontName
                                               size:size];
}

- (void) py80Context:(KDEPy80Context *)context
         drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height
{
    [self.mainViewController.outputView addRectangle:NSMakeRect( x, y, width, height)];
}

- (void) py80Context:(KDEPy80Context *)context
   drawOvalInRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height
{
    [self.mainViewController.outputView addOval:NSMakeRect( x, y, width, height)];
}

- (void) py80Context:(KDEPy80Context *)context
            drawText:(NSString *)text
                 atX:(CGFloat)x
                   y:(CGFloat)y
{
    [self.mainViewController.outputView addText:text
                                        atPoint:NSMakePoint( x, y)];
}

- (void) py80Context:(KDEPy80Context *)context
           drawImage:(NSInteger)imageID
                 atX:(CGFloat)x
                   y:(CGFloat)y
{
    NSImage *image = [self.imageStore getImage:imageID];
    if( image)
    {
        NSRect rect = NSMakeRect( x, y, image.size.width, image.size.height);
        [self.mainViewController.outputView addImage:image
                                              inRect:rect];
    }
}

- (void) py80Context:(KDEPy80Context *)context
           drawImage:(NSInteger)imageID
           inRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height
{
    NSImage *image = [self.imageStore getImage:imageID];
    if( image)
    {
        NSRect rect = NSMakeRect( x, y, width, height);
        [self.mainViewController.outputView addImage:image
                                              inRect:rect];
    }
}

- (NSUInteger) py80Context:(KDEPy80Context *)context
                 loadImage:(NSString *)path
{
    return [self.imageStore addImageAtPath:path];
}

- (NSUInteger) py80Context:(KDEPy80Context *)context
      createImageWithBytes:(NSData *)data
                     width:(NSInteger)width
                    height:(NSInteger)height
{
    return [self.imageStore addImageWithRGBABytes:data
                                            width:width
                                           height:height];
}

- (void) py80Context:(KDEPy80Context *)context
     reportException:(KDEPyException *)exception
{
    [self.mainViewController showException:exception];
}

- (void) py80Context:(KDEPy80Context *)context
  reportProfileStats:(NSArray *)stats
{
    [self.mainViewController presentViewControllerAsSheet:self.profilerViewController];
    return;
    
    for( KDEPyProfilerStat *stat in stats)
    {
        NSMutableString *message = [NSMutableString string];
        [message appendString:@"-------------"];
        [message appendFormat:@"\nName: %@", stat.name];
        [message appendFormat:@"\nisBuiltIn: %@", [stat.isBuiltIn boolValue] ? @"YES" : @"NO"];
        [message appendFormat:@"\ncallCount: %@", stat.callCount];
        [message appendFormat:@"\nrecallCount: %@", stat.recallCount];
        [message appendFormat:@"\ntotalTime: %@", stat.totalTime];
        [message appendFormat:@"\ninlineTime: %@", stat.inlineTime];
        if( [stat.isBuiltIn boolValue] == NO)
        {
            [message appendFormat:@"\nfilename: %@", stat.filename];
            [message appendFormat:@"\nlineNumber: %@", stat.lineNumber];
        }
        [self py80Context:nil
               logMessage:message];
    }
}

@end
