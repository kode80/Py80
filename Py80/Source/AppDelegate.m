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


@interface AppDelegate () <KDEPy80ContextDelegate>

@property (weak) IBOutlet NSWindow *window;
@property (nonatomic, readwrite, copy) NSString *currentFilePath;

@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.titleVisibility = NSWindowTitleHidden;
    
    [self applyDefaultsToTextView:self.codeView];
    [self applyDefaultsToTextView:self.console];

    self.console.editable = NO;
    
    
    NSString *code = [[NSUserDefaults standardUserDefaults] stringForKey:@"Py80Code"];
    if( code == nil)
    {
        NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"Default"
                                                                ofType:@"py"];
        code = [NSString stringWithContentsOfFile:defaultPath
                                         encoding:NSUTF8StringEncoding
                                            error:NULL];
    }
    self.codeView.string = code;
    self.currentFilePath = @"untitled.py";
    
    [KDEPy80Context sharedContext].delegate = self;
    
    self.runButton.enabled = NO;
    self.infoField.stringValue = @"Initializing Python...";
    [[KDEPython sharedPython] setupEnvironmentWithCompletion:^(BOOL result){
        self.runButton.enabled = YES;
        [self updateInfoField];
    }];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
    [[NSUserDefaults standardUserDefaults] setObject:self.codeView.string
                                              forKey:@"Py80Code"];
}

- (IBAction)newDocument:(id)sender
{
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"Default"
                                                            ofType:@"py"];
    self.codeView.string = [NSString stringWithContentsOfFile:defaultPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
}

- (IBAction)openDocument:(id)sender
{
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.allowedFileTypes = @[ @"py"];
    panel.allowsMultipleSelection = NO;
    panel.canChooseDirectories = NO;
    
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result){
                      if (result == NSFileHandlingPanelOKButton)
                      {
                          self.currentFilePath = panel.URL.filePathURL.path;
                          self.codeView.string = [NSString stringWithContentsOfFile:self.currentFilePath
                                                                           encoding:NSUTF8StringEncoding
                                                                              error:NULL];
                          [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:panel.URL.filePathURL];
                          [self updateInfoField];
                      }
                  }];
}

- (IBAction)saveDocument:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[ @"py"];
    panel.nameFieldStringValue = @"untitled.py";
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result){
                      if (result == NSFileHandlingPanelOKButton)
                      {
                          self.currentFilePath = panel.URL.filePathURL.path;
                          [self.codeView.string writeToURL:panel.URL.filePathURL
                                                atomically:YES
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
                          [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:panel.URL.filePathURL];
                          [self updateInfoField];
                      }
                  }];
}

- (IBAction)saveDocumentAs:(id)sender
{
    NSSavePanel *panel = [NSSavePanel savePanel];
    panel.allowedFileTypes = @[ @"py"];
    panel.nameFieldStringValue = @"untitled.py";
    [panel beginSheetModalForWindow:self.window
                  completionHandler:^(NSInteger result){
                      if (result == NSFileHandlingPanelOKButton)
                      {
                          self.currentFilePath = panel.URL.filePathURL.path;
                          [self.codeView.string writeToURL:panel.URL.filePathURL
                                                atomically:YES
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
                          [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL:panel.URL.filePathURL];
                          [self updateInfoField];
                      }
                  }];
}

- (BOOL)application:(NSApplication *)theApplication openFile:(NSString *)filename
{
    self.currentFilePath = filename;
    self.codeView.string = [NSString stringWithContentsOfFile:filename
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    [self updateInfoField];
    
    return YES;
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
    self.infoField.stringValue = [NSString stringWithFormat:@"Py80: %@", self.currentFilePath.lastPathComponent];
}

#pragma mark - KDEPy80ContextDelegate

- (void) py80Context:(KDEPy80Context *)context logMessage:(NSString *)message
{
    NSString *formattedMessage = [NSString stringWithFormat:@"%@: %@\n", [NSDate date], message];
    NSString *output = [self.console.string stringByAppendingString:formattedMessage];
    self.console.string = output;
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

@end
