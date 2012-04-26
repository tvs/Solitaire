//
//  CardView.m
//  Solitaire
//
//  Created by Travis Hall on 4/25/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import "CardView.h"
#import "Card.h"

@implementation CardView {
CGPoint touchStartPoint;
CGPoint startCenter;
}

@synthesize cardImage;
@synthesize card;

- (id)initWithFrame:(CGRect)frame andCard:(Card *)c
{
    self = [super initWithFrame:frame];
    if (self) {
        if (c != nil){
            card = c;
            cardImage = [UIImage imageNamed:[c description]];
        } else {
            // Blank card
            cardImage = [CardView emptyImage];
            [self setUserInteractionEnabled:NO];
        }
        self.opaque = NO;
    }
    return self;
}

- (NSUInteger)hash
{
    return [card hash];
}

- (BOOL)isEqual:(id)other
{
    // Return equivalent if the subview contains the card
    // Lets us do lookup in the mutable set for the view containing a card
    if ([other class] == [Card class]) {
        return [card isEqual:other];
    }
    
    return [card isEqual:[other card]];
}

// TODO Add UI Image view and put image in there
- (void)drawRect:(CGRect)rect
{
    if (card == nil || card.faceUp)
        [self.cardImage drawInRect:rect];
    else
        [[CardView backImage] drawInRect:rect];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    touchStartPoint = [[touches anyObject] locationInView:self.superview];
    startCenter = self.center;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.superview]; 
    CGPoint delta = CGPointMake(touchPoint.x - touchStartPoint.x, touchPoint.y - touchStartPoint.y);
    CGPoint newCenter = CGPointMake(startCenter.x + delta.x, startCenter.y + delta.y);
    self.center = newCenter;
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

// Keep this as a static class variable since we only need one for every instance
+ (UIImage *)backImage
{
    static UIImage *backImage = nil;
    if (backImage == nil) {
        backImage = [UIImage imageNamed:@"back-red-150-2"];
    }
    return backImage;
}

+ (UIImage *)emptyImage
{
    static UIImage *emptyImage = nil;
    if (emptyImage == nil) {
        emptyImage = [UIImage imageNamed:@"empty"];
    }
    return emptyImage;
}

@end
