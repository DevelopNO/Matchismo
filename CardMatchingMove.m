//
//  CardMatchingMove.m
//  Matchismo
//
//  Created by Noam Ohana on 04/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "CardMatchingMove.h"

@interface CardMatchingMove()


@end


@implementation CardMatchingMove

- (instancetype) init: (int) matchedStatus cardsInMove:(NSArray*)cards
{
    self = [super init];
    
    if(self)
    {
        self.chosenCards = [[NSArray alloc] initWithArray:cards];
        self.moveStatus = matchedStatus;
    }
    return self;
}

@end
