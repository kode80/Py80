//
//  KDEPython.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEPython : NSObject

@property (nonatomic, readonly, assign) BOOL isInitialized;

+ (KDEPython *) sharedPython;

- (void) setupEnvironmentWithCompletion:(void(^)(BOOL result))completionBlock;
- (void) tearDown;

- (BOOL) loadModuleFromSourceString:(NSString*)sourceString
                        runFunction:(NSString*)functionName
                            profile:(BOOL)profile;

- (NSArray *) completionsForSourceString:(NSString *)source
                                    line:(NSInteger)line
                                  column:(NSInteger)column;

@end
