//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
#import "Grid.h"

static const int INITIAL_CARD_COUNT = 12;
static const CGFloat WIDTH_HEIGHT_RATIO = 0.5;

@interface PlayingCardGameViewController()
@end

@implementation PlayingCardGameViewController

- (Deck*) createDeck
{
  return [[PlayingDeck alloc] init];
}


- (NSInteger) getInitialNumber
{
  return INITIAL_CARD_COUNT;
}

- (void) createCards
{
  for(int i = 0; i < INITIAL_CARD_COUNT; ++i)
  {
    //PlayingCardView *cardView = [PlayingCardView alloc] ini

  }
  //self.cards addObject:<#(nonnull id)#>
}

- (void) setGridDimensions
{
  self.gridOfCards.size = super.CardsSpace.bounds.size;
  self.gridOfCards.cellAspectRatio = WIDTH_HEIGHT_RATIO;
  self.gridOfCards.minimumNumberOfCells = INITIAL_CARD_COUNT;
  
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  [self setGridDimensions];
  [self createCards];
}

- (CardMatchingGame*) game
{
  if(!super.game)
  {
      super.game = [[CardMatchingGame alloc] initWithCardCount:INITIAL_CARD_COUNT usingDeck:[self createDeck] inMode:2];
  }
  return super.game;
}
@end


