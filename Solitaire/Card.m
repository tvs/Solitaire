//
//  Card.m
//  Solitaire
//
//  Created by Travis Hall on 4/24/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import "Card.h"

@implementation Card

@synthesize rank;
@synthesize suit;

- (id)initWithRank:(uint)r Suit:(uint)s
{
    self = [super init];
    if (self) {
        rank = r;
        suit = s;
    }
    return self;
}

- (NSUInteger)hash
{
    return (rank - 1)*4 + suit; // return 0 to 51
}

- (BOOL)isEqual:(id)other
{
    return rank == [other rank] && suit == [other suit];
}

- (NSString *)description
{
    NSString *s;
    switch (suit) {
        case SPADES:
            s = @"Spades";
            break;
        case CLUBS:
            s = @"Clubs";
            break;
        case DIAMONDS:
            s = @"Diamonds";
            break;
        case HEARTS:
            s = @"Hearts";
            break;
        default:
            s = @"Unknown!";
            break;
    }
    
    NSString *r;
    switch (rank) {
        case ACE:
            r = @"Ace";
            break;
        case JACK:
            r = @"Jack";
            break;
        case QUEEN:
            r = @"Queen";
            break;
        case KING:
            r = @"King";
            break;
        default:
            r = [NSString stringWithFormat:@"%d", rank];
            break;
    }
    
    return [NSString stringWithFormat:@"%@ of %@", r, s];
}

- (id)copyWithZone:(NSZone *)zone
{
    return [[Card allocWithZone:zone] initWithRank:rank Suit:suit];
}

- (BOOL)isBlack
{
    return suit == SPADES || suit == CLUBS;
}

- (BOOL)isRed
{
    return suit == DIAMONDS || suit == HEARTS;
}

- (BOOL)isSameColor:(Card *)other
{
    return ([self isBlack] && [other isBlack]) || ([self isRed] && [other isRed]);
}

+ (NSArray *)deck
{
    NSMutableArray *deck = [[NSMutableArray alloc] init];
    for (uint i = ACE; i <= KING; i++) {
        for (uint j = SPADES; j <= HEARTS; j++) {
            Card *card = [[Card alloc] initWithRank:i Suit:j];
            [deck addObject:card];
        }
    }
    return deck;
}


@end
