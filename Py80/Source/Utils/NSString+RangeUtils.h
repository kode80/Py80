//
//  NSString+RangeUtils.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/28/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RangeUtils)

- (NSRange) expandRange:(NSRange)range
 withBoundaryCharacters:(NSCharacterSet *)boundaryCharacters;

- (NSRange) expandRangeLeft:(NSRange)range
     withBoundaryCharacters:(NSCharacterSet *)boundaryCharacters;

- (NSRange) expandRangeRight:(NSRange)range
      withBoundaryCharacters:(NSCharacterSet *)boundaryCharacters;

@end
