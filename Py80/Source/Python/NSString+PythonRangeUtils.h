//
//  NSString+PythonRangeUtils.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/29/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (PythonRangeUtils)

- (NSRange) jumpLeftToNextPythonBoundary:(NSRange)originalRange;
- (NSRange) jumpRightToNextPythonBoundary:(NSRange)originalRange;

- (NSRange) expandSelectionLeftToNextPythonBoundary:(NSRange)originalRange;
- (NSRange) expandSelectionRightToNextPythonBoundary:(NSRange)originalRange;

@end
