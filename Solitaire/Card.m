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

}


- (id)copyWithZone:(NSZone *)zone
{

}


- (BOOL)isBlack
{

}

- (BOOL)isRed
{

}

- (BOOL)isSameColor:(Card *)other
{

}


+ (NSArray *)deck
{

}


@end
