//
//  Card.m
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "Card.h"

@implementation Card
- (int)match:(NSArray*)otherCards
{
    int score = 0;
    for(Card* card in otherCards)
    {
        if([card.contents isEqualToString:self.contents])
        {
            score = 1;
            break;
        }
    }
    return score;
}
@end
