//
//  PlayingDeck.m
//  Matchismo
//
//  Created by Noam Ohana on 03/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "PlayingDeck.h"
#import "PlayingCard.h"

@interface PlayingDeck()
@end

@implementation PlayingDeck

- (instancetype) init
{
    self = [super init];
    
    if(self)
    {
        for (NSString *suit in [PlayingCard validSuits])
        {
            for(NSUInteger rank = 1; rank <= [PlayingCard maxRank]; ++rank)
            {
                PlayingCard* card = [[PlayingCard alloc] init];
                card.rank = rank;
                card.suit = suit;
                [self addCard:card];
            }
        }
    }
    return self;
}

@end
