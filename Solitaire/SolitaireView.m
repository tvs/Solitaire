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

@implementation SolitaireView {
    NSMutableSet *_cards;
}

@synthesize game = _game;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setGame:(Solitaire *)game
{
    _game = game;
    _cards = [[NSMutableSet alloc] init];
    
    [self iterateGameWithBlock:^(Card *c) {
        [self addCardViewToSubview:c];
    }];
}

- (void)iterateGameWithBlock:(void (^)(Card *c))block
{
    if (_game == nil) return;
    
    for(Card *c in _game.stock) {
        block(c);
    }
    
    for (Card *c in _game.waste) {
        block(c);
    }
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        for (Card *c in [_game tableau:i]) {
            block(c);
        }
    }
    
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        for (Card *c in [_game foundation:i]) {
            block(c);
        }
    }
}

- (void)addCardViewToSubview:(Card *)c
{
    CardView *v = [[CardView alloc] 
                   initWithFrame:CGRectMake(20, 20, 150, 215) 
                   andCard:c];
    
    [_cards addObject:v];
    [self addSubview:v];
}

- (void)awakeFromNib
{
//    Card *c = [[Card alloc] initWithRank:KING Suit:HEARTS];
////    c.faceUp = YES;
//    CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(20, 20, 150, 215) andCard:c];
//    [self addSubview:cardView];
//    
//    Card *c1 = [[Card alloc] initWithRank:KING Suit:HEARTS];
//    c1.faceUp = YES;
//    CardView *cardView1 = [[CardView alloc] initWithFrame:CGRectMake(20, 20, 150, 215) andCard:c1];
//    [self addSubview:cardView1];
}

- (void)layoutSubviews
{
    
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
