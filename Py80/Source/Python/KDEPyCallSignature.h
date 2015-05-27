//
//  KDEPyCallSignature.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEPyCallSignature : NSObject

@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readonly, strong) NSArray *argNames;
@property (nonatomic, readwrite, strong) NSNumber *argIndex;

- (void) addArgName:(NSString *)name;

@end
