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
#import "JFJPSettingsView.h"
#import "JFJPInfoView.h"

#import <AudioToolbox/AudioToolbox.h>

@interface JFJPViewController () {
    
    JFJPGridView* _gridView;
    JFJPGridModel* _gridModel;
    JFJPNumPadView* _numPadView;
    JFJPSettingsView *_settingsView;
    JFJPInfoView *_infoView;
    
    UIButton *_settingsButton;
    UIButton *_infoButton;
    UIButton* _newGameButton;
    
    SystemSoundID clapSound;
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
    [_gridModel generateGridofDifficulty:3];
    
    [self setGridViewValues];
    
    
    // Set up new game button
    CGRect newGameButtonFrame = CGRectMake(x+size*3/10, y+size*12/9, size*4/10, size/9);
    _newGameButton = [[UIButton alloc] initWithFrame:newGameButtonFrame];
    _newGameButton.backgroundColor = [UIColor grayColor];
    [_newGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_newGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [_newGameButton addTarget:self
                    action:@selector(confirmNewGame:)
                    forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_newGameButton];
    
    // Set up settings view and button
    _settingsView = [[JFJPSettingsView alloc] initWithFrame:frame];
    _settingsView.backgroundColor = [UIColor whiteColor];
    [_settingsView setHidden:YES];
    [self.view addSubview:_settingsView];
    
    CGRect settingsButtonFrame = CGRectMake(x, .9 * CGRectGetHeight(frame), size * .1, size * .1);
    _settingsButton = [[UIButton alloc] initWithFrame:settingsButtonFrame];
    [_settingsButton setImage:[UIImage imageNamed:@"settings.png"] forState:UIControlStateNormal];
    [_settingsButton addTarget:self
                     action:@selector(showSettings:)
                     forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingsButton];
    
    // Set up info view and button
    _infoView = [[JFJPInfoView alloc] initWithFrame:frame];
    _infoView.backgroundColor = [UIColor whiteColor];
    [_infoView setHidden:YES];
    [self.view addSubview:_infoView];
    
    CGRect infoButtonFrame = CGRectMake(x + .9*size, .9 * CGRectGetHeight(frame), size * .1, size * .1);
    _infoButton = [[UIButton alloc] initWithFrame:infoButtonFrame];
    [_infoButton setImage:[UIImage imageNamed:@"infobutton.png"] forState:UIControlStateNormal];
    [_infoButton addTarget:self action:@selector(showInfo:)
              forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_infoButton];
    
    // Create Applause Sound for Win
    NSString *clapPath = [[NSBundle mainBundle] pathForResource:@"Applause" ofType:@"wav"];
    NSURL *clapURL = [NSURL fileURLWithPath:clapPath];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)clapURL, &clapSound);
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
    
    // Get code indicating whether entry is consistent, and if inconsistent,
    // what it is inconsistent with.
    int selectedNumber = [_numPadView getCurrentValue];
    int consistencyCode = [_gridModel isConsistentAtRow:cellRow column:cellColumn for:selectedNumber];
    
    if ([_gridModel isMutableAtRow:cellRow column:cellColumn] && consistencyCode == 0) {
        
        // Update the model and the view
        [_gridModel setValueAtRow:cellRow column:cellColumn to:selectedNumber];
        [_gridView setValueatRow:cellRow column:cellColumn to:selectedNumber];
        
        // Play a sound if we win
        if ([_gridModel isComplete]) {
            AudioServicesPlaySystemSound(clapSound);
        }
    }
    if ([_gridModel isMutableAtRow:cellRow column:cellColumn]) {
        [_gridView highlightInconsistent:consistencyCode atRow:cellRow column:cellColumn];
    }
}

- (void)confirmNewGame:(id)sender {
    
    UIAlertView *confirmationDialogue = [[UIAlertView alloc] initWithTitle:@"New Game"
                                          message:@"Are you sure you want to start a new game?"
                                          delegate:self
                                          cancelButtonTitle:@"No"
                                          otherButtonTitles:@"Yes",nil];
    
    [confirmationDialogue show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self startNewGame];
    }
}

-(void)startNewGame {
    [_gridModel generateGridofDifficulty:[_settingsView getDifficulty]];
    [self setGridViewValues];
}

-(void)showSettings:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view bringSubviewToFront:_settingsView];
    _settingsView.hidden = NO;
}

-(void)showInfo:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    transition.delegate = self;
    [self.view.layer addAnimation:transition forKey:nil];
    [self.view bringSubviewToFront:_infoView];
    _infoView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dealloc {
    AudioServicesDisposeSystemSoundID(clapSound);
}
@end
