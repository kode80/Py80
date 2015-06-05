//
//  KDEPy80Preferences.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDEPy80Preferences.h"

#import "KDETheme.h"


NSString * const KDEPy80PreferencesDefaultsKeyCurrentThemePath = @"com.kode80.Py80.CurrentThemePath";


@implementation KDEPy80Preferences

@dynamic currentThemePath;


+ (KDEPy80Preferences *) sharedPreferences
{
    static KDEPy80Preferences *preferences = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        preferences = [KDEPy80Preferences new];
        
    });
    return preferences;
}

- (void) appLaunchChecks
{
    [KDEPy80Preferences createFolderIfDoesntExist:[KDEPy80Preferences userPy80ApplicationSupportPath]];
    [KDEPy80Preferences createFolderIfDoesntExist:[KDEPy80Preferences themesPath]];
    [self copyDefaultThemesIfNeeded];
    
    if( self.currentThemePath == nil) { self.currentThemePath = [self pathsOfAvailableThemes].firstObject; }
}

- (NSArray *) pathsOfAvailableThemes
{
    NSString *themesPath = [KDEPy80Preferences themesPath];
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *files = [manager contentsOfDirectoryAtPath:[KDEPy80Preferences themesPath]
                                                  error:NULL];
    files = [files filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.json'"]];
    NSMutableArray *paths = [NSMutableArray array];
    for( NSString *file in files)
    {
        [paths addObject:[themesPath stringByAppendingPathComponent:file]];
    }
    return [NSArray arrayWithArray:paths];
}


- (void) saveTheme:(KDETheme *)theme
          withName:(NSString *)name
{
    if( theme)
    {
        [theme writeJSONToPath:[KDEPy80Preferences pathForThemeNamed:name]];
    }
}

- (BOOL) renameThemeNamed:(NSString *)themeName
                       to:(NSString *)newName
{
    NSString *oldPath = [KDEPy80Preferences pathForThemeNamed:themeName];
    NSString *newPath = [KDEPy80Preferences pathForThemeNamed:newName];
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL isDirectory;
    
    return [manager fileExistsAtPath:oldPath isDirectory:&isDirectory] &&
           isDirectory == NO &&
           [manager moveItemAtPath:oldPath
                            toPath:newPath
                             error:NULL];
}

#pragma mark - Accessors

- (NSString *) currentThemePath
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:KDEPy80PreferencesDefaultsKeyCurrentThemePath];
}

- (void) setCurrentThemePath:(NSString *)currentThemePath
{
    [[NSUserDefaults standardUserDefaults] setObject:currentThemePath
                                              forKey:KDEPy80PreferencesDefaultsKeyCurrentThemePath];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private

- (void) copyDefaultThemesIfNeeded
{
    if( [self pathsOfAvailableThemes].count == 0)
    {
        [self copyDefaultThemeNamed:@"Default"];
    }
}

- (void) copyDefaultThemeNamed:(NSString *)name
{
    NSString *filename = [name stringByAppendingPathExtension:@"json"];
    NSString *frompath = [[NSBundle mainBundle] pathForResource:name
                                                         ofType:@"json"
                                                    inDirectory:@"Themes"];
    NSString *toPath = [[KDEPy80Preferences themesPath] stringByAppendingPathComponent:filename];
    
    [[NSFileManager defaultManager] copyItemAtPath:frompath
                                            toPath:toPath
                                             error:NULL];
}

+ (NSString *) themesPath
{
    return [[KDEPy80Preferences userPy80ApplicationSupportPath] stringByAppendingPathComponent:@"Themes"];
}

+ (NSString *) userPy80ApplicationSupportPath
{
    NSArray *urls = [[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory
                                                           inDomains:NSUserDomainMask];
    NSURL *url = urls.firstObject;
    return [url.filePathURL.path stringByAppendingPathComponent:@"com.kode80.Py80"];
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

+ (NSString *) pathForThemeNamed:(NSString *)name
{
    NSString *filename = [name stringByAppendingPathExtension:@"json"];
    return [[KDEPy80Preferences themesPath] stringByAppendingPathComponent:filename];
}

@end
