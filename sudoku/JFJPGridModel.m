//
//  JFJPGridModel.m
//  sudoku
//
//  Created by Josh Petrack on 9/19/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPGridModel.h"
#import "JFJPGridGenerator.h"

@interface JFJPGridModel (){
    int _cells[9][9];
    int _initialGrid[9][9];
    JFJPGridGenerator *_gridGenerator;
}

@end

@implementation JFJPGridModel

- (id)init
{
    self = [super init];
    if (self) {
        _gridGenerator = [[JFJPGridGenerator alloc] init];
    }
    return self;
}

- (void) generateGridofDifficulty:(int)difficulty {
    NSArray *grid = [_gridGenerator getGridWithDifficulty:difficulty];
    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            _cells[i][j] = [[[grid objectAtIndex:i] objectAtIndex:j] integerValue];
            _initialGrid[i][j] = [[[grid objectAtIndex:i] objectAtIndex:j] integerValue];
        }
    }
}

- (void) generateGridfromArray:(NSArray *)array {
    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            _cells[i][j] = [[[array objectAtIndex:i] objectAtIndex:j] integerValue];
            _initialGrid[i][j] = [[[array objectAtIndex:i] objectAtIndex:j] integerValue];
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
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    
    _cells[row][column] = value;
}

- (bool) isMutableAtRow:(int)row column:(int)column {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    
    return _initialGrid[row][column] == 0;
}

- (int) isConsistentAtRow:(int)row column:(int)column for:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    
    // A value of 0 is always consistent (it blanks the cell).
    if (value == 0) {
        return 0;
    }
    
    // Most significant digit indicates row, middle indicates column, least indicates subgrid
    // 1 = inconsistent, 0 = consistent
    int returnCode = 0;
    
    // Check the row.
    if (![self isRowConsistentAtRow:row column:column for:value]) {
        returnCode += 100;
    }
    
    // Check the column.
    if (![self isColumnConsistentAtRow:row column:column for:value]) {
        returnCode += 10;
    }
    
    // Check the 3x3 subgrid, starting in its upper-left corner.
    if (![self isSubgridConsistentAtRow:row column:column for:value]) {
        returnCode += 1;
    }
    
    return returnCode;
}

- (bool) isRowConsistentAtRow:(int)row column:(int)column for:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    for (int i = 0; i < 9; ++i) {
        if (i != column && _cells[row][i] == value) {
            return NO;
        }
    }
    return YES;
}
- (bool) isColumnConsistentAtRow:(int)row column:(int)column for:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    for (int i = 0; i < 9; ++i) {
        if (i != row && _cells[i][column] == value) {
            return NO;
        }
    }
    return YES;
}
- (bool) isSubgridConsistentAtRow:(int)row column:(int)column for:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
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


- (bool) isComplete {
    for (int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            if (_cells[i][j] == 0) {
                return NO;
            }
        }
    }
    
    return YES;
}

@end
