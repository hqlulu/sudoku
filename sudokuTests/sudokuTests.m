//
//  sudokuTests.m
//  sudokuTests
//
//  Created by Josh Petrack on 9/11/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "JFJPGridModel.h"

@interface sudokuTests : XCTestCase

@end

@implementation sudokuTests

JFJPGridModel *gridModel;

- (void)setUp
{
    [super setUp];
    gridModel = [[JFJPGridModel alloc] init];
    [gridModel generateGrid];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConsistentEntry
{
    XCTAssertTrue([gridModel isConsistentAtRow:2 column:2 for:3], @"Did not detect row inconsisteny");
}

- (void)testRowConflict
{
    XCTAssertFalse([gridModel isConsistentAtRow:8 column:8 for:3], @"Did not detect row inconsisteny");
}

- (void)testColumnConflict
{
    XCTAssertFalse([gridModel isConsistentAtRow:4 column:4 for:9], @"Did not detect column inconsisteny");
}

- (void)testBlockConflict
{
    XCTAssertFalse([gridModel isConsistentAtRow:6 column:7 for:1], @"Did not detect block inconsisteny");
}

- (void)testConsistencyOutOfBoundsErrors
{
    XCTAssertThrowsSpecific([gridModel isConsistentAtRow:-1 column:7 for:1], NSException,
                            @"Did not throw error on negative row");
    XCTAssertThrowsSpecific([gridModel isConsistentAtRow:5 column:-1 for:1], NSException,
                            @"Did not throw error on negative column");
    XCTAssertThrowsSpecific([gridModel isConsistentAtRow:3 column:9 for:1], NSException,
                            @"Did not throw error on large row");
    XCTAssertThrowsSpecific([gridModel isConsistentAtRow:9 column:5 for:1], NSException,
                            @"Did not throw error on large column");
    XCTAssertThrowsSpecific([gridModel isConsistentAtRow:5 column:5 for:-1], NSException,
                            @"Did not throw error on negative value");
    XCTAssertThrowsSpecific([gridModel isConsistentAtRow:9 column:5 for:10], NSException,
                            @"Did not throw error on large value");
}

@end
