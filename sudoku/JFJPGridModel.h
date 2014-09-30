//
//  JFJPGridModel.h
//  sudoku
//
//  Created by Josh Petrack on 9/19/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JFJPGridModel : NSObject

- (void) generateGridofDifficulty:(int)difficulty;
- (int) getValueAtRow:(int)row column:(int)column;
- (void) setValueAtRow:(int)row column:(int)column to:(int)value;
- (bool) isMutableAtRow:(int)row column:(int)column;
- (int) isConsistentAtRow:(int)row column:(int)column for:(int)value;
- (bool) isComplete;
- (void) generateGridfromArray:(NSArray*)array;

@end
