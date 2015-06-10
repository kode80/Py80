//
//  NSRangeUtils.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/10/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#ifndef Py80_NSRangeUtils_h
#define Py80_NSRangeUtils_h

#import <Foundation/NSValue.h>
#import <Foundation/NSObjCRuntime.h>

NS_INLINE BOOL NSRangeOverlapsRange( NSRange rangeA, NSRange rangeB)
{
    return rangeA.location != NSNotFound &&
           rangeB.location != NSNotFound &&
           NSMaxRange( rangeA) > rangeB.location && rangeA.location < NSMaxRange( rangeB);
}

#endif
