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


@interface AppDelegate () <KDEPy80ContextDelegate>

@property (weak) IBOutlet NSWindow *window;
@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.titleVisibility = NSWindowTitleHidden;
    
    [self applyDefaultsToTextView:self.codeView];
    [self applyDefaultsToTextView:self.console];

    self.console.editable = NO;
    
    
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"Default"
                                                            ofType:@"py"];
    self.codeView.string = [NSString stringWithContentsOfFile:defaultPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    
    [KDEPy80Context sharedContext].delegate = self;
    
    [[KDEPython sharedPython] setupEnvironment];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
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
                                    size:13.0f];
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

@end
