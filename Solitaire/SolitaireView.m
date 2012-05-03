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
#define BUFFER 2

#define DIFF_TAB_FOUND (NUM_TABLEAUS - NUM_FOUNDATIONS)

@implementation SolitaireView {
    CardView *_backFoundation[NUM_FOUNDATIONS];
    CardView *_backTableaux[NUM_TABLEAUS];
    CardView *_backStock;
    
    CGFloat _w;
    CGFloat _h;
    CGFloat _s;
    CGFloat _f;
    
    CGPoint touchStartPoint;
    CGPoint startCenter;
}

@synthesize game = _game;
@synthesize delegate = _delegate;
@synthesize cards = _cards;

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
    [UIView animateWithDuration:0.2 animations:^{
        CardView *cv;
        for (int i = _game.stock.count - 1; i >= 0; i--) {
            Card *c = [_game.stock objectAtIndex:i];
            cv = [_cards objectForKey:c];
            cv.frame = CGRectMake(MARGIN, MARGIN, _w, _h);
            [cv setNeedsDisplay];
            [self bringSubviewToFront:cv];
        }
        
        CGFloat wasteX = MARGIN + _w + BUFFER;
        CGFloat wasteY = MARGIN;
        for (Card *c in _game.waste) {
            cv = [_cards objectForKey:c];
            cv.frame = CGRectMake(wasteX, wasteY, _w, _h);
            [self bringSubviewToFront:cv];
        }
        
        for (int i = 0; i < NUM_TABLEAUS; i++) {
            CGFloat tableauX = MARGIN + ((i * (_w + 2 * BUFFER)) - BUFFER);
            NSArray *tab = [_game tableau:i];
            for (int j = 0; j < [tab count]; j++) {
                Card *c = [tab objectAtIndex:j];
                CGFloat tableauY = MARGIN + _h + _s + (j * _f);
                cv = [_cards objectForKey:c];
                cv.frame = CGRectMake(tableauX, tableauY, _w, _h);
                [self bringSubviewToFront:cv];
            }
        }
        
        for (int i = 0; i < NUM_FOUNDATIONS; i++) {
            CGFloat foundationX = MARGIN + (((i+DIFF_TAB_FOUND) * (_w + 2 * BUFFER)) - BUFFER);
            for (Card *c in [_game foundation:i]) {
                cv = [_cards objectForKey:c];
                cv.frame = CGRectMake(foundationX, MARGIN, _w, _h);
                [self bringSubviewToFront:cv];
            }
        }
    }];
    
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view
{
    touchStartPoint = [[touches anyObject] locationInView:self];
    startCenter = view.center;
    
    Card *card = [(CardView *)view card];
    
    if ([_game.stock containsObject:card] || (CardView *)view == _backStock) {
        [_delegate moveStockToWaste];
        Card *newTop = (Card *) [_game.waste lastObject];
        [(CardView *)[_cards objectForKey:newTop] setNeedsDisplay];
        Card *newStock = (Card *) [_game.stock lastObject];
        [(CardView *)[_cards objectForKey:newStock] setNeedsDisplay];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view
{
    CGPoint touchPoint = [[touches anyObject] locationInView:self];
    CGPoint delta = CGPointMake(touchPoint.x - touchStartPoint.x, touchPoint.y - touchStartPoint.y);
    CGPoint newCenter = CGPointMake(startCenter.x + delta.x, startCenter.y + delta.y);
    
    Card *card = [(CardView *)view card];
    
    NSArray *fan = [_game fanBeginningWithCard:card];
    
    if (fan == nil && _game.waste.lastObject == card) {
        CardView *cv = [_cards objectForKey:card];
        cv.center = CGPointMake(newCenter.x, newCenter.y);
        [self bringSubviewToFront:cv];
    } else {    
        for (int i = 0; i < fan.count; i++) {
            Card *c = [fan objectAtIndex:i];
            CardView *cv = [_cards objectForKey:c];
            cv.center = CGPointMake(newCenter.x, newCenter.y + (i * _f));
            [self bringSubviewToFront:cv];
        }
    }
}

- (void)showCongratulations {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congratulations!"
                                                      message:@"You have won!"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view
{
    [self computeLayoutSubviews];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view
{
    Card *card = [(CardView *)view card];
    
    if (!card.faceUp) {
        if ([_delegate flipCard:card]) {
            NSLog(@"Flip a card!");
            [(CardView *)[_cards objectForKey:card] setNeedsDisplay];
        }
        [self computeLayoutSubviews];
    } else {
        BOOL changed = NO;
        
        NSArray *fan = [_game fanBeginningWithCard:card];
        
        if (fan == nil) {
            fan = [[NSArray alloc] initWithObjects:card, nil];
        }
        
        // Move to full tableauxs
        for (int i = 0; i < NUM_TABLEAUS; i++) {
            NSArray *tab = [_game tableau:i];
            for (int j = 0; j < [tab count]; j++) {
                CardView *otherView = [_cards objectForKey:[tab objectAtIndex:j]];
                
                if (view == otherView) continue;
                
                if (CGRectIntersectsRect(view.frame, otherView.frame)) {
                    NSLog(@"touchesEnded: movedFan!");
                    if ([_delegate movedFan:fan toTableau:i]) {
                        changed = YES;
                    }
                }
            }
        }
        
        if (!changed){
            // Move to the blank tableaux
            for (int i = 0; i < NUM_TABLEAUS; i++) {
                CardView *otherView = _backTableaux[i];
                if (CGRectIntersectsRect(view.frame, otherView.frame)) {
                    NSLog(@"touchesEnded: movedFan!");
                    if ([_delegate movedFan:fan toTableau:i]) {
                        changed = YES;
                    }
                }

            }
        }
        
        
        if (!changed) {
            // If only one card, move to foundations
            if ([fan count] == 1) {    
                for (int i = 0; i < NUM_FOUNDATIONS; i++) {
                    CardView *otherView = _backFoundation[i];
                    if (CGRectIntersectsRect(view.frame, otherView.frame)) {
                        if ([_delegate movedCard:card toFoundation:i]) {
                            changed = YES;
                        }
                    }
                }
            }
        }
    }
    
    
    if ([_game gameWon]) {
        [self showCongratulations];
        NSLog(@"Congratulations!");
    }
    [self computeLayoutSubviews];
}

- (BOOL)canBecomeFirstResponder
{ return YES; }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
