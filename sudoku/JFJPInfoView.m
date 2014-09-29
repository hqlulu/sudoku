//
//  JFJPInfoView.m
//  sudoku
//
//  Created by Josh Petrack on 9/28/14.
//  Copyright (c) 2014 Josh Petrack. All rights reserved.
//

#import "JFJPInfoView.h"

@implementation JFJPInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Make size constants
        CGFloat x = CGRectGetWidth(frame)*.1;
        CGFloat y = CGRectGetHeight(frame)*.1;
        CGFloat frameWidth = CGRectGetWidth(frame)*.8;
        CGFloat frameHeight = CGRectGetHeight(frame)*.8;
        
        //Make rules label
        CGRect rulesTextFrame = CGRectMake(x,y,frameWidth,frameHeight * .8);
        UITextView *rulesText = [[UITextView alloc] initWithFrame:rulesTextFrame];
        NSString *rules = @"Welcome to the game of Sudoku! To win, fill in every square with the numbers 1-9 so that every row, column, and 3-by-3 subgrid (marked out with thicker lines) has every number from 1 to 9. There's only one way to fill in the grid correctly, so be careful!";
        [rulesText setText:rules];
        [rulesText setTextColor:[UIColor blackColor]];
        [rulesText setEditable:NO];
        [rulesText setSelectable:NO];
        
        [self addSubview:rulesText];
        
        // Make close info button
        CGRect closeButtonFrame = CGRectMake(x, y+.8*frameHeight, frameWidth, .2*frameHeight);
        UIButton *closeInfoButton = [[UIButton alloc] initWithFrame:closeButtonFrame];
        [closeInfoButton setTitle:@"Back to game" forState:UIControlStateNormal];
        [closeInfoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [closeInfoButton setBackgroundColor:[UIColor grayColor]];
        [closeInfoButton addTarget:self
                         action:@selector(closeInfo:)
                         forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:closeInfoButton];
        
    }
    return self;
}

-(void) closeInfo:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.layer addAnimation:transition forKey:nil];
    [self setHidden:YES];
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
