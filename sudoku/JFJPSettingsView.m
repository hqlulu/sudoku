//
//  JFJPSettingsView.m
//  sudoku
//
//  Created by Josh Petrack on 9/28/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPSettingsView.h"

@interface JFJPSettingsView () {
    int _difficulty;
}
@end

@implementation JFJPSettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Make size constants
        CGFloat x = CGRectGetWidth(frame)*.1;
        CGFloat y = CGRectGetHeight(frame)*.1;
        CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*.80;
        CGFloat settingWidth = size*.5;
        CGFloat settingHeight = size*.2;
        
        //Make difficulty label
        CGRect difficultyLabelFrame = CGRectMake(x,y,settingWidth,settingHeight);
        UILabel *difficultyLabel = [[UILabel alloc] initWithFrame:difficultyLabelFrame];
        [difficultyLabel setText:@"Difficulty:"];
        [difficultyLabel setTextColor:[UIColor blackColor]];
        
        [self addSubview:difficultyLabel];
        
        // Make difficulty button
        CGRect difficultyButtonFrame = CGRectMake(x+settingWidth, y, settingWidth, settingHeight);
        UIButton *difficultyButton = [[UIButton alloc] initWithFrame:difficultyButtonFrame];
        [difficultyButton setTitle:@"Beginner" forState:UIControlStateNormal];
        [difficultyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [difficultyButton setBackgroundColor:[UIColor grayColor]];
        [difficultyButton addTarget:self action:@selector(changeDifficulty:)
                   forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:difficultyButton];

    }
    return self;
}

-(void) changeDifficulty:(id)sender {
    UIButton *currentButton = (UIButton*) sender;
    switch (_difficulty) {
        case 0:
            _difficulty = 1;
            [currentButton setTitle:@"Easy" forState:UIControlStateNormal];
            break;
        case 1:
            _difficulty = 2;
            [currentButton setTitle:@"Medium" forState:UIControlStateNormal];
            break;
        case 2:
            _difficulty = 3;
            [currentButton setTitle:@"Hard" forState:UIControlStateNormal];
            break;
        case 3:
            _difficulty = 0;
            [currentButton setTitle:@"Beginner" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

-(int) getDifficulty {
    return _difficulty;
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
