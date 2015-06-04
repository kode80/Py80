//
//  KDETheme.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/4/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import "KDETheme.h"
#import "KDEThemeItem.h"


@interface KDETheme ()

@property (nonatomic, readwrite, strong) NSMutableDictionary *items;

@end


@implementation KDETheme

- (instancetype) init
{
    self = [super init];
    if( self)
    {
        self.items = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [self init];
    if( self)
    {
        for( NSString *key in dictionary)
        {
            self.items[ key] = [[KDEThemeItem alloc] initWithDictionary:dictionary[ key]];
        }
    }
    return self;
}

- (NSDictionary *) dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for( NSString *key in self.items)
    {
        dictionary[ key] = [self.items[ key] dictionary];
    }
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSColor *) colorForItemName:(NSString *)name
{
    return [self itemForName:name
              createIfNeeded:NO].color;
}

- (NSFont *) fontForItemName:(NSString *)name
{
    return [self itemForName:name
              createIfNeeded:NO].font;
}

- (void) setColor:(NSColor *)color
      forItemName:(NSString *)name
{
    [self itemForName:name
       createIfNeeded:YES].color = color;
}

- (void) setFont:(NSFont *)font
     forItemName:(NSString *)name
{
    [self itemForName:name
       createIfNeeded:YES].font = font;
}

#pragma mark - private

- (KDEThemeItem *) itemForName:(NSString *)name
                createIfNeeded:(BOOL)createIfNeeded
{
    KDEThemeItem *item = self.items[ name];
    if( item == nil && createIfNeeded)
    {
        item = [KDEThemeItem new];
        self.items[ name] = item;
    }
    return item;
}

@end
