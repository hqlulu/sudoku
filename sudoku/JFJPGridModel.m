//
//  JFJPGridModel.m
//  sudoku
//
//  Created by Josh Petrack on 9/19/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPGridModel.h"

int initialGrid[9][9]={
    {7,0,0,4,2,0,0,0,9},
    {0,0,9,5,0,0,0,0,4},
    {0,2,0,6,9,0,5,0,0},
    {6,5,0,0,0,0,4,3,0},
    {0,8,0,0,0,6,0,0,7},
    {0,1,0,0,4,5,6,0,0},
    {0,0,0,8,6,0,0,0,2},
    {3,4,0,9,0,0,1,0,0},
    {8,0,0,3,0,2,7,4,0}
};

@interface JFJPGridModel (){
    
    int _cells[9][9];
}

@end

@implementation JFJPGridModel

- (void) generateGrid {
    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            _cells[i][j] = initialGrid[i][j];
        }
    }
}

- (int) getValueAtRow:(int)row column:(int)column {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    
    return _cells[row][column];
}

- (void) setValueAtRow:(int)row column:(int)column to:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(1 <= value && value <= 9, @"Invalid value: %d", value);
    
    _cells[row][column] = value;
}

- (bool) isMutableAtRow:(int)row column:(int)column {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    
    return initialGrid[row][column] == 0;
}

- (bool) isConsistentAtRow:(int)row column:(int)column for:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(1 <= value && value <= 9, @"Invalid value: %d", value);
    
    // Check the row.
    for (int i = 0; i < 9; ++i) {
        if (i != column && _cells[row][i] == value) {
            return NO;
        }
    }
    
    // Check the column.
    for (int i = 0; i < 9; ++i) {
        if (i != row && _cells[i][column] == value) {
            return NO;
        }
    }
    
    // Check the 3x3 subgrid, starting in its upper-left corner.
    int topLeftRow = 3 * (row / 3);
    int topLeftColumn = 3 * (column / 3);
    
    for (int i = topLeftRow; i < topLeftRow + 3; ++i) {
        for (int j = topLeftColumn; j < topLeftColumn + 3; ++j) {
            if ((i != row || j != column) && _cells[i][j] == value) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
