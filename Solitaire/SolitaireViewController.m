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
    
    [self.game freshGame];
    self.gameView.game = self.game;
    self.gameView.delegate = self;
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
    return NO;
}

- (IBAction)newGame:(id)sender {
    [self.game freshGame];
    self.gameView.game = self.game;
    [self.gameView setNeedsDisplay];
}

- (void)moveStockToWaste
{
    if ([game canDealCard]) {
        [game didDealCard];
    }
    else {
        [game collectWasteCardsIntoStock];
    }
}

- (BOOL)movedFan:(NSArray *)fan toTableau:(uint)i
{
    if ([game canDropFan:fan onTableau:i]) {
        [game didDropFan:fan onTableau:i];
        return YES;
    }
    return NO;
}

- (BOOL)movedCard:(Card *)c toFoundation:(uint)i
{
    if ([game canDropCard:c onFoundation:i]) {
        [game didDropCard:c onFoundation:i];
        return YES;
    }
    return NO;
}

- (BOOL)flipCard:(Card *)c
{
    if ([game canFlipCard:c]) {
        [game didFlipCard:c];
        return YES;
    }
    return NO;
}

@end
