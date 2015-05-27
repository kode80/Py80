//
//  KDEPyCallSignature.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/27/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPyCallSignature.h"


@interface KDEPyCallSignature ()

@property (nonatomic, readwrite, strong) NSArray *argNames;

@end


@implementation KDEPyCallSignature

- (void) addArgName:(NSString *)name
{
    self.argNames = self.argNames ? [self.argNames arrayByAddingObject:name] : @[ name];
}

@end
