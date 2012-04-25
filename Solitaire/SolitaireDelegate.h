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

- (void)movedFan:(NSArray *)fan toTableau:(uint)i;
- (void)movedCard:(Card *)c toFoundation:(uint)i;

@end
