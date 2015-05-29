//
//  KDEPyCompletion.h
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KDEPyCompletion : NSObject

@property (nonatomic, readwrite, strong) NSString *type;
@property (nonatomic, readwrite, strong) NSString *name;
@property (nonatomic, readwrite, strong) NSString *fullName;
@property (nonatomic, readwrite, strong) NSString *complete;
@property (nonatomic, readwrite, strong) NSString *docString;
@property (nonatomic, readonly, strong) NSArray *argNames;

- (void) addArgName:(NSString *)name;

@end
