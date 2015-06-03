//
//  KDEPyProfilerStat.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/3/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEPyProfilerStat : NSObject

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *filename;
@property (nonatomic, readwrite, strong) NSNumber *lineNumber;
@property (nonatomic, readwrite, strong) NSNumber *callCount;
@property (nonatomic, readwrite, strong) NSNumber *recallCount;
@property (nonatomic, readwrite, strong) NSNumber *inlineTime;
@property (nonatomic, readwrite, strong) NSNumber *totalTime;

@end
