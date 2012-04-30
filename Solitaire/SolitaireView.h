//
//  SolitaireView.h
//  Solitaire
//
//  Created by Travis Hall on 4/25/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Solitaire.h"
#import "SolitaireDelegate.h"

@interface SolitaireView : UIView

@property (strong,nonatomic) Solitaire *game;
@property (weak,nonatomic) IBOutlet id <SolitaireDelegate> delegate;

- (void)iterateGameWithBlock:(void (^)(Card *c))block;
- (void)addCardViewToSubview:(Card *)c;
- (void)computeLayoutSubviews;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event andView:(UIView *)view;

@end
