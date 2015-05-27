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

#import "KDEPyCompletion.h"
#import "KDEPyCallSignature.h"


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
    
    self.exceptionView.hidden = YES;
    [self.exceptionView addToTextView:self.codeView];
    
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
    else if( menuItem.action == @selector(resetOutputMagnification:))
    {
        return self.outputView.enclosingScrollView.magnification != 1.0f;
    }
    else if( menuItem.action == @selector(saveOutputContents:))
    {
        return self.outputView.hasContent;
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
    self.exceptionView.hidden = YES;
    [[KDEPython sharedPython] loadModuleFromSourceString:self.codeView.string
                                             runFunction:@"main"];
}

- (IBAction) resetOutputMagnification:(id)sender
{
    self.outputView.enclosingScrollView.animator.magnification = 1.0f;
}

- (IBAction) saveOutputContents:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[ @"png"];
    
    if( [panel runModal] == NSFileHandlingPanelOKButton)
    {
        NSBitmapImageRep *imageRep = [self.outputView bitmapImageRepForCachingDisplayInRect:self.outputView.bounds];
        [self.outputView cacheDisplayInRect:self.outputView.bounds
                           toBitmapImageRep:imageRep];
        
        NSData *data = [imageRep representationUsingType:NSPNGFileType
                                              properties:nil];
        [data writeToFile:panel.URL.filePathURL.path
               atomically:YES];
    }
}


- (IBAction) printCompletions:(id)sender
{
    NSString *source = self.codeView.string;
    const NSRange cursorRange = NSMakeRange( self.codeView.selectedRange.location, 0);
    NSRange currentRange = NSMakeRange( 0, 0);
    NSRange lineRange = [source lineRangeForRange:currentRange];

    NSInteger lineNumber = 1;
    
    while( lineRange.location < cursorRange.location &&
           NSMaxRange( lineRange) < cursorRange.location &&
           NSMaxRange( currentRange) < source.length)
    {
        lineNumber++;
        currentRange.location = NSMaxRange( lineRange);
        lineRange = [source lineRangeForRange:currentRange];
    }
    
    NSInteger columnNumber = (cursorRange.location - lineRange.location);
    
    NSCharacterSet *newLineChars = [NSCharacterSet newlineCharacterSet];
    unichar characterAtCursor = cursorRange.location < source.length ? [source characterAtIndex:cursorRange.location] : 0;
    unichar characterBeforeCursor = cursorRange.location > 0 ? [source characterAtIndex:cursorRange.location - 1] : 0;

    BOOL beforeIsNewLine = [newLineChars characterIsMember:characterBeforeCursor];
    BOOL cursorIsNewLine = [newLineChars characterIsMember:characterAtCursor];
    
    if( (beforeIsNewLine && cursorIsNewLine == NO) ||
        (beforeIsNewLine && cursorIsNewLine))
    {
        lineNumber++;
        columnNumber = 0;
    }
    
    
    [self py80ContextClearLog:nil];
    
    id script = [[KDEPython sharedPython] completionsForSourceString:source
                                                                line:lineNumber
                                                              column:columnNumber];
    NSArray *rawArray = script;
    
    NSMutableArray *signatures = [NSMutableArray array];
    NSMutableArray *completions = [NSMutableArray array];
    
    for( id obj in rawArray)
    {
        if( [obj isKindOfClass:[KDEPyCompletion class]])
        {
            [completions addObject:obj];
        }
        else if( [obj isKindOfClass:[KDEPyCallSignature class]])
        {
            [signatures addObject:obj];
        }
    }
    
    if( signatures.count)
    {
        for( KDEPyCallSignature *sig in signatures)
        {
            NSMutableString *func = [NSMutableString stringWithFormat:@"%@(", sig.name];
            int index = [sig.argIndex intValue];
            int i = 0;
            for( NSString *p in sig.argNames)
            {
                [func appendString:@" "];
                if( i == index) { [func appendString:@"["]; }
                [func appendString:p];
                if( i == index) { [func appendString:@"]"]; }
                if( i + 1 < sig.argNames.count) { [func appendString:@","]; }
                
                i++;
            }
            [func appendString:@")"];
            
            [self py80Context:nil logMessage:func];
        }
    }

    NSMutableDictionary *completionDictionary = [NSMutableDictionary dictionary];
    NSMutableArray *types;
    NSString *type, *name, *complete;
    for( KDEPyCompletion *completion in completions)
    {
        type = completion.type;
        name = completion.name;
        complete = completion.complete;
        
        types = completionDictionary[ type];
        if( types == nil)
        {
            types = [NSMutableArray array];
            completionDictionary[ type] = types;
        }
        
        name = [name stringByReplacingOccurrencesOfString:complete
                                               withString:[NSString stringWithFormat:@"[%@]", complete]];
        
        if( [type isEqualToString:@"function"])
        {
            name = [name stringByAppendingString:@" ("];
            
            for( NSString *param in completion.argNames)
            {
                name = [name stringByAppendingFormat:@" %@,", param];
            }
            
            if( completion.argNames.count)
            {
                name = [name substringToIndex:name.length - 1];
            }
            
            name = [name stringByAppendingString:@")"];
        }
        
        [types addObject:name];
    }
    
    NSMutableString *log = [NSMutableString stringWithString:@"\nCompletions:"];
    for( type in completionDictionary)
    {
        [log appendFormat:@"\n\nType(%@):", type];
        for( NSString *completionName in completionDictionary[ type])
        {
            [log appendFormat:@"\n%@",completionName];
        }
    }
    
    [self py80Context:nil logMessage:log];

    
    lineRange = NSMakeRange( lineRange.location, cursorRange.location - lineRange.location);
    NSRange glyphRange = [self.codeView.layoutManager glyphRangeForCharacterRange:lineRange
                                                             actualCharacterRange:NULL];
    NSRect lineRect = [self.codeView.layoutManager boundingRectForGlyphRange:glyphRange
                                                             inTextContainer:self.codeView.textContainer];
    lineRect.origin.x += lineRect.size.width - 1;
    lineRect.size.width = 2;
    [self.popover showRelativeToRect:lineRect
                              ofView:self.codeView
                       preferredEdge:NSMaxYEdge];
}

- (IBAction) insertPath:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = nil;
    panel.allowsMultipleSelection = NO;
    panel.canChooseDirectories = YES;

    if( [panel runModal] == NSFileHandlingPanelOKButton)
    {
        [self.codeView insertText:panel.URL.filePathURL.path];
    }
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
    
    [self.console.textStorage appendAttributedString:output];
}

- (void) py80ContextClearLog:(KDEPy80Context *)context
{
    self.console.string = @"";
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

- (void) py80Context:(KDEPy80Context *)context
      setStrokeWidth:(CGFloat)width
{
    self.outputView.strokeWidth = width;
}

- (void) py80Context:(KDEPy80Context *)context
             setFont:(NSString *)fontName
                size:(CGFloat)size
{
    [self.outputView setFontName:fontName
                            size:size];
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
   drawOvalInRectAtX:(CGFloat)x
                   y:(CGFloat)y
           withWidth:(CGFloat)width
              height:(CGFloat)height
{
    [self.outputView addOval:NSMakeRect( x, y, width, height)];
}

- (void) py80Context:(KDEPy80Context *)context
            drawText:(NSString *)text
                 atX:(CGFloat)x
                   y:(CGFloat)y
{
    [self.outputView addText:text
                     atPoint:NSMakePoint( x, y)];
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
    [self printCompletions:nil];
}

@end
