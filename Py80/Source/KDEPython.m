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


@interface KDEPython ()
@property (nonatomic, readwrite, assign) PyThreadState * mainThreadState;
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

- (void) setupEnvironmentWithCompletion:(void(^)(BOOL result))completionBlock
{
    if( Py_IsInitialized())
    {
        if( completionBlock)
        {
            dispatch_sync( dispatch_get_main_queue(), ^{
                completionBlock( YES);
            });
        }
        return;
    }
    
    Py_SetProgramName( "/usr/bin/python");
    Py_Initialize();
    
    PyEval_InitThreads();
    self.mainThreadState = PyThreadState_Get();
    PyEval_ReleaseLock();
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"KDEPythonLoader"
                                                         ofType:@"py"];
        
        // Create new thread state
        PyEval_AcquireLock();
        PyInterpreterState * mainInterpreterState = self.mainThreadState->interp;
        PyThreadState * newThreadState = PyThreadState_New(mainInterpreterState);
        PyEval_ReleaseLock();
        
        // Run KDEPythonLoader.py
        PyEval_AcquireLock();
        PyThreadState_Swap(newThreadState);
        
        FILE *file = fopen( [path UTF8String], "r");
        BOOL result = PyRun_SimpleFileEx( file, [[path lastPathComponent] UTF8String], 1);
        
        PyThreadState_Swap(NULL);
        PyEval_ReleaseLock();
        
        // Destroy new thread state
        PyEval_AcquireLock();
        PyThreadState_Swap(NULL);
        PyThreadState_Clear(newThreadState);
        PyThreadState_Delete(newThreadState);
        PyEval_ReleaseLock();
        
        if( completionBlock)
        {
            dispatch_sync( dispatch_get_main_queue(), ^{
                completionBlock( result);
            });
        }
    });
}

- (void) tearDown
{
    PyEval_AcquireLock();
    Py_Finalize();
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
