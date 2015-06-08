//
//  KDETimer.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/8/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETimer.h"

@implementation KDETimer

+ (double) timeBlock:(void(^)())block
{
    if( block == nil)
    {
        return 0.0;
    }
    
    const uint64_t startTime = mach_absolute_time();
    block();
    const uint64_t endTime = mach_absolute_time();
    
    const uint64_t elapsedMTU = endTime - startTime;
    
    mach_timebase_info_data_t info;
    mach_timebase_info(&info);
    
    return ((double)elapsedMTU * (double)info.numer / (double)info.denom) / 1000000.0;
}

@end
