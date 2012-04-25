//
//  SolitaireViewController.h
//  Solitaire
//
//  Created by Travis Hall on 4/24/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SolitaireView.h"
#import "Solitaire.h"
#import "SolitaireDelegate.h"

@interface SolitaireViewController : UIViewController <SolitaireDelegate>

@property (strong,nonatomic) Solitaire *game;
@property (weak, nonatomic) IBOutlet SolitaireView *gameView;

- (IBAction)newGame:(id)sender;

@end
