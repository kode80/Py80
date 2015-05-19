//
//  AppDelegate.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "AppDelegate.h"
#import "KDEPython.h"


@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.window.titleVisibility = NSWindowTitleHidden;
    
    
    self.codeView.automaticQuoteSubstitutionEnabled = NO;
    self.codeView.automaticDashSubstitutionEnabled = NO;
    self.codeView.automaticTextReplacementEnabled = NO;
    self.codeView.automaticSpellingCorrectionEnabled = NO;
    self.codeView.font = [NSFont fontWithName:@"Monaco"
                                         size:13.0f];
    
    NSString *defaultPath = [[NSBundle mainBundle] pathForResource:@"Default"
                                                            ofType:@"py"];
    self.codeView.string = [NSString stringWithContentsOfFile:defaultPath
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    
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

@end
