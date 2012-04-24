//
//  Solitaire.m
//  Solitaire
//
//  Created by Travis Hall on 4/24/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import "Solitaire.h"

@implementation Solitaire {
    NSMutableArray *stock_;
    NSMutableArray *waste_;
    NSMutableArray *foundation_[4];
    NSMutableArray *tableau_[7];
    NSMutableSet *faceUpCards;
}

- (id)init
{

}


- (void)freshGame
{

}

- (BOOL)gameWon
{

}


- (NSArray *)stock
{

}

- (NSArray *)waste
{

}

- (NSArray *)foundation:(uint)i
{

}

- (NSArray *)tableau:(uint)i
{

}


- (BOOL)isCardFaceUp:(Card *)card
{

}


- (NSArray *)fanBeginningWithCard:(Card *)card
{

}


- (BOOL)canDropCard:(Card *)c onFoundation:(int)i
{

}

- (void)didDropCard:(Card *)c onFoundation:(int)i
{

}


- (BOOL)canDropCard:(Card *)c onTableau:(int)i
{

}

- (void)didDropCard:(Card *)c onTableau:(int)i
{

}


- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i
{

}

- (void)didDropFan:(NSArray *)cards onTableau:(int)i
{

}


- (BOOL)canFlipCard:(Card *)c
{

}

- (void)didFlipCard:(Card *)c
{

}


- (BOOL)canDealCard
{

}
 // move top card from stock to waste
- (void)didDealCard
{

}


- (void)collectWasteCardsIntoStock
{

}


@end
