//
//  JPGridView.m
//  sudoku
//
//  Created by Josh Petrack on 9/12/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPGridView.h"

@interface JFJPGridView (){
    NSMutableArray*  _cells;
    id _target;
    SEL _action;
}

@end

@implementation JFJPGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame));
        // Create button.
        CGFloat separationDistance = 1.0;
        
        // We will have 6 lines of width separationDistance, and
        // 4 lines of width 2*separationDistance, so the total width of
        // all lines will be 14*separationdistance
        CGFloat buttonSize = ((size - 14 * separationDistance) / 9.0);
        
        CGFloat currentY = 2 * separationDistance;
        
        _cells = [[NSMutableArray alloc] initWithCapacity:9];
        
        
        for (int i = 0; i < 9; ++i) {
            CGFloat currentX = 2 * separationDistance;
            
            // Create rows of buttons
            NSMutableArray* currentRow;
            currentRow = [[NSMutableArray alloc] initWithCapacity:9];
            for (int j = 0; j < 9; ++j) {
                CGRect buttonFrame = CGRectMake(currentX,currentY,buttonSize,buttonSize);
                
                // Create buttons
                UIButton* button = [[UIButton alloc] initWithFrame:buttonFrame];
                button.backgroundColor = [UIColor grayColor];
                [self addSubview:button];
                [button setTag:9*i + j];
                [button addTarget:self action:@selector(cellSelected:)
                 forControlEvents:UIControlEventTouchUpInside];
                [currentRow insertObject:button atIndex:j];
                
                // Update position variables
                if (j % 3 == 2) {
                    currentX += separationDistance;
                }
                currentX += buttonSize + separationDistance;
            }
            
            // Insert the new sub-array of buttons into the main array.
            [_cells insertObject:currentRow atIndex:i];
            if (i % 3 == 2) {
                currentY += separationDistance;
            }
            currentY += buttonSize + separationDistance;
        }
    }
    return self;
}

- (void)cellSelected:(id)sender {
    UIButton* tempButton = (UIButton*) sender;
    NSLog(@"The button at row %i and column %i was pressed.", tempButton.tag/9, tempButton.tag%9);
    [_target performSelector:_action
             withObject:[NSNumber numberWithInt:tempButton.tag/9]
             withObject:[NSNumber numberWithInt:tempButton.tag%9]];
}

- (void)initValueatRow:(int)row column:(int)column to:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    
    UIButton* button = [[_cells objectAtIndex:row] objectAtIndex: column];
    NSString* title;
    if (value == 0) {
        title = @"";
        [button addTarget:self
                action:@selector(buttonHighlightGood:)
                forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                action:@selector(buttonUnhighlight:)
                forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self
                action:@selector(buttonUnhighlight:)
                forControlEvents:UIControlEventTouchUpOutside];
    }
    else {
        title =[NSString stringWithFormat:@"%i", value];
        [button addTarget:self
                action:@selector(buttonHighlightBad:)
                forControlEvents:UIControlEventTouchDown];
        [button addTarget:self
                action:@selector(buttonUnhighlight:)
                forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self
                action:@selector(buttonUnhighlight:)
                forControlEvents:UIControlEventTouchUpOutside];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
}


- (void)setValueatRow:(int)row column:(int)column to:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    
    UIButton* button = [[_cells objectAtIndex:row] objectAtIndex: column];
    NSString* title;
    if (value == 0) {
        title = @"";
    }
    else {
        title =[NSString stringWithFormat:@"%i", value];
    }
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
}

- (void) setTarget:(id)target action:(SEL)action {
    _target = target;
    _action = action;
}

- (void) buttonHighlightGood:(id)sender {
    UIButton *button = (UIButton*) sender;
    [button setBackgroundColor:[UIColor greenColor]];
}

- (void) buttonHighlightBad:(id)sender {
    UIButton *button = (UIButton*) sender;
    [button setBackgroundColor:[UIColor redColor]];
}

- (void) buttonUnhighlight:(id)sender {
    UIButton *button = (UIButton*) sender;
    [button setBackgroundColor:[UIColor grayColor]];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
