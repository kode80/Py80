//
//  KDEPyTokenizerTests.m
//  Py80
//
//  Created by Benjamin S Hopkins on 6/9/15.
//  Copyright (c) 2015 kode80. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <XCTest/XCTest.h>
#import "KDEPyTokenizer.h"


@interface KDEPyTokenizerTests : XCTestCase

@end

@implementation KDEPyTokenizerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTokenizeString
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *testSource = [NSString stringWithContentsOfFile:[bundle pathForResource:@"PythonTokenizerTest" ofType:@"py"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:NULL];
    NSString *truth = [NSString stringWithContentsOfFile:[bundle pathForResource:@"PythonTokenizerTest_Truth" ofType:@"txt"]
                                                encoding:NSUTF8StringEncoding
                                                   error:NULL];
    
    KDEPyTokenizer *tokenizer = [KDEPyTokenizer new];
    NSArray *tokens = [tokenizer tokenizeString:testSource];
    
    NSMutableString *output = [NSMutableString string];
    for( KDEToken *token in tokens)
    {
        [output appendFormat:@"%@ (%@) = \"%@\"\n", [tokenizer stringForTokenType:token.type], NSStringFromRange( token.range), token.value];
    }
    
    XCTAssert( [output isEqualToString:truth], @"Output did not match varified 'truth'");
}

- (void) testFilterOpenTokens
{
    KDEPyTokenizer *tokenizer = [KDEPyTokenizer new];
    NSArray *tokens = @[ [KDEToken tokenWithType:KDEPyTokenTypeBracket value:@"" range:NSMakeRange( 0, 0)],
                         [KDEToken tokenWithType:KDEPyTokenTypeOpenDocString value:@"" range:NSMakeRange( 0, 0)],
                         [KDEToken tokenWithType:KDEPyTokenTypeString value:@"" range:NSMakeRange( 0, 0)],
                         [KDEToken tokenWithType:KDEPyTokenTypeName value:@"" range:NSMakeRange( 0, 0)],
                         [KDEToken tokenWithType:KDEPyTokenTypeOpenString value:@"" range:NSMakeRange( 0, 0)]];
    
    NSArray *openTokens = [tokenizer filterOpenTokens:tokens];
    
    XCTAssertEqual( openTokens.count, 2, @"should be 2 open tokens");
    XCTAssertEqual( openTokens[ 0], tokens[1], @"open token incorrect");
    XCTAssertEqual( openTokens[ 1], tokens[4], @"open token incorrect");
}

@end
