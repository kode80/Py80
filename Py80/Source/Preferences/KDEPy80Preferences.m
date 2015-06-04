//
//  KDEPy80Preferences.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPy80Preferences.h"

@implementation KDEPy80Preferences

+ (KDEPy80Preferences *) sharedPreferences
{
    static KDEPy80Preferences *preferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preferences = [KDEPy80Preferences new];
    });
    return preferences;
}

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        [KDEPy80Preferences createFolderIfDoesntExist:[KDEPy80Preferences userPy80ApplicationSupportPath]];
        [KDEPy80Preferences createFolderIfDoesntExist:[KDEPy80Preferences themesPath]];
        
    }
    return self;
}

#pragma mark - Accessors

- (void) setCurrentThemePath:(NSString *)currentThemePath
{
    [[NSUserDefaults standardUserDefaults] setObject:currentThemePath
                                              forKey:@""];
}

#pragma mark - Private


+ (NSString *) themesPath
{
    return [[KDEPy80Preferences userPy80ApplicationSupportPath] stringByAppendingPathComponent:@"Themes"];
}

+ (NSString *) userPy80ApplicationSupportPath
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                           inDomains:NSUserDomainMask];
    NSURL *url = urls.firstObject;
    return [url.filePathURL.path stringByAppendingPathComponent:@"Py80"];
}

+ (void) createFolderIfDoesntExist:(NSString *)path
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if( [manager fileExistsAtPath:path] == NO)
    {
        [manager createDirectoryAtPath:path
           withIntermediateDirectories:NO
                            attributes:nil
                                 error:NULL];
    }
}

@end
