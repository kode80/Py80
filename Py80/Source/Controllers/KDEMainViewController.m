//
//  KDEMainViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/3/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEMainViewController.h"
#import "KDEExceptionView.h"
#import "KDECodeView.h"
#import "KDEOutputView.h"
#import "KDEExceptionFormatter.h"
#import "KDEPyException.h"
#import "KDETheme.h"
#import "KDEPyTokenizer.h"
#import "KDEPy80Preferences.h"

#import "KDEConsoleViewController.h"


@interface KDEMainViewController ()
<
    NSTextViewDelegate
>

@property (nonatomic, readwrite, strong) KDEExceptionFormatter *exceptionFormatter;

@end


@implementation KDEMainViewController

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    // IB autosave names don't work with view controllers /shakes fist x2
    self.horizontalSplitView.autosaveName = @"Main Horizontal Split View";
    self.verticalSplitView.autosaveName = @"Main Vertical Split View";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self applyDefaultsToTextView:self.codeView];
    [self applyDefaultsToTextView:self.console];

    self.codeView.tokenizer = [KDEPyTokenizer new];
    KDETheme *theme = [[KDETheme alloc] initWithJSONAtPath:[KDEPy80Preferences sharedPreferences].currentThemePath];
    [self applyTheme:theme];
    
    self.console.editable = NO;
    
    self.exceptionView.hidden = YES;
    [self.exceptionView addToTextView:self.codeView];
    
    self.exceptionFormatter = [[KDEExceptionFormatter alloc] initWithTypeFont:[NSFont fontWithName:@"Monaco" size:10.0f]
                                                                    typeColor:[NSColor redColor]
                                                              descriptionFont:[NSFont fontWithName:@"Helvetica Neue" size:13.0f]
                                                             descriptionColor:[NSColor blackColor]
                                                                     infoFont:[NSFont fontWithName:@"Monaco" size:11.0f]
                                                                    infoColor:[NSColor blackColor]];
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

- (void) showException:(KDEPyException *)exception
{
    self.exceptionView.label.attributedStringValue = [self.exceptionFormatter attributedStringForException:exception];
    NSInteger lineNumber = exception.isExternal ? 1 : exception.lineNumber;
    
    // TODO: re-implement goto line/range for line in KDECodeView
    NSRange range = NSMakeRange( 0, 0);
    [self.exceptionView updateConstraintsForCharacterRange:range];
    
    self.exceptionView.hidden = NO;
}

- (void) applyTheme:(KDETheme *)theme
{
    self.codeView.backgroundColor = [theme colorForItemName:@"CodeBackground"];
    self.codeView.theme = theme;
    self.outputView.enclosingScrollView.backgroundColor = [theme colorForItemName:@"OutputBackground"];
    [self.consoleViewController applyTheme:theme];
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

#pragma mark - ASKSyntaxViewControllerDelegate

- (void) textDidChangeInCodeView:(KDECodeView *)codeView
{
    if( [self.delegate respondsToSelector:@selector(codeDidChangeInMainViewController:)])
    {
        [self.delegate codeDidChangeInMainViewController:self];
    }
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

- (void) textViewDidChangeSelection:(NSNotification *)notification
{
    self.exceptionView.hidden = YES;
}

@end
