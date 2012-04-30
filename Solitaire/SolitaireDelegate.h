//
//  SolitaireDelegate.h
//  Solitaire
//
//  Created by Travis Hall on 4/25/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol SolitaireDelegate <NSObject>

- (BOOL)movedFan:(NSArray *)fan toTableau:(uint)i;
- (BOOL)movedCard:(Card *)c toFoundation:(uint)i;
- (void)moveStockToWaste;
- (BOOL)flipCard:(Card *)c;

@end
