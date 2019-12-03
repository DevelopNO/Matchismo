//
//  Deck.m
//  Matchismo
//
//  Created by Noam Ohana on 03/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray* cards;
@end

@implementation Deck

- (void) addCard:(Card *)card
{
    [self addCard:card atTop:NO];
}

-(void) addCard:(Card *)card atTop:(BOOL)atTop
{
    if(atTop)
    {
        [self.cards insertObject:card atIndex:0];
    }
    else
    {
        [self.cards addObject:card];
    }
}

- (NSMutableArray*) cards
{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (Card*) drawRandomCard
{
    Card* randomCard = nil;
    
    if([self.cards count] > 0)
    {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    return randomCard;
}
@end
