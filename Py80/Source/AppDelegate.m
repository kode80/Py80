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

#import "SyntaxKit.h"


typedef NS_ENUM( NSInteger, KDESaveAlertResponse)
{
    KDESaveAlertResponseSave,
    KDESaveAlertResponseDontSave,
    KDESaveAlertResponseCancel
};



@interface AppDelegate ()
<
    KDEPy80ContextDelegate,
    KDEDocumentTrackerDelegate,
    ASKSyntaxViewControllerDelegate,
    NSTextViewDelegate
>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, readwrite, strong) KDEDocumentTracker *docTracker;
@property (nonatomic, readwrite, strong) NSDateFormatter *logDateFormatter;
@property (nonatomic, readwrite, strong) KDEExceptionFormatter *exceptionFormatter;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.titleVisibility = NSWindowTitleHidden;
    
    [self applyDefaultsToTextView:self.codeView];
    [self applyDefaultsToTextView:self.console];

    self.console.editable = NO;
    
    self.logDateFormatter = [NSDateFormatter new];
    self.logDateFormatter.dateFormat = @"dd-MM-YY HH:mm:ss.SSS";
    
    self.exceptionFormatter = [[KDEExceptionFormatter alloc] initWithTypeFont:[NSFont fontWithName:@"Monaco" size:10.0f]
                                                                    typeColor:[NSColor redColor]
                                                              descriptionFont:[NSFont fontWithName:@"Helvetica Neue" size:13.0f]
                                                             descriptionColor:[NSColor blackColor]
                                                                     infoFont:[NSFont fontWithName:@"Monaco" size:11.0f]
                                                                    infoColor:[NSColor blackColor]];
    
    self.syntaxViewController.indentsWithSpaces = NO;
    self.syntaxViewController.showsLineNumbers = YES;
    self.syntaxViewController.syntax = [ASKSyntax syntaxForType:@"public.python-source"];
    self.syntaxViewController.delegate = self;
    
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
    
    self.exceptionView.hidden = YES;
    [self.exceptionView addToTextView:self.codeView];
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
    if( menuItem.action == @selector(saveDocument:))
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
    [[KDEPython sharedPython] loadModuleFromSourceString:self.codeView.string
                                             runFunction:@"main"];
}

- (void) applyDefaultsToTextView:(NSTextView *)textView
{
    textView.automaticQuoteSubstitutionEnabled = NO;
    textView.automaticDashSubstitutionEnabled = NO;
    textView.automaticTextReplacementEnabled = NO;
    textView.automaticSpellingCorrectionEnabled = NO;
    textView.font = [NSFont fontWithName:@"Monaco"
                                    size:11.0f];
}

- (void) updateInfoField
{
    NSString *fileName = self.docTracker.activeFilePath.lastPathComponent;
    NSString *fileStatus = self.docTracker.activeFileNeedsSaving ? @"*" : @"";
    self.infoField.stringValue = [NSString stringWithFormat:@"Py80: %@ %@", fileName, fileStatus];
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
    
    self.codeView.string = [NSString stringWithContentsOfFile:path
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
    BOOL success = [self.codeView.string writeToFile:tracker.activeFilePath
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
    
    [self.console.textStorage appendAttributedString:output];
}

- (void) py80ContextClearLog:(KDEPy80Context *)context
{
    self.console.string = @"";
}

- (void) py80ContextClearDrawing:(KDEPy80Context *)context
{
    [self.outputView clear];
}

- (void) py80Context:(KDEPy80Context *)context
        setStrokeRed:(CGFloat)red
               green:(CGFloat)green
                blue:(CGFloat)blue
               alpha:(CGFloat)alpha
{
    self.outputView.strokeColor = [NSColor colorWithDeviceRed:red
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
    self.outputView.fillColor = [NSColor colorWithDeviceRed:red
                                                      green:green
                                                       blue:blue
                                                      alpha:alpha];
}

- (void) py80Context:(KDEPy80Context *)context setStrokeWidth:(CGFloat)width
{
    self.outputView.strokeWidth = width;
}

- (void) py80Context:(KDEPy80Context *)context
         drawRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height
{
    [self.outputView addRectangle:NSMakeRect( x, y, width, height)];
}

- (void) py80Context:(KDEPy80Context *)context
 reportExceptionType:(NSString *)type
         description:(NSString *)description
            filePath:(NSString *)filePath
            function:(NSString *)function
          lineNumber:(NSInteger)lineNumber
{
    self.exceptionView.label.attributedStringValue = [self.exceptionFormatter attributedStringForExceptionType:type
                                                                                                   description:description
                                                                                                      filePath:filePath
                                                                                                      function:function
                                                                                                    lineNumber:lineNumber];
    
    lineNumber = [filePath isEqualToString:@"<string>"] ? lineNumber : 1;
    
    [self.syntaxViewController goToLine:lineNumber];
    NSRange range = [self.syntaxViewController rangeForLine:lineNumber];
    [self.exceptionView updateConstraintsForCharacterRange:range];
    
    self.exceptionView.hidden = NO;
}

- (void) textViewDidChangeSelection:(NSNotification *)notification
{
    self.exceptionView.hidden = YES;
}

@end
