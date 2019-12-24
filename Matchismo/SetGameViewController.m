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
static const NSUInteger CARDS_IN_SINGLE_EDITION = 3;
static const NSUInteger MAX_NUMBER_OF_CARDS = 81;

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;

@end


@implementation SetGameViewController

- (void) viewDidLayoutSubviews
{
  
}

- (IBAction)chooseCard:(UITapGestureRecognizer *)sender
{
  [super chooseCard:sender];
}

#pragma mark Add Cards

- (IBAction)addMoreCards:(UIButton *)sender
{
  [self disableAddingCardsIfExceedsMax:sender];
  if([self.cardViews count] + CARDS_IN_SINGLE_EDITION > MAX_NUMBER_OF_CARDS)
  {
    return;
  }
  NSUInteger available = [self getNumberOfAvailableSpots];
  if(available >= CARDS_IN_SINGLE_EDITION)
  {
      [self addInsteadOfMatchedCards];
    return;
  }
  
  NSUInteger availableInGrid = [self.cardsGrid rowCount] * [self.cardsGrid columnCount] - [self.cardViews count];
  
  if((available + availableInGrid) >= CARDS_IN_SINGLE_EDITION)
  {
      [self addInsteadOfMissingAndWhereAvailableOnGrid];
    return;
  }

  [self recalculateGridAndAddNewCards];
  
}
- (void)disableAddingCardsIfExceedsMax:(UIButton *)sender
{
  if([self.cardViews count] + CARDS_IN_SINGLE_EDITION * 2 > MAX_NUMBER_OF_CARDS)
  {
    sender.enabled = NO;
    return;
  }
}

-(NSUInteger) getNumberOfAvailableSpots
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

- (int) addInsteadOfMatchedCards
{
  int viewsThatAdded = 0;
  for(int i = 0; i < [self.cardViews count] && viewsThatAdded < CARDS_IN_SINGLE_EDITION; ++i)
  {
    if(![self isNull:self.cardViews[i]])
    {
      continue;
    }
    Card *card = [self.game addCardsToGame];
    if(card == nil)
    {
      self.addCardButton.enabled = NO;
      return viewsThatAdded;
    }
        
    if([card isKindOfClass:[SetCard class]])
    {
      CGPoint point = [self calculatePointFromIndex:i];
      CGRect cellRect = [self.cardsGrid frameOfCellAtRow:point.y inColumn:point.x];
      [self createSetCard:card fromRect:cellRect atIndex:i];
      ++viewsThatAdded;
    }
  }
  return viewsThatAdded;
}

- (void)createSetCard:(Card *)card fromRect:(CGRect)cellRect atIndex:(int)i
{
  SetCardView *cardView = [self createSetCardView:cellRect.size];
  [self updateSetCardValues:card cardView:cardView];
  [self.cardViews replaceObjectAtIndex:i withObject:cardView];
  [self saveAndPresentCard:cardView rect:cellRect];
}

- (int)addToGrid:(int)viewsThatAdded {
  while(viewsThatAdded < CARDS_IN_SINGLE_EDITION)
  {
    CGPoint point = [self calculatePointFromIndex:[self.cardViews count]];
    CGRect rect = [self.cardsGrid frameOfCellAtRow:point.y inColumn:point.x];
    Card *card = [self.game addCardsToGame];
    if([card isKindOfClass:[SetCard class]])
    {
      [self addCardViewToTheEndOfCollection:card rect:rect];
      ++viewsThatAdded;
    }
  }
  return viewsThatAdded;
}

-(int) addInsteadOfMissingAndWhereAvailableOnGrid
{
  int viewsThatAdded = [self addInsteadOfMatchedCards];
  return [self addToGrid:viewsThatAdded];
}


- (void) recalculateGridAndAddNewCards
{
  self.cardsGrid.minimumNumberOfCells = [self.cardViews count] + CARDS_IN_SINGLE_EDITION;
  if(self.cardsGrid.inputsAreValid)
  {
    [self repositionCards];
    [self addToGrid:0];
    return;
  }
  self.cardsGrid.minimumNumberOfCells = [self.cardViews count];
  
}

- (void) repositionCards
{
  for(NSUInteger i = 0; i < [self.cardViews count]; ++i)
  {
    CGPoint pointInGrid = [self calculatePointFromIndex:i];
    CGRect newRectForCard = [self.cardsGrid frameOfCellAtRow:pointInGrid.y inColumn:pointInGrid.x];
    SetCardView *cardView = self.cardViews[i];
    cardView.frame = newRectForCard;
  }
}

#pragma mark - Create cards

- (void)updateSetCardValues:(Card *)card cardView:(SetCardView *)cardView
{
    SetCard *setCard = (SetCard *) card;
    cardView.numberOfShapes = setCard.number;
    cardView.color = setCard.color;
    cardView.fill = setCard.fill;
    cardView.shape = setCard.shape;
}

- (SetCardView *)createSetCardView:(CGSize) size
{
    return [[SetCardView alloc] initWithFrame:CGRectMake(3 * self.rightBottomCornerOrigin.x, 3 * self.rightBottomCornerOrigin.y, size.width, size.height)];
}

- (void)saveAndPresentCard:(SetCardView *)cardView rect:(CGRect)rect
{
    [self.CardsSpace addSubview:cardView];
    [self animateCreation:cardView rect:rect delay:0.5];
}

- (void)addCardViewToTheEndOfCollection:(Card *)card rect:(const CGRect)rect
{
  SetCardView *cardView = [self createSetCardView:rect.size];
  [self updateSetCardValues:card cardView:cardView];
  [self.cardViews addObject:cardView];
  [self saveAndPresentCard:cardView rect:rect];
}

- (void) createCards
{
  int cardIndex = 0;
  for(int row = 0; row < self.cardsGrid.rowCount ; ++row)
  {
    for(int column = 0; column < self.cardsGrid.columnCount; ++column)
    {
      CGRect rect = [self.cardsGrid frameOfCellAtRow:row inColumn:column];

      Card* card = [self.game cardAtIndex:cardIndex];

      if([card isKindOfClass:[SetCard class]])
      {
        [self addCardViewToTheEndOfCollection:card rect:rect];

        ++cardIndex;
        if(cardIndex >= INITIAL_CARD_COUNT) // should change on run time
        {
          return;
        }

      }
    }
  }
}

#pragma mark - Game configurations

- (NSInteger) getInitialNumber
{
  return [self initialNumberOfCards];
}

- (int) initialNumberOfCards
{
  return INITIAL_CARD_COUNT;
}

- (NSInteger) getMode
{
  return 3;
}

- (Deck*) createDeck
{
  return [[SetDeck alloc] init];
}

#pragma mark - UIView class overrides
- (void)viewDidLoad
{
  [super viewDidLoad];
  [self setGridDimensions];
  [self createCards];
  
}

# pragma mark Redeal

- (IBAction)reDeal:(UIButton *)sender
{
  [super redeal];
  [self removeAllCards];
  [self resetGrid];
  [self enableCardsAddition];
  [self updateUI];
  [self createCards];
}

- (void) resetGrid
{
  self.cardsGrid.minimumNumberOfCells = INITIAL_CARD_COUNT;
}

-(void) enableCardsAddition
{
  self.addCardButton.enabled = YES;
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

@end
