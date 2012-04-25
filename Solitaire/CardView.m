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
        card = c;
        cardImage = [UIImage imageNamed:[c description]];
        self.opaque = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (card.faceUp)
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

@end
