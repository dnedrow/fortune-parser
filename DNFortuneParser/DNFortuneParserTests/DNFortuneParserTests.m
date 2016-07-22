//
//  DNFortuneParserTests.m
//  DNFortuneParserTests
//
//  Created by David Nedrow on 7/15/16.
//  Copyright © 2016 David Nedrow. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DNFortuneParser.h"
#import "DNFortuneParserErrors.h"

@interface DNFortuneParserTests : XCTestCase

@end

@implementation DNFortuneParserTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testThatNilFileNameCausesError {
    NSError *error = nil;
    NSArray *array = [DNFortuneParser parseFortunesFromFile:nil error:&error];
    XCTAssertTrue(error.code == NoFileNameProvided && array == nil);
}

- (void)testThatEmptyFileNameCausesError {
    NSError *error = nil;
    NSArray *array = [DNFortuneParser parseFortunesFromFile:@"" error:&error];
    XCTAssertTrue(error.code == NoFileNameProvided && array == nil);
}

- (void)testThatFileWasNotFound {
    NSError *error = nil;
    NSArray *array = [DNFortuneParser parseFortunesFromFile:@"/foo" error:&error];
    XCTAssertTrue(error.code == FileNotFound && array == nil);
}

- (void)testThatFileWasFound {
    NSError *error = nil;

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:@"startrek" ofType:nil];

    NSArray *array = [DNFortuneParser parseFortunesFromFile:resource error:&error];
    XCTAssertTrue(error == nil);
}

@end
