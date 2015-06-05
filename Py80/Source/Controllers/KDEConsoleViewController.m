//
//  KDEConsoleViewController.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/5/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEConsoleViewController.h"
#import "KDEConsoleLog.h"


@interface KDEConsoleViewController ()

@property (nonatomic, readwrite, strong) NSArray *logs;
@property (nonatomic, readwrite, strong) NSDateFormatter *dateFormatter;

@end


@implementation KDEConsoleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.logs = @[];
    self.dateFormatter = [NSDateFormatter new];
    self.dateFormatter.dateFormat = @"dd-MM-YY HH:mm:ss.SSS";
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
    
    NSFont *font = [NSFont fontWithName:@"Monaco"
                                   size:11.0f];
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:formattedMessage
                                                                               attributes:@{ NSFontAttributeName : font }];
    [output addAttributes:@{ NSForegroundColorAttributeName : [NSColor grayColor] }
                    range:NSMakeRange( 0, date.length)];
    return output;
}

@end
