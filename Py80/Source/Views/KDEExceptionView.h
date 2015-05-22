//
//  KDEExceptionView.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/22/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KDEExceptionView : NSBox

@property (nonatomic, readwrite, weak) IBOutlet NSTextField *label;

@end
