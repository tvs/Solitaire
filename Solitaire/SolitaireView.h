//
//  SolitaireView.h
//  Solitaire
//
//  Created by Travis Hall on 4/25/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solitaire.h"

@interface SolitaireView : UIView

@property (strong,nonatomic) Solitaire *game;

- (void)iterateGameWithBlock:(void (^)(Card *c))block;
- (void)addCardViewToSubview:(Card *)c;

@end
