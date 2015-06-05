//
//  KDEPy80Preferences.h
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KDETheme;

@interface KDEPy80Preferences : NSObject

@property (nonatomic, readwrite, strong) NSString *currentThemePath;

+ (KDEPy80Preferences *) sharedPreferences;

- (void) appLaunchChecks;

- (NSArray *) pathsOfAvailableThemes;
- (KDETheme *) loadThemeNamed:(NSString *)name;
- (void) saveTheme:(KDETheme *)theme
          withName:(NSString *)name;
- (BOOL) renameThemeNamed:(NSString *)themeName
                       to:(NSString *)newName;
- (void) duplicateThemeNamed:(NSString *)name;
- (void) deleteThemeNamed:(NSString *)name;

@end