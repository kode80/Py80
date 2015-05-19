//
//  KDEPython.m
//  Py80
//
//  Created by Benjamin S Hopkins on 5/18/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPython.h"
#import <Python/Python.h>
#import "KDEPy80Context.h"


@interface NSObject (KDEPythonLoader)

- (BOOL) loadModuleFromSourceString:(NSString*)sourceString
                       functionName:(NSString*)funcName;

@end


@implementation KDEPython

+ (KDEPython *) sharedPython
{
    static dispatch_once_t onceToken;
    static KDEPython *python = nil;
    dispatch_once(&onceToken, ^{
        python = [KDEPython new];
    });
    return python;
}

- (BOOL) setupEnvironment
{
    if( Py_IsInitialized())
    {
        return YES;
    }
    
    Py_SetProgramName( "/usr/bin/python");
    Py_Initialize();
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"KDEPythonLoader"
                                                     ofType:@"py"];
    FILE *file = fopen( [path UTF8String], "r");

    return PyRun_SimpleFileEx( file, [[path lastPathComponent] UTF8String], 1) == 0;;
}

- (BOOL) loadModuleFromSourceString:(NSString*)sourceString
                        runFunction:(NSString*)functionName
{
    Class loader = NSClassFromString(@"KDEPythonLoader");
    
    return [loader loadModuleFromSourceString:sourceString
                                 functionName:functionName];
}

- (void) test
{
    NSLog(@"Test from python -> objc");
}

@end
