//
//  KDEProfilerViewController.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/3/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@protocol KDEProfilerViewControllerDelegate;
@class KDEPyProfilerStat;


@interface KDEProfilerViewController : NSViewController <NSTableViewDataSource, NSTableViewDelegate>

@property (nonatomic, readwrite, weak) id<KDEProfilerViewControllerDelegate> delegate;
@property (nonatomic, readwrite, weak) IBOutlet NSTableView *table;
@property (nonatomic, readwrite, copy) NSArray *stats;

- (IBAction) tableDidDoubleClick:(id)sender;

@end


@protocol KDEProfilerViewControllerDelegate <NSObject>

- (void) profilerViewController:(KDEProfilerViewController *)viewController
             didDoubleClickStat:(KDEPyProfilerStat *)stat;

@end