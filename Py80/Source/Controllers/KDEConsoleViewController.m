//
//  KDEConsoleViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/5/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEConsoleViewController.h"
#import "KDEConsoleLog.h"
#import "KDETheme.h"


@interface KDEConsoleViewController ()

@property (nonatomic, readwrite, strong) NSArray *logs;
@property (nonatomic, readwrite, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, readwrite, strong) NSDictionary *logTimestampAttributes;
@property (nonatomic, readwrite, strong) NSDictionary *logMessageAttributes;

@end


@implementation KDEConsoleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logs = @[];
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateFormat = @"dd-MM-YY HH:mm:ss.SSS";
    
    self.logTimestampAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco"
                                                                           size:11.0f],
                                     NSForegroundColorAttributeName : [NSColor grayColor]};
    self.logMessageAttributes = @{ NSFontAttributeName : [NSFont fontWithName:@"Monaco"
                                                                         size:11.0f],
                                   NSForegroundColorAttributeName : [NSColor whiteColor]};
}

- (void) clearLogs
{
    self.logs = @[];
    [self viewAsTextView].string = @"";
}

- (void) logMessage:(NSString *)message
{
    KDEConsoleLog *log = [KDEConsoleLog logWithMessage:message];
    [self addLog:log];
    
    NSAttributedString *output = [self attributedStringForLog:log];
    [[self viewAsTextView].textStorage appendAttributedString:output];
}

- (void) applyTheme:(KDETheme *)theme
{
    if( theme)
    {
        [self viewAsTextView].backgroundColor = [theme colorForItemName:@"ConsoleBackground"];
        self.logTimestampAttributes = @{ NSFontAttributeName : [theme fontForItemName:@"ConsoleTimestamp"],
                                         NSForegroundColorAttributeName : [theme colorForItemName:@"ConsoleTimestamp"]};
        self.logMessageAttributes = @{ NSFontAttributeName : [theme fontForItemName:@"ConsoleText"],
                                       NSForegroundColorAttributeName : [theme colorForItemName:@"ConsoleText"]};
        
        [[self viewAsTextView].textStorage setAttributedString:[self attributedStringForAllLogs]];
    }
}

#pragma mark - Private

- (NSTextView *) viewAsTextView
{
    return (NSTextView *)self.view;
}

- (void) addLog:(KDEConsoleLog *)log
{
    self.logs = [self.logs arrayByAddingObject:log];
}

- (NSAttributedString *) attributedStringForLog:(KDEConsoleLog *)log
{
    NSString *date = [self.dateFormatter stringFromDate:log.date];
    NSString *formattedMessage = [NSString stringWithFormat:@"%@ %@\n", date, log.message];
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:formattedMessage
                                                                               attributes:self.logMessageAttributes];
    [output setAttributes:self.logTimestampAttributes
                    range:NSMakeRange( 0, date.length)];
    return output;
}

- (NSAttributedString *) attributedStringForAllLogs
{
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:@""];
    for( KDEConsoleLog *log in self.logs)
    {
        [output appendAttributedString:[self attributedStringForLog:log]];
    }
    return output;
}

@end
