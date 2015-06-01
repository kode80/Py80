//
//  KDEPyException.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/1/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEPyException : NSObject

@property (nonatomic, readonly, assign) BOOL isExternal;
@property (nonatomic, readonly, strong) NSString *type;
@property (nonatomic, readonly, strong) NSString *exceptionDescription;
@property (nonatomic, readonly, strong) NSString *filePath;
@property (nonatomic, readonly, strong) NSString *function;
@property (nonatomic, readonly, assign) NSInteger lineNumber;

- (instancetype) initWithType:(NSString *)type
                  description:(NSString *)description
                     filePath:(NSString *)filePath
                     function:(NSString *)function
                   lineNumber:(NSInteger)lineNumber;
@end
