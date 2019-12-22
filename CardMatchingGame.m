//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Noam Ohana on 03/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingDeck.h"
#import "CardMatchingMove.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray* cards;
@property (nonatomic, readwrite, strong) NSMutableArray* moves;
@property (nonatomic, strong) NSMutableArray* cardsForComparison; // temporary
@property (nonatomic, readwrite) NSUInteger mode;
@property (nonatomic, strong) Deck *deck;
-(void) setCardsForComparisonIsMatched: (BOOL) isMatched;
-(void) setCardsForComparisonIsChosen: (BOOL) isChosen;

@end

@implementation CardMatchingGame

-(NSMutableArray*) cardsForComparison
{
    if(!_cardsForComparison)
    {
        _cardsForComparison = [[NSMutableArray alloc] init];
    }
    return _cardsForComparison;
}

-(NSMutableArray*) moves
{
    if(!_moves)
    {
        _moves = [[NSMutableArray alloc] init];
    }
    return _moves;
}

-(NSMutableArray*) cards
{
    if(!_cards)
    {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

static const NSUInteger MIN_COMPARISON_MODE = 2;

- (instancetype) initWithCardCount: (NSUInteger) count usingDeck:(Deck*)deck inMode:(NSUInteger)mode
{
    self = [super init];
    if(self)
    {
        self.deck = deck;
        for(NSUInteger i = 0; i < count; ++i)
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
        
        if(mode < MIN_COMPARISON_MODE)
        {
            self = nil;
        }
        else
        {
            self.mode = mode;
        }
    }
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (int)compareCards
{
  Card* refCard = self.cardsForComparison[0];
  NSArray* arrayForMatching = [self.cardsForComparison subarrayWithRange:NSMakeRange(1, [self.cardsForComparison count] - 1)];
  int singleComparisonScore = [refCard match:arrayForMatching];
  return singleComparisonScore;
}

- (BOOL)setScore:(int *)moveScore singleComparisonScore:(int)singleComparisonScore
{
  BOOL isAnyMatched = NO;
  if(singleComparisonScore)
  {
    self.score += MATCH_BONUS * singleComparisonScore;
    isAnyMatched = YES;
    if(moveScore)
    {
      *moveScore = singleComparisonScore * MATCH_BONUS;
    }

  }
  else
  {
    self.score -= MISMATCH_PENALTY;
    if(moveScore)
    {
      *moveScore = -1 * MISMATCH_PENALTY;
    }

  }
  return isAnyMatched;
}

- (BOOL)CompareChosenCards: (int *)moveScore
{
  int singleComparisonScore = [self compareCards];
  
  BOOL isAnyMatched = [self setScore:moveScore singleComparisonScore:singleComparisonScore];

  return isAnyMatched;
}

- (void)setCardsStates:(Card *)card isAnyMatched:(BOOL)isAnyMatched moveScore:(int) score
{
    if(isAnyMatched)
    {
      [self.moves addObject:[[CardMatchingMove alloc] init: MATCH cardsInMove:[self.cardsForComparison copy] score:score]];
      [self setCardsForComparisonIsMatched:YES];
      [self.cardsForComparison removeAllObjects];
    }
    else
    {
      [self.moves addObject:[[CardMatchingMove alloc] init: NO_MATCH cardsInMove:[self.cardsForComparison copy] score:score]];
      [self setCardsForComparisonIsChosen:NO];
      card.isChosen = YES;
      [self.cardsForComparison removeAllObjects];
      [self.cardsForComparison addObject:card];
    }
}

- (void) chooseCardAtIndex: (NSUInteger) index
{
  Card* card = [self cardAtIndex:index];
    
  if(!card.isMatched)
  {
    if(card.isChosen)
    {
      card.isChosen = NO;
      [self.cardsForComparison removeObject:card]; // if object not there - shouldn't be an effect
      [self.moves addObject:[[CardMatchingMove alloc] init: CARD_CLOSED cardsInMove:@[card] score:0]];
    }
    else // match against other cards
    {
        
      BOOL isAnyMatched = NO;
      [self.cardsForComparison addObject:card];
      card.isChosen = YES;
      [self.moves addObject:[[CardMatchingMove alloc] init: CARD_OPENED cardsInMove:@[card] score:0]];
      if([self.cardsForComparison count] == self.mode)
      {
        int score;
        isAnyMatched = [self CompareChosenCards:&score];
        [self setCardsStates:card isAnyMatched:isAnyMatched moveScore:score];
      }
      self.score -= COST_TO_CHOOSE;
    }
  }
  else
  {
    NSLog(@"Card is already matched index: %lu", index);
  }
}

-(void) setCardsForComparisonIsMatched: (BOOL) isMatched
{
    for(Card* card in self.cardsForComparison)
    {
        card.isMatched = isMatched;
    }

}


-(void) setCardsForComparisonIsChosen: (BOOL) isChosen
{
    for(Card* card in self.cardsForComparison)
    {
        card.isChosen = isChosen;
    }

}

- (Card*) cardAtIndex: (NSUInteger) index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (Card*) addCardsToGame
{
  Card* newCard = [self.deck drawRandomCard];
  
  
  int availableIndex = [self findIsMatched];
  if(availableIndex >= 0)
  {
    [self.cards replaceObjectAtIndex:availableIndex withObject:newCard];
  }
  else
  {
    [self.cards addObject:newCard];
  }

  return newCard;
}

- (int) findIsMatched
{
  for(int i = 0; i < [self.cards count]; ++i)
  {
    Card *card = self.cards[i];
    if(card && card.isMatched)
    {
      return i;
    }
  }
  return -1;
}

@end
