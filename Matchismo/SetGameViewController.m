//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//


#import "SetGameViewController.h"
#import "HistoryViewController.h"
#import "CardMatchingGame.h"
#import "SetCard.h"
#import "SetDeck.h"
#import "CardMatchingMove.h"
#import "SetCardView.h"
#import "Grid.h"

static const int INITIAL_CARD_COUNT = 12;

@interface SetGameViewController ()

@end
// add behaviour for adding cards
// add tap (for choosing) and background change
// add disapearing behaviour


@implementation SetGameViewController


- (IBAction)chooseCard:(UITapGestureRecognizer *)sender {
  [super chooseCard:sender];
}

-(NSUInteger) availableSpots
{
  NSUInteger availableSpots = 0;
  for(int i = 0; i < [self.cardViews count] ; ++i)
  {
    if([self.cardViews[i] isEqual:[NSNull null]])
    {
      ++availableSpots;
    }
  }
  return availableSpots;
}

static const NSUInteger NUMBER_CARDS_IN_SINGLE_EDITION = 12;

- (IBAction)Addmorecards:(UIButton *)sender
{
  NSUInteger available = [self availableSpots];
  if(available >= NUMBER_CARDS_IN_SINGLE_EDITION)
  {
    return;
  }
  
  NSUInteger availableInGrid = [self.cardsGrid rowCount] * [self.cardsGrid columnCount] - [self.cardViews count];
  
  if((available + availableInGrid) >= NUMBER_CARDS_IN_SINGLE_EDITION)
  {
    // if stayed - add to current grid
      // first - add to missing spaces

    return;
  }
  
//  recalculateGrid;
//  addAll;
}

- (void) createCards
{
  int cardIndex = 0;
  for(int row = 0; row < self.cardsGrid.rowCount ; ++row)
  {
    for(int column = 0; column < self.cardsGrid.columnCount; ++column)
    {
      CGRect rect = [self.cardsGrid frameOfCellAtRow:row inColumn:column];

      SetCardView *cardView = [[SetCardView alloc] initWithFrame:CGRectMake(3 * self.rightBottomCornerOrigin.x, 3 * self.rightBottomCornerOrigin.y, rect.size.width, rect.size.height)];

      Card* card = [self.game cardAtIndex:cardIndex];

      if([card isKindOfClass:[SetCard class]])
      {
        SetCard *setCard = (SetCard *) card;
        cardView.numberOfShapes = setCard.number;
        cardView.color = setCard.color;
        cardView.fill = setCard.fill;
        cardView.shape = setCard.shape;
        
        
        // index in array would indicate position in grid
        // currentRow = indexInArray / nColums
        // currentCoulmn = IndexInArray - currentRow * nColums

        [self.cardViews addObject:cardView];
[self.CardsSpace addSubview:cardView];
        [self animateCreation:cardView rect:rect delay:0.5];

        
        ++cardIndex;
        if(cardIndex >= INITIAL_CARD_COUNT) // should change on run time
        {
          return;
        }
        
      }
    }
  }
}

- (int) initialNumberOfCards
{
  return 12;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setGridDimensions];
  [self createCards];
  
}

- (IBAction)reDeal:(UIButton *)sender
{
  [super redeal];
  [self removeAllCards];
  [self updateUI];
  [self createCards];
}

- (NSInteger) getMode
{
  return 3;
}


- (void) cardChosenAnimation: (UIView *) cardView isChosen: (BOOL) chosen
{
  [UIView animateWithDuration:0.3
  animations:^(void) {
    SetCardView *setCardView = (SetCardView *) cardView;
    setCardView.isChosen = chosen;
  }
  completion:nil];
}

- (Deck*) createDeck
{
  return [[SetDeck alloc] init];
}

- (UIImage* ) backgroundOfCard: (Card*) card
{
  return [UIImage imageNamed:card.isChosen ? @"setCardSelected" : @"cardFront"];
}


+ (void) appendStringToAttributed: (NSMutableAttributedString *) attr string:(NSString *) text
{
  [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithString:text]]];
  
}



@end
