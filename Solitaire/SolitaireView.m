//
//  SolitaireView.m
//  Solitaire
//
//  Created by Travis Hall on 4/25/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import "SolitaireView.h"
#import "Card.h"
#import "CardView.h"

@implementation SolitaireView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    Card *c = [[Card alloc] initWithRank:KING Suit:HEARTS];
//    c.faceUp = YES;
    CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(20, 20, 150, 215) andCard:c];
    [self addSubview:cardView];
    
    Card *c1 = [[Card alloc] initWithRank:KING Suit:HEARTS];
    c1.faceUp = YES;
    CardView *cardView1 = [[CardView alloc] initWithFrame:CGRectMake(20, 20, 150, 215) andCard:c1];
    [self addSubview:cardView1];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
