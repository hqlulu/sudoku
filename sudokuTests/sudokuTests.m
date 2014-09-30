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
    [gridModel generateGridfromArray:@[@[@7,@0,@0,@4,@2,@0,@0,@0,@9],
                                       @[@0,@0,@9,@5,@0,@0,@0,@0,@4],
                                       @[@0,@2,@0,@6,@9,@0,@5,@0,@0],
                                       @[@6,@5,@0,@0,@0,@0,@4,@3,@0],
                                       @[@0,@8,@0,@0,@0,@6,@0,@0,@7],
                                       @[@0,@1,@0,@0,@4,@5,@6,@0,@0],
                                       @[@0,@0,@0,@8,@6,@0,@0,@0,@2],
                                       @[@3,@4,@0,@9,@0,@0,@1,@0,@0],
                                       @[@8,@0,@0,@3,@0,@2,@7,@4,@0]
                                       ]];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConsistentEntry
{
    XCTAssertEqual([gridModel isConsistentAtRow:2 column:2 for:3],0, @"Detected false inconsistency");
}

- (void)testRowConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:8 column:8 for:3],100, @"Did not detect row inconsistency");
}

- (void)testColumnConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:4 column:4 for:9],10, @"Did not detect column inconsistency");
}

- (void)testBlockConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:6 column:7 for:1],1, @"Did not detect block inconsistency");
}

- (void)testRowColumnConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:6 column:0 for:6],110, @"Did not detect simultaneous row and column inconsistency correctly");
}

- (void)testRowBlockConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:7 column:2 for:4],101, @"Did not detect block inconsistency correctly");
}

- (void)testColumnBlockConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:6 column:0 for:3],11, @"Did not detect block inconsistency");
}

- (void)testRowColumnBlockConflict
{
    XCTAssertEqual([gridModel isConsistentAtRow:0 column:1 for:2],111, @"Did not detect block inconsistency");
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
