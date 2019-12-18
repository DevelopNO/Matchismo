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
#import "PlayingCard.h"
#import "Grid.h"

static const int INITIAL_CARD_COUNT = 16;
static const CGFloat WIDTH_HEIGHT_RATIO = 0.66;

@interface PlayingCardGameViewController()
@end

@implementation PlayingCardGameViewController

- (Deck*) createDeck
{
  return [[PlayingDeck alloc] init];
}

- (NSUInteger)calculateWhichCard: (CGPoint) location
{
  NSUInteger row = [self.gridOfCards getRowByPoint:location];
  NSUInteger column = [self.gridOfCards getColumnByPoint:location];
  return row * [self.gridOfCards columnCount] + column;
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender
{
  CGPoint pointOfTouch = [sender locationInView:self.CardsSpace];
  NSUInteger index = [self calculateWhichCard: pointOfTouch];
  
  PlayingCardView* cardView = self.cards[index];
  cardView.facedUp = !cardView.facedUp;
}

- (NSInteger) getInitialNumber
{
  return INITIAL_CARD_COUNT;
}

- (void) createCards
{
  int cardIndex = 0;
  for(int row = 0; row < self.gridOfCards.rowCount ; ++row)
  {
    for(int column = 0; column < self.gridOfCards.columnCount; ++column)
    {
      CGRect rect = [self.gridOfCards frameOfCellAtRow:row inColumn:column];

      PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:rect];
      Card* card = [self.game cardAtIndex:cardIndex];
      
      if([card isKindOfClass:[PlayingCard class]])
      {
        PlayingCard *playingCard = (PlayingCard *) card;
        cardView.rank = playingCard.rank;
        cardView.suit = playingCard.suit;
        
        // index in array would indicate position in grid
        // currentRow = indexInArray / nColums
        // currentCoulmn = IndexInArray - currentRow * nColums
        
        [self.cards addObject:cardView];
        [self.CardsSpace addSubview:cardView];
        ++cardIndex;
        if(cardIndex >= INITIAL_CARD_COUNT) // should change on run time
        {
          return;
        }
        
      }
    }
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


