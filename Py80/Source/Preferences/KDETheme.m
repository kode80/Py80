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
@property (nonatomic, readwrite, strong) NSArray *itemNames;

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

- (instancetype) initWithJSONAtPath:(NSString *)jsonPath
{
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *dictionary = nil;
    
    if( data)
    {
        dictionary =[NSJSONSerialization JSONObjectWithData:data
                                                    options:0
                                                      error:NULL];
    }
    
    return dictionary ? [self initWithDictionary:dictionary] : nil;
}

- (void) writeJSONToPath:(NSString *)jsonPath
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self dictionary]
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:NULL];
    [data writeToFile:jsonPath
           atomically:YES];
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
        
        KDEThemeItem *item;
        for( NSString *name in self.items)
        {
            item = self.items[ name];
            if( item.duplicateItemName)
            {
                [item duplicateFromItem:self.items[ item.duplicateItemName]];
            }
        }
        
        [self updateItemNames];
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

- (NSDictionary *) textAttributesForItemName:(NSString *)name
{
    return [self itemForName:name
              createIfNeeded:NO].textAttributes;
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
        [self updateItemNames];
    }
    return item;
}

- (void) updateItemNames
{
    NSMutableArray *names = [NSMutableArray array];
    for( NSString *name in self.items)
    {
        if( [self.items[ name] duplicateItemName] == nil)
        {
            [names addObject:name];
        }
    }
    self.itemNames = [names copy];
}

@end
