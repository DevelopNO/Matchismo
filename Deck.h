//
//  Deck.h
//  Matchismo
//
//  Created by Noam Ohana on 03/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#ifndef Deck_h
#define Deck_h

#import "Card.h"

@interface Deck : NSObject

- (void) addCard:(Card*) card atTop:(BOOL)atTop;
- (void) addCard:(Card*) card;

- (Card*) drawRandomCard;

@end

#endif /* Deck_h */
