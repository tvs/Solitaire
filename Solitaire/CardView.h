//
//  CardView.h
//  Solitaire
//
//  Created by Travis Hall on 4/25/12.
//  Copyright (c) 2012 Travis Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface CardView : UIView

@property (strong, nonatomic) UIImage *cardImage;
@property (strong, nonatomic) Card *card;

- (id)initWithFrame:(CGRect)frame andCard:(Card *)c;

- (NSUInteger)hash;
- (BOOL)isEqual:(id)other;

+ (UIImage *)backImage;

@end
