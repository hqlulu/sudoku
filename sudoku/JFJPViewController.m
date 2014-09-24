//
//  JPViewController.m
//  sudoku
//
//  Created by Josh Petrack on 9/11/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPViewController.h"
#import "JFJPGridView.h"
#import "JFJPNumPadView.h"
#import "JFJPGridModel.h"




@interface JFJPViewController () {
    
    JFJPGridView* _gridView;
    JFJPGridModel* _gridModel;
    JFJPNumPadView* _numPadView;
    
}

@end

@implementation JFJPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // Create grid frame.
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame)*.1;
    CGFloat y = CGRectGetHeight(frame)*.1;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*.80;
    
    CGRect gridFrame = CGRectMake(x,y,size,size);
    
    // Create grid view.
    _gridView = [[JFJPGridView alloc] initWithFrame:gridFrame];
    _gridView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_gridView];
    [_gridView setTarget:self action:@selector(gridCellSelectedatRow:column:)];
    
    // Create numpad frame.
    CGRect numpadFrame = CGRectMake(x, y+size*10/9, size, size/9);
    
    // Create numpad view
    _numPadView = [[JFJPNumPadView alloc] initWithFrame:numpadFrame];
    _numPadView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_numPadView];
    
    // Create grid model
    _gridModel = [[JFJPGridModel alloc] init];
    [_gridModel generateGrid];
    
    [self setGridViewValues];
    
}

- (void)setGridViewValues {
    for(int i = 0; i < 9; ++i) {
        for (int j = 0; j < 9; ++j) {
            int value = [_gridModel getValueAtRow:i column:j];
            [_gridView initValueatRow:i column:j to:value];
        }
    }
    
}

- (void)gridCellSelectedatRow:(NSNumber*)objectRow column:(NSNumber*)objectColumn {
    int cellRow = [objectRow integerValue];
    int cellColumn = [objectColumn integerValue];
    
    NSAssert(0 <= cellRow && cellRow <= 8, @"Invalid row: %d", cellRow);
    NSAssert(0 <= cellColumn && cellColumn <= 8, @"Invalid column: %d", cellColumn);
    
    int selectedNumber = [_numPadView getCurrentValue];
    if ([_gridModel isMutableAtRow:cellRow column:cellColumn] &&
        [_gridModel isConsistentAtRow:cellRow column:cellColumn for:selectedNumber]) {
        
        // Update the model and the view
        [_gridModel setValueAtRow:cellRow column:cellColumn to:selectedNumber];
        [_gridView setValueatRow:cellRow column:cellColumn to:selectedNumber];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
