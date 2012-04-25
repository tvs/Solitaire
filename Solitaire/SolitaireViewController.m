//
//  SolitaireViewController.m
//  Solitaire
//
//  Created by Travis Hall on 4/24/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import "SolitaireViewController.h"

@interface SolitaireViewController ()

@end

@implementation SolitaireViewController

@synthesize game;
@synthesize gameView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.game = [[Solitaire alloc] init];

    self.gameView.game = self.game;
    
    [self.game freshGame];
}

- (void)viewDidUnload
{
    [self setGameView:nil];
    self.game = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)newGame:(id)sender {
    [self.game freshGame];
    [self.gameView setNeedsDisplay];
}

- (void)movedFan:(NSArray *)fan toTableau:(uint)i
{
    if ([game canDropFan:fan onTableau:i]) {
        [game didDropFan:fan onTableau:i];
    }
}

- (void)movedCard:(Card *)c toFoundation:(uint)i
{
    if ([game canDropCard:c onFoundation:i]) {
        [game didDropCard:c onFoundation:i];
    }
}

@end
