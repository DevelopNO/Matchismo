//
//  CardMatchingMove.m
//  Matchismo
//
//  Created by Noam Ohana on 04/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "CardMatchingMove.h"

@interface CardMatchingMove()
@property (nonatomic, readwrite) MOVE_TYPE moveType;

@end


@implementation CardMatchingMove

- (instancetype) init: (MOVE_TYPE) matchedStatus cardsInMove:(NSArray*)cards
{
    self = [super init];
    
    if(self)
    {
        self.chosenCards = [[NSArray alloc] initWithArray:cards];
        self.moveType = matchedStatus;
    }
    return self;
}

@end
