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
    NSMutableArray *foundation_[NUM_FOUNDATIONS];
    NSMutableArray *tableau_[NUM_TABLEAUS];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self freshGame];
    }
    return self;
}

- (void)freshGame
{
    // Get a new deck
    NSMutableArray *deck = (NSMutableArray *) [Card deck];
    
    // Shuffle deck
    [Solitaire shuffleDeck:deck];
    
    // Set up the waste stack
    waste_ = [[NSMutableArray alloc] init];
    
    // Start the empty foundation
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        foundation_[i] = [[NSMutableArray alloc] init];
    }
    
    // Deal cards from deck into tableau
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        tableau_[i] = [[NSMutableArray alloc] init];
        for (int j = 0; j <= i; j++) {
            [tableau_[i] addObject:[deck objectAtIndex:0]];
            [deck removeObjectAtIndex:0];
        }
    }
    
    // Flip the final cards of the tableau up
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        ((Card *) [tableau_[i] lastObject]).faceUp = YES;
    }
    
    // Place the remainder of the deck into the stock
    stock_ = deck;
    [self didDealCard];
}

- (void) cheat
{
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        foundation_[i] = [[NSMutableArray alloc] init];
    }
    
    // Deal cards from deck into tableau
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        tableau_[i] = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *deck = (NSMutableArray *) [Card deck];
    for (uint i = ACE; i <= KING; i++) {
        for (uint j = SPADES; j <= HEARTS; j++) {
            Card *c = [deck objectAtIndex:0];
            c.faceUp = YES;
            [foundation_[j - SPADES] addObject:c];
            [deck removeObjectAtIndex:0];
        }
    }
    
    [tableau_[0] addObject:[foundation_[0] lastObject]];
    [foundation_[0] removeObjectAtIndex:[foundation_[0] count] -1];
    
    stock_ = deck;
    waste_ = [[NSMutableArray alloc] init];
}

- (BOOL)gameWon
{
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        if (foundation_[i].count != NUM_CARDS_IN_SUIT)
            return NO;
    }
    return YES;
}

- (NSArray *)stock
{
    return stock_;
}

- (NSArray *)waste
{
    return waste_;
}

- (NSArray *)foundation:(uint)i
{
    return foundation_[i];
}

- (NSArray *)foundationWithCard:(Card *)card
{
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        if ([foundation_[i] containsObject:card])
            return foundation_[i];
    }
    return nil;
}

- (NSArray *)tableau:(uint)i
{
    return tableau_[i];
}

- (NSArray *)tableauWithCard:(Card *)card
{
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        if ([tableau_[i] containsObject:card])
            return tableau_[i];
    }
    return nil;
}

- (NSArray *)stackWithCard:(Card *)card
{
    NSArray *f = [self foundationWithCard:card];
    if (f == nil) {
        f = [self tableauWithCard:card];
    }
    if (f == nil && [waste_ lastObject] == card) {
        f = waste_;
    }
    
    if (f == nil && [stock_ lastObject] == card) {
        f = stock_;
    }
    
    return f;
}

- (NSArray *)fanBeginningWithCard:(Card *)card
{
    NSArray *fan = nil;
    NSArray *t = [self stackWithCard:card];
 
    // If card is not face up, will return nil fan
    if (card.faceUp && t != nil) {
        int index = [t indexOfObject:card];
        NSRange range = NSMakeRange(index, [t count] - index);
        fan = [t subarrayWithRange:range];
    }
        
    return fan;
}

- (BOOL)canDropCard:(Card *)c onFoundation:(int)i
{
    NSArray *f = [self foundation:i];
    
    if ([c rank] == ACE && [f count] == 0)
        return YES;
    
    Card *o = (Card *) [f lastObject];
    if (([c rank] == [o rank] + 1) && ([c suit] == [o suit]))
        return YES;
    
    return NO;
}

- (void)didDropCard:(Card *)c onFoundation:(int)i
{
    NSMutableArray *stack = (NSMutableArray *) [self stackWithCard:c];
    [stack removeObject:c];
    [foundation_[i] addObject:c];
}

- (BOOL)canDropCard:(Card *)c onTableau:(int)i
{
    NSArray *t = [self tableau:i];
    
    if ([c rank] == KING && [t count] == 0)
        return YES;
    
    Card *o = (Card *) [t lastObject];
    if (([c rank] == [o rank] - 1) && ![c isSameColor:o])
        return YES;
    
    return NO;
}

- (void)didDropCard:(Card *)c onTableau:(int)i
{
    NSMutableArray *stack = (NSMutableArray *) [self stackWithCard:c];
    [stack removeObject:c];
    [tableau_[i] addObject:c];
}

- (BOOL)canDropFan:(NSArray *)cards onTableau:(int)i
{
    Card *c = (Card *) [cards objectAtIndex:0];
    return [self canDropCard:c onTableau:i];
}

- (void)didDropFan:(NSArray *)cards onTableau:(int)i
{
    NSMutableArray *stack = (NSMutableArray *) [self stackWithCard:[cards objectAtIndex:0]];
    
    for (Card *c in cards) {
        [stack removeObject:c];
        [tableau_[i] addObject:c];
    }
}

- (BOOL)canFlipCard:(Card *)c
{
    NSArray *t = [self stackWithCard:c];
    if (t != nil && [t lastObject] == c)
        return YES;
    return NO;
}

- (void)didFlipCard:(Card *)c
{
    if ([stock_ containsObject:c]) {
        [self didDealCard];
    } else {
        c.faceUp = YES;   
    }
}

- (BOOL)canDealCard
{
    return [stock_ count] != 0;
}

- (void)didDealCard
{
    // Deal from the front so we don't have to invert when collecting waste
    Card *c = [stock_ objectAtIndex:0];
    [stock_ removeObject:c];
    
    // Flip the previous waste card face down
    [waste_ addObject:c];
    
    // Flip the dealt card face up
    c.faceUp = YES;
}

- (void)collectWasteCardsIntoStock
{
    // Flip the last waste card face down (into pile)
    for (Card *c in waste_) {
        c.faceUp = NO;
    }
    [stock_ addObjectsFromArray:waste_];
    [waste_ removeAllObjects];
}

/*
 * Stolen shamelessly from
 * http://eureka.ykyuen.info/2010/06/19/objective-c-how-to-shuffle-a-nsmutablearray/
 */
+ (void)shuffleDeck:(NSMutableArray *)deck
{
    srandom(time(NULL));
    NSUInteger count = [deck count];
    for (NSUInteger i = 0; i < count; ++i) {
        int nElements = count - i;
        int n = (random() % nElements) + i;
        [deck exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
}

@end
