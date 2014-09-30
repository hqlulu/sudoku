//
//  JPGridView.m
//  sudoku
//
//  Created by Josh Petrack on 9/12/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPGridView.h"

#import <AudioToolbox/AudioToolbox.h>

@interface JFJPGridView (){
    NSMutableArray*  _cells;
    id _target;
    SEL _action;
    
    SystemSoundID clickSound;
    SystemSoundID eraseSound;
    SystemSoundID beepSound;
    SystemSoundID tromboneSound;
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
                [button addTarget:self
                        action:@selector(cellSelected:)
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
        [self setUpSound:@"erase" forLocation:&eraseSound];
        [self setUpSound:@"click" forLocation:&clickSound];
        
        // Taken from http://soundbible.com/1806-Censored-Beep.html
        // Under creative commons attribution 3.0
        [self setUpSound:@"beep" forLocation:&beepSound];
        
        // Taken from http://soundbible.com/1830-Sad-Trombone.html
        // Under creative commons attribution 3.0
        [self setUpSound:@"trombone" forLocation:&tromboneSound];
    }
    return self;
}

- (void)setUpSound:(NSString*)fileName forLocation:(SystemSoundID*)location {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    NSURL *URL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)URL, location);
}

- (void)cellSelected:(id)sender {
    UIButton* tempButton = (UIButton*) sender;
    
    [_target performSelector:_action
             withObject:[NSNumber numberWithInt:tempButton.tag/9]
             withObject:[NSNumber numberWithInt:tempButton.tag%9]];
}

- (void)initValueatRow:(int)row column:(int)column to:(int)value {
    NSAssert(0 <= row && row <= 8, @"Invalid row: %d", row);
    NSAssert(0 <= column && column <= 8, @"Invalid column: %d", column);
    NSAssert(0 <= value && value <= 9, @"Invalid value: %d", value);
    
    UIButton* button = [[_cells objectAtIndex:row] objectAtIndex: column];
    
    [button removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
    [button addTarget:self
            action:@selector(cellSelected:)
            forControlEvents:UIControlEventTouchUpInside];
    NSString* title;
    if (value == 0) {
        title = @"";
        [button addTarget:self
                action:@selector(buttonHighlightGood:)
                forControlEvents:UIControlEventTouchDown];
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
        AudioServicesPlaySystemSound(eraseSound);
    }
    else {
        title =[NSString stringWithFormat:@"%i", value];
        AudioServicesPlaySystemSound(clickSound);
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
    
    AudioServicesPlaySystemSound(beepSound);
}

- (void) buttonUnhighlight:(id)sender {
    UIButton *button = (UIButton*) sender;
    [button setBackgroundColor:[UIColor grayColor]];
}

- (void) highlightInconsistent:(int)code atRow:(int)row column:(int)column {
    
    // What we highlight is based on the code we're passed.
    // For meaning of values, see the isConsistentAtRow:column:for method
    // in gridmodel.
    
    // If there's any inconsistency at all, we play a sad sound :[.
    if (code != 0) {
        AudioServicesPlaySystemSound(tromboneSound);
    }
    
    // We will flash at most 21 buttons.
    NSMutableSet *buttonSet = [[NSMutableSet alloc] initWithCapacity:21];
    
    // Inconsistent row
    if (code / 100 == 1) {
        NSMutableArray *gridRow = [_cells objectAtIndex:row];
        for (int i = 0; i < 9; ++i) {
            [buttonSet addObject:[gridRow objectAtIndex:i]];
        }
    }
    
    // Inconsistent column
    if ((code % 100) / 10 == 1) {
        for (int i = 0; i < 9; ++i) {
            NSMutableArray *gridRow = [_cells objectAtIndex:i];
            [buttonSet addObject:[gridRow objectAtIndex:column]];
        }
    }
    
    // Inconsistent subgrid
    if (code % 10 == 1) {
        int topLeftRow = 3 * (row / 3);
        int topLeftColumn = 3 * (column / 3);
        
        for (int i = topLeftRow; i < topLeftRow + 3; ++i) {
            NSMutableArray *gridRow = [_cells objectAtIndex:i];
            for (int j = topLeftColumn; j < topLeftColumn + 3; ++j) {
                [buttonSet addObject:[gridRow objectAtIndex:j]];
            }
        }
    }
    
    [[[_cells objectAtIndex:row] objectAtIndex:column] setBackgroundColor:[UIColor grayColor]];
    
    for (UIButton* button in buttonSet) {
        [self flashButton:button];
    }
    
}

- (void) flashButton:(UIButton*)button {
    [UIView animateWithDuration:1.2
                          delay:0.0
                        options:UIViewAnimationOptionAutoreverse
                     animations:^{[button setBackgroundColor:[UIColor redColor]];}
                     completion:^(BOOL finished) {[button setBackgroundColor:[UIColor grayColor]];}];
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
