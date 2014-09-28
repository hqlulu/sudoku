//
//  JFJPGridGenerator.m
//  sudoku
//
//  Created by Josh Petrack on 9/27/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPGridGenerator.h"

@interface JFJPGridGenerator (){
    NSArray *_simpleGrids;
    NSArray *_easyGrids;
    NSArray *_mediumGrids;
    NSArray *_expertGrids;
}
@end


@implementation JFJPGridGenerator

- (id)init
{
    self = [super init];
    if (self) {
        
        // Read in all difficulties of sudoku puzzles.
        _simpleGrids = [self gridsFromFileName:@"simple"];
        _easyGrids = [self gridsFromFileName:@"easy"];
        _mediumGrids = [self gridsFromFileName:@"medium"];
        _expertGrids = [self gridsFromFileName:@"expert"];
    }
    
    return self;
}

- (NSMutableArray*) gridsFromFileName: (NSString*) nameOfFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:nameOfFile ofType:@"txt"];
    NSError *error;
    
    NSString *fileString = [[NSString alloc] initWithContentsOfFile:path
                           encoding:NSUTF8StringEncoding
                           error:&error];
    
    // Read the string, 81 characters at a time, into an NSMutableArray.
    
    NSArray *stringsArray = [fileString componentsSeparatedByString:@"\n"];
    
    NSMutableArray *grids = [[NSMutableArray alloc] initWithCapacity:[stringsArray count]];
    int gridsIndex = 0;
    
    // Change each 81-character string into a proper grid
    for (NSString *gridString in stringsArray) {
        if ([gridString length] != 0) {
            NSMutableArray *currentGrid = [self gridFromString:gridString];
            [grids insertObject:currentGrid atIndex:gridsIndex];
            ++gridsIndex;
        }
    }
    return grids;
}

- (NSMutableArray*) gridFromString: (NSString*) gridString {
    NSAssert([gridString length] == 82, @"Invalid gridString: %@\n of length:%d",
             gridString, [gridString length]);
    
    NSMutableArray *grid = [[NSMutableArray alloc] initWithCapacity:9];
    for (int i=0; i<9; ++i) {
        NSMutableArray *currentRow = [[NSMutableArray alloc] initWithCapacity:9];
        for (int j=0; j<9; ++j) {
            char charToInsert = [gridString characterAtIndex:9*i+j];
            if (charToInsert == '.') {
                charToInsert = '0';
            }
            NSNumber *numberToInsert = [[NSNumber alloc] initWithChar: charToInsert-'0'];
            [currentRow insertObject:numberToInsert atIndex:j];
        }
        [grid insertObject:currentRow atIndex:i];
    }
    return grid;
}

- (NSArray*) getGridWithDifficulty: (int)difficulty {
    NSAssert(0 <= difficulty && difficulty <= 3, @"Invalid difficulty: %d", difficulty);
    
    NSArray *desiredGrids;
    
    
    switch (difficulty) {
        case 0:
            desiredGrids = _simpleGrids;
            break;
        case 1:
            desiredGrids = _easyGrids;
            break;
        case 2:
            desiredGrids = _mediumGrids;
            break;
        case 3:
            desiredGrids = _expertGrids;
            break;
            
        default:
            // Will never be hit because of assert
            break;
    }
    
    int puzzleIndex = arc4random_uniform([desiredGrids count]);
    return [desiredGrids objectAtIndex:puzzleIndex];
}

@end
