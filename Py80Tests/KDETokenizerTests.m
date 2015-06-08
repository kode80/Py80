//
//  KDETokenizerTests.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/7/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>

#import "KDETokenizer.h"
#import "KDEToken.h"

#define KDEAssertRangeValueEqual( value, loc, len, ...)  ( XCTAssert( NSEqualRanges( [(value) rangeValue], NSMakeRange( ( loc), (len)) ), __VA_ARGS__) )


@interface KDETokenizer (private)

- (NSArray *) tokenizeString:(NSString *)string
       withRegularExpression:(NSRegularExpression *)regex
                      ranges:(NSArray *)ranges
            defaultTokenType:(NSString *)defaultTokenType
                tokenTypeMap:(NSDictionary *)tokenTypeMap;

- (NSArray *) untokenizedRangesInRange:(NSRange)boundaryRange
                        existingTokens:(NSArray *)tokens;

- (NSArray *) sortTokens:(NSArray *)tokens;

@end


@interface KDETokenizerTests : XCTestCase

@end

@implementation KDETokenizerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testSanity
{
    XCTAssert( NSMaxRange( NSMakeRange( 29, 1)) == 30, @"sanity lost");
}

- (void) testAssertRangeValueEqual
{
    NSRange range;
    
    range = NSMakeRange( 0, 10);
    KDEAssertRangeValueEqual( [NSValue valueWithRange:range], range.location, range.length, @"ranges *are* equal, so KDEAssertRangeValueEqual is broken");
    
    range = NSMakeRange( 100, 4);
    KDEAssertRangeValueEqual( [NSValue valueWithRange:range], range.location, range.length, @"ranges *are* equal, so KDEAssertRangeValueEqual is broken");
}

- (void)testUntokenizedRanges
{
    KDETokenizer *tokenizer = [KDETokenizer new];
    NSRange boundaryRange = NSMakeRange( 0, 30);
    NSArray *tokens = @[ [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 0, 5)],
                         [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 10, 2)],
                         [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 13, 2)],
                         [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 25, 4)]];
    
    NSArray *untokenizedRanges = [tokenizer untokenizedRangesInRange:boundaryRange
                                                      existingTokens:tokens];
    
    XCTAssert( untokenizedRanges.count == 4, @"Incorrect number of untokenized ranges");
    KDEAssertRangeValueEqual( untokenizedRanges[ 0], 5, 5, @"Ranges not equal");
    KDEAssertRangeValueEqual( untokenizedRanges[ 1], 12, 1, @"Ranges not equal");
    KDEAssertRangeValueEqual( untokenizedRanges[ 2], 15, 10, @"Ranges not equal");
    KDEAssertRangeValueEqual( untokenizedRanges[ 3], 29, 1, @"Ranges not equal");
}

- (void)testUntokenizedRangesOffsetBounds
{
    KDETokenizer *tokenizer = [KDETokenizer new];
    NSRange boundaryRange = NSMakeRange( 3, 23);
    NSArray *tokens = @[ [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 0, 5)],
                         [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 10, 2)],
                         [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 13, 2)],
                         [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 25, 4)]];
    
    NSArray *untokenizedRanges = [tokenizer untokenizedRangesInRange:boundaryRange
                                                      existingTokens:tokens];
    
    XCTAssert( untokenizedRanges.count == 3, @"Incorrect number of untokenized ranges");
    KDEAssertRangeValueEqual( untokenizedRanges[ 0], 5, 5, @"Ranges not equal");
    KDEAssertRangeValueEqual( untokenizedRanges[ 1], 12, 1, @"Ranges not equal");
    KDEAssertRangeValueEqual( untokenizedRanges[ 2], 15, 10, @"Ranges not equal");
}

- (void) testSortTokens
{
    KDETokenizer *tokenizer = [KDETokenizer new];
    
    KDEToken *tokenA = [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 0, 5)];
    KDEToken *tokenB = [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 5, 1)];
    KDEToken *tokenC = [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 6, 10)];
    KDEToken *tokenD = [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 16, 13)];
    KDEToken *tokenE = [KDEToken tokenWithType:nil value:nil range:NSMakeRange( 29, 1)];
    
    NSArray *tokens = @[ tokenE,
                         tokenB,
                         tokenA,
                         tokenD,
                         tokenC];
    
    NSArray *sortedTokens = [tokenizer sortTokens:tokens];
    
    XCTAssert( sortedTokens[0] == tokenA, @"sorted tokens incorrect");
    XCTAssert( sortedTokens[1] == tokenB, @"sorted tokens incorrect");
    XCTAssert( sortedTokens[2] == tokenC, @"sorted tokens incorrect");
    XCTAssert( sortedTokens[3] == tokenD, @"sorted tokens incorrect");
    XCTAssert( sortedTokens[4] == tokenE, @"sorted tokens incorrect");
}

@end
