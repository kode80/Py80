//
//  NSRangeUtilsTests.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/10/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "NSRangeUtils.h"

@interface NSRangeUtilsTests : XCTestCase

@end

@implementation NSRangeUtilsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testPerformanceExample
{
    // Test overlapping ranges
    BOOL result = NSRangeOverlapsRange( NSMakeRange( 0, 5), NSMakeRange( 0, 5));
    XCTAssertTrue( result, @"Ranges should overlap");
    
    result = NSRangeOverlapsRange( NSMakeRange( 0, 5), NSMakeRange( 4, 1));
    XCTAssertTrue( result, @"Ranges should overlap");
    
    result = NSRangeOverlapsRange( NSMakeRange( 5, 10), NSMakeRange( 0, 6));
    XCTAssertTrue( result, @"Ranges should overlap");
    
    
    // Test non overlapping ranges
    result = NSRangeOverlapsRange( NSMakeRange( 0, 0), NSMakeRange( 0, 1));
    XCTAssertFalse( result, @"Ranges shouldn't overlap");
    
    result = NSRangeOverlapsRange( NSMakeRange( 1, 0), NSMakeRange( 0, 1));
    XCTAssertFalse( result, @"Ranges shouldn't overlap");
    
    result = NSRangeOverlapsRange( NSMakeRange( 0, 5), NSMakeRange( 5, 5));
    XCTAssertFalse( result, @"Ranges shouldn't overlap");
    
    
    // Test NSNotFound
    result = NSRangeOverlapsRange( NSMakeRange( NSNotFound, 5), NSMakeRange( 5, 5));
    XCTAssertFalse( result, @"Ranges shouldn't overlap");
    
    result = NSRangeOverlapsRange( NSMakeRange( 0, 5), NSMakeRange( NSNotFound, 5));
    XCTAssertFalse( result, @"Ranges shouldn't overlap");
}

@end
