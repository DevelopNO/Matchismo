//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Noam Ohana on 03/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingDeck.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray* cards;
@property (nonatomic, strong) NSMutableArray* cardForComparison; // temporary
@property (nonatomic, readwrite) NSUInteger mode;

@end

@implementation CardMatchingGame

-(NSMutableArray*) cards
{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (instancetype) initWithCardCount: (NSUInteger) count usingDeck:(Deck*)deck NSUInteger:mode
{
    self = [super init];
    if(self)
    {
        for(int i = 0; i < count; ++i)
        {
            Card* card = [deck drawRandomCard];
            if(card)
            {
                [self.cards addObject:card];
            }
            else
            {
                self = nil;
                break;
            }
        }
        self.mode = mode;
    }
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void) chooseCardAtIndex: (NSUInteger) index
{
    Card* card = [self cardAtIndex:index];
    
    if(!card.isMatched)
    {
        if(card.isChosen)
        {
            card.isChosen = NO;
            [self.cardForComparison removeObject:card]; // if object not there - shouldn't be an effect
        }
        else // match against other cards
        {
            [self.cardForComparison addObject:card];
            if([self.cardForComparison count] == self.mode)
            {
                for(int i = 0; i < [self.cardForComparison count] - 2; ++i)
                {
                    Card* refCard = [self cardAtIndex:i];
                    NSArray* arrayForMatching = [self.cardForComparison subarrayWithRange:NSMakeRange(i + 1, [self.cardForComparison count] - 1)];
                    [refCard match:arrayForMatching];
                }
            }
            for(Card* otherCard in self.cards)
            {
                if(otherCard.isChosen && !otherCard.isMatched)
                {
                    int matchScore = [card match:@[otherCard]];
                    if(matchScore)
                    {
                        self.score += matchScore * MATCH_BONUS;
                        otherCard.isMatched = YES;
                        card.isMatched = YES;
                    }
                    else
                    {
                        self.score -= MISMATCH_PENALTY;
                        otherCard.isChosen = NO;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            card.isChosen = YES;
        }
    }
}
- (Card*) cardAtIndex: (NSUInteger) index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}


@end
