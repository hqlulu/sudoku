//
//  JFJPNumPadView.m
//  sudoku
//
//  Created by Josh Petrack on 9/21/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPNumPadView.h"

@interface JFJPNumPadView (){
    NSMutableArray *_cells;
    int _currentValue;
}
@end

@implementation JFJPNumPadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Create button.
        CGFloat separationDistance = 1.0;
        
        // We will have 11 lines of width separationDistance
        CGFloat buttonSize = ((CGRectGetWidth(frame) - 11 * separationDistance)/10);
        
        _cells = [[NSMutableArray alloc] initWithCapacity:10];
        
        for (int i = 0; i <= 9; ++i) {
            CGRect buttonFrame = CGRectMake((separationDistance+buttonSize)*i+separationDistance,
                                            separationDistance, buttonSize,
                                            buttonSize + 2*separationDistance);
            UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
            [button setBackgroundColor: [UIColor grayColor]];
            [self addSubview:button];
            NSString *title;
            [button setTag:i];
            if (i == 0) {
                title = @"";
            }
            else {
                title = [NSString stringWithFormat:@"%d", i];
            }
            [button setTitle:title forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button addTarget:self action:@selector(cellSelected:)
             forControlEvents:UIControlEventTouchUpInside];
            [_cells insertObject:button atIndex:i];
        }
    }

    return self;
}

- (void)cellSelected:(id)sender {
    UIButton* tempButton = (UIButton*) sender;
    NSLog(@"The button %d was pressed.", tempButton.tag);
    
    UIButton *oldButton = [_cells objectAtIndex:_currentValue];
    [oldButton setBackgroundColor:[UIColor grayColor]];
    _currentValue = tempButton.tag;
    UIButton *newButton = [_cells objectAtIndex:_currentValue];
    [newButton setBackgroundColor:[UIColor greenColor]];
}

- (int) getCurrentValue {
    return _currentValue;
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
