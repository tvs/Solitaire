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


#define MARGIN 20
#define BUFFER 4

#define DIFF_TAB_FOUND (NUM_TABLEAUS - NUM_FOUNDATIONS)

@implementation SolitaireView {
    NSMutableDictionary *_cards;
    
    CardView *_backFoundation[NUM_FOUNDATIONS];
    CardView *_backTableaux[NUM_TABLEAUS];
    CardView *_backStock;
    
    CGFloat _w;
    CGFloat _h;
    CGFloat _s;
    CGFloat _f;
}

@synthesize game = _game;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initializeStuff];
    }
    return self;
}

- (void)awakeFromNib
{
    [self initializeStuff];
}

- (void)initializeStuff
{
    [self computeSizes];

    _backStock = [[CardView alloc] initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _h) andCard:nil];

    CGFloat tableauY = MARGIN + _h + _s;
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tableauX = MARGIN + ((i * (_w + 2 * BUFFER)) - BUFFER);
        CardView *v = [[CardView alloc] initWithFrame:CGRectMake(tableauX, tableauY, _w, _h) andCard:nil];
        _backTableaux[i] = v;
    }
    
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        CGFloat foundationX = MARGIN + (((i+DIFF_TAB_FOUND) * (_w + 2 * BUFFER)) - BUFFER);
        CardView *v = [[CardView alloc] initWithFrame:CGRectMake(foundationX, MARGIN, _w, _h) andCard:nil];
        _backFoundation[i] = v;
    }
}

- (void)addBottomCardsToSubview
{
    [self addSubview:_backStock];
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        [self addSubview:_backTableaux[i]];
    }
    
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        [self addSubview:_backFoundation[i]];
    }
}

- (void)setGame:(Solitaire *)game
{
    _game = game;
    _cards = [[NSMutableDictionary alloc] init]; 
    
    // Clear out the view so each setup is in proper layer order
    for (UIView *v in self.subviews) {
        [v removeFromSuperview];
    }
    
    [self addBottomCardsToSubview];
    
    [self iterateGameWithBlock:^(Card *c) {
        [self addCardViewToSubview:c];
    }];
    
    [self computeLayoutSubviews];
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
                   initWithFrame:CGRectMake(MARGIN, MARGIN, _w, _h) 
                   andCard:c];    
    [_cards setObject:v forKey:c];
    [self addSubview:v];
}

- (void)computeSizes
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    _w = ((width - 2*MARGIN)/7.0) - BUFFER;
    _h = (height - 2*MARGIN)/5.5;
    _s = _h/2.0;
    _f = _h/4.0;
}

// NOTE Layout subviews that requires manual calls (so we dont wind up with layering issues)
- (void)computeLayoutSubviews
{
    CardView *cv;
    for (Card *c in _game.stock) {
        cv = [_cards objectForKey:c];
        cv.frame = CGRectMake(MARGIN, MARGIN, _w, _h);
    }
    
    CGFloat wasteX = MARGIN + _w + BUFFER;
    CGFloat wasteY = MARGIN;
    for (Card *c in _game.waste) {
        cv = [_cards objectForKey:c];
        cv.frame = CGRectMake(wasteX, wasteY, _w, _h);
    }
    
    for (int i = 0; i < NUM_TABLEAUS; i++) {
        CGFloat tableauX = MARGIN + ((i * (_w + 2 * BUFFER)) - BUFFER);
        NSArray *tab = [_game tableau:i];
        for (int j = 0; j < [tab count]; j++) {
            Card *c = [tab objectAtIndex:j];
            CGFloat tableauY = MARGIN + _h + _s + (j * _f);
            cv = [_cards objectForKey:c];
            cv.frame = CGRectMake(tableauX, tableauY, _w, _h);
        }
    }
    
    for (int i = 0; i < NUM_FOUNDATIONS; i++) {
        CGFloat foundationX = MARGIN + (((i+DIFF_TAB_FOUND) * (_w + 2 * BUFFER)) - BUFFER);
        for (Card *c in [_game foundation:i]) {
            cv = [_cards objectForKey:c];
            cv.frame = CGRectMake(foundationX, MARGIN, _w, _h);
        }
    }
    
    [self setNeedsDisplay];
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
