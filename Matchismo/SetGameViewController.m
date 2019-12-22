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

static const int INITIAL_CARD_COUNT = 13;
static const NSUInteger CARDS_IN_SINGLE_EDITION = 3;

@interface SetGameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *addCardButton;

@end


@implementation SetGameViewController


- (IBAction)chooseCard:(UITapGestureRecognizer *)sender {
  [super chooseCard:sender];
}

- (IBAction)Addmorecards:(UIButton *)sender
{
  NSUInteger available = [self availableSpots];
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

  //[self recalculateGridAndAddNewCards];
  
//  recalculateGrid;
//  addAll;
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



- (BOOL)isNull:(SetCardView *)cardView {
    return [cardView isEqual:[NSNull null]];
}

- (void)createSetCard:(Card *)card fromRect:(CGRect)cellRect atIndex:(int)i {
  SetCardView *cardView = [self createSetCardView:cellRect.size];
  [self updateSetCardValues:card cardView:cardView];
  [self.cardViews replaceObjectAtIndex:i withObject:cardView];
  [self saveAndPresentCard:cardView rect:cellRect];
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

-(int) addInsteadOfMissingAndWhereAvailableOnGrid
{
  int viewsThatAdded = [self addInsteadOfMatchedCards];
  int viewsThatAddedToGrid = 0;
  while(viewsThatAdded < CARDS_IN_SINGLE_EDITION)
  {
    CGPoint point = [self calculatePointFromIndex:[self.cardViews count]];
    CGRect rect = [self.cardsGrid frameOfCellAtRow:point.y inColumn:point.x];
    Card *card = [self.game addCardsToGame];
    if([card isKindOfClass:[SetCard class]])
    {
      [self addCardViewToTheEndOfCollection:card rect:rect];
      ++viewsThatAdded;
      ++viewsThatAddedToGrid;
    }
  }
  return viewsThatAdded;
  
}

- (CGPoint) calculatePointFromIndex: (NSUInteger) index
{
    NSUInteger row = index / self.cardsGrid.columnCount;
    NSUInteger column = index - row * self.cardsGrid.columnCount;
    return CGPointMake(column, row);
}

- (void)updateSetCardValues:(Card *)card cardView:(SetCardView *)cardView {
    SetCard *setCard = (SetCard *) card;
    cardView.numberOfShapes = setCard.number;
    cardView.color = setCard.color;
    cardView.fill = setCard.fill;
    cardView.shape = setCard.shape;
}

- (SetCardView *)createSetCardView:(CGSize) size {
    return [[SetCardView alloc] initWithFrame:CGRectMake(3 * self.rightBottomCornerOrigin.x, 3 * self.rightBottomCornerOrigin.y, size.width, size.height)];
}

- (void)saveAndPresentCard:(SetCardView *)cardView rect:(CGRect)rect {
    [self.CardsSpace addSubview:cardView];
    [self animateCreation:cardView rect:rect delay:0.5];
}

- (void)addCardViewToTheEndOfCollection:(Card *)card rect:(const CGRect)rect {
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

- (NSInteger) getInitialNumber{
  return [self initialNumberOfCards];
}

- (int) initialNumberOfCards
{
  return INITIAL_CARD_COUNT;
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
