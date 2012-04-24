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
    return [NSString stringWithFormat:@"%d of %@", rank, s];
}

- (id)copyWithZone:(NSZone *)zone
{
    Card *copy = [[[self class] allocWithZone:zone] initWithRank:rank Suit:suit];
    return copy;
}

- (BOOL)isBlack
{
    if (suit == SPADES || suit == CLUBS) {
        return YES;
    }
    return NO;
}

- (BOOL)isRed
{
    if (suit == DIAMONDS || suit == HEARTS) {
        return YES;
    }
    return NO;
}

- (BOOL)isSameColor:(Card *)other
{
    if (suit == [other suit])
        return YES;
    return NO;
}

+ (NSArray *)deck
{
    NSMutableArray *deck = [[NSMutableArray alloc] initWithCapacity:52];
    for (uint i = 0; i <= KING; i++) {
        for (uint j = SPADES; j <= HEARTS; j++) {
            Card *card = [[Card alloc] initWithRank:i Suit:j];
            [deck addObject:card];
        }
    }
    return deck;
}


@end
