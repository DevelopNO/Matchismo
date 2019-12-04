//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Noam Ohana on 03/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#ifndef CardMatchingGame_h
#define CardMatchingGame_h

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

- (instancetype) initWithCardCount: (NSUInteger) count usingDeck:(Deck*)deck inMode:(NSUInteger)mode;
- (void) chooseCardAtIndex: (NSUInteger) index;
- (Card*) cardAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSUInteger mode; // number of cards compared
@end

#endif /* CardMatchingGame_h */
