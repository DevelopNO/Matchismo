//
//  ViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "GameViewController.h"
#import "CardMatchingGame.h"
#import "CardMatchingMove.h"
#import "HistoryViewController.h"
#import "CardView.h"
#import "Grid.h"



@interface GameViewController ()
@property (nonatomic) BOOL cardsAreBunched;


@end

@implementation GameViewController

#pragma mark - Gestures
- (IBAction)gatherAndDistributeCards:(UIPinchGestureRecognizer *)sender
{
  if(sender.state == UIGestureRecognizerStateEnded && !self.cardsAreBunched)
  {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews
                     animations:^(void) {
      [self moveAndBunchCards: sender];
    } completion: ^(BOOL isFinished)
     {
      if(isFinished)
        self.cardsAreBunched = YES;
    }];
  }
}

- (void) distributeCards
{
  for (NSUInteger i = 0; i < [self.cardViews count]; ++i)
  {
    if([self isNull:self.cardViews[i]])
    {
      continue;
    }
    CGPoint pointInGrid = [self calculatePointFromIndex:i];
    CGRect rectForCard = [self.cardsGrid frameOfCellAtRow:pointInGrid.y inColumn:pointInGrid.x];
    id <CardView> cardView = self.cardViews[i];
    cardView.frame = rectForCard;

  }
}


- (void)animateCardsDistribution
{
  [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews
                   animations:^(void) {
    [self distributeCards];
  } completion: ^(BOOL isFinished)
   {
    if(isFinished)
      self.cardsAreBunched = NO;
  }];
}

- (void) moveAndBunchCards: (UIGestureRecognizer *) sender
{
  CGPoint rawCenterOfPile = [sender locationInView:self.CardsSpace];
  CGPoint actualCenterOfPile = [self calculateCenter: rawCenterOfPile];
  
  for (NSUInteger i = 0; i < [self.cardViews count]; ++i)
  {
    if(self.cardViews[i] == [NSNull null])
    {
      continue;
    }
    
    id <CardView> cardView = self.cardViews[i];
    cardView.center = actualCenterOfPile;
  }
}

- (IBAction)movePileAround:(id)sender
{
  if(self.cardsAreBunched)
  {
    [UIView animateWithDuration:0.05 delay:0.0 options:UIViewAnimationOptionLayoutSubviews
                     animations:^(void) {
      [self moveAndBunchCards: sender];
    } completion: nil];
  }
}

#pragma mark - utils

- (BOOL)isNull:(id <CardView>)cardView
{
    return [cardView isEqual:[NSNull null]];
}

- (CGPoint) calculatePointFromIndex: (NSUInteger) index
{
    NSUInteger row = index / self.cardsGrid.columnCount;
    NSUInteger column = index - row * self.cardsGrid.columnCount;
    return CGPointMake(column, row);
}



- (CGPoint) calculateCenter: (CGPoint) rawCenter
{
  CGPoint center = {rawCenter.x, rawCenter.y};
  
  CGFloat maxXValue = (self.CardsSpace.bounds.size.width - self.cardsGrid.cellSize.width / 2);
  CGFloat minXValue = (self.CardsSpace.bounds.origin.x + self.cardsGrid.cellSize.width / 2);
  
  if(rawCenter.x > maxXValue)
  {
    center.x = maxXValue;
  }
  else if(rawCenter.x < minXValue)
  {
    center.x = minXValue;
  }
  
  CGFloat maxYValue = (self.CardsSpace.bounds.size.height - self.cardsGrid.cellSize.height / 2);
  CGFloat minYValue = (self.CardsSpace.bounds.origin.y +  self.cardsGrid.cellSize.height / 2);

  if(rawCenter.y > maxYValue)
  {
    center.y = maxYValue;
  }
  else if(rawCenter.y < minYValue)
  {
    center.y = minYValue;
  }
  return center;
}

# pragma mark - choose card
- (IBAction)chooseCard:(UITapGestureRecognizer *)sender
{
  CGPoint pointOfTouch = [sender locationInView:self.CardsSpace];
  
  if(self.cardsAreBunched)
  {
    if([self isPointInPile:pointOfTouch])
    {
      [self animateCardsDistribution];
      self.cardsAreBunched = NO;
    }
    return;
  }
  
  NSUInteger index = [self calculateCardIndex: pointOfTouch];
  

  if(([self.cardViews count] > index) &&  (![self.cardViews[index] isEqual:[NSNull null]]))
  {
    [self.game chooseCardAtIndex:index];
    [self updateUI];
  }
}


- (BOOL) isPointInPile: (CGPoint) point
{
  id <CardView> pile = [self getNonNullCard];
  if(pile != nil)
  {
    return (point.x >= pile.frame.origin.x)
            &&
            point.x <= (pile.frame.origin.x + pile.frame.size.width)
            &&
            point.y >= pile.frame.origin.y
            &&
    point.y <= (pile.frame.origin.y + pile.frame.size.height);
  }
  return NO;
}

- (id <CardView>) getNonNullCard
{
  for(id <CardView> card in self.cardViews)
  {
    if(![self isNull:card])
    {
      return card;
    }
  }
  return nil;
}

- (int) initialNumberOfCards
{
  return 0;
}

- (void)cardRemoveAnimation:(UIView *)cardToRemove delay:(CGFloat) delay{
  [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionLayoutSubviews
                   animations:^(void) {
    cardToRemove.alpha = 0.0;
  } completion: ^(BOOL isFinished)
   {
    if(isFinished)
      [cardToRemove removeFromSuperview];
  }];
}


- (void) setGridDimensions
{
  [self setGridDimensions: [self initialNumberOfCards]];
  
}

- (void) setGridDimensions: (NSUInteger) minNOfCells
{
  self.cardsGrid.size = self.CardsSpace.bounds.size;
  self.cardsGrid.cellAspectRatio = WIDTH_HEIGHT_RATIO;
  self.cardsGrid.minimumNumberOfCells = minNOfCells;
  
}

- (void) viewDidAppear:(BOOL)animated
{
  [self setGridDimensions:[self.cardViews count]];
  [self repositionCards];
}

-(CGPoint) rightBottomCornerOrigin
{
  return CGPointMake( self.CardsSpace.frame.size.width - self.cardsGrid.cellSize.width, self.CardsSpace.frame.size.height - self.cardsGrid.cellSize.height);
}
- (void)viewDidLoad
{
  self.cardViews = [[NSMutableArray alloc] init];
  self.cardsGrid = [[Grid alloc] init];
  self.CardsSpace.backgroundColor = nil;
  self.CardsSpace.opaque = NO;
  [self subscribeToLayoutChange];
}

  - (void) subscribeToLayoutChange
  {
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
       addObserver:self selector:@selector(recalculateGrid:)
       name:UIDeviceOrientationDidChangeNotification
       object:[UIDevice currentDevice]];
  }

  - (void) recalculateGrid:(NSNotification *)note
  {
    NSLog(@"width: %f height: %f", self.CardsSpace.frame.size.width, self.CardsSpace.frame.size.height);
    NSLog(@"general view: width: %f height: %f", self.view.frame.size.width, self.view.frame.size.height);
    [self setGridDimensions:[self.cardViews count]];
    [self repositionCards];
  }

- (void) animateRedrawing: (NSUInteger) index
{

  [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^(void) {
    CGPoint pointInGrid = [self calculatePointFromIndex:index];
       CGRect newRectForCard = [self.cardsGrid frameOfCellAtRow:pointInGrid.y inColumn:pointInGrid.x];
       UIView *cardView = self.cardViews[index];
       cardView.frame = newRectForCard;
    
  }completion:nil];
}

- (void) repositionCards
{
  for(NSUInteger i = 0; i < [self.cardViews count]; ++i)
  {
    [self animateRedrawing:i];
  }
}

- (void)animateCreation:(UIView *)cardView rect:(CGRect )rect delay: (CGFloat) delay
{
  [UIView animateWithDuration:1.0 delay:delay options:UIViewAnimationOptionBeginFromCurrentState
                   animations:^(void) {
    cardView.frame = rect;
    
  }completion:nil];
}

- (NSUInteger)calculateCardIndex: (CGPoint) location
{
  NSUInteger row = [self.cardsGrid getRowByPoint:location];
  NSUInteger column = [self.cardsGrid getColumnByPoint:location];
  return row * [self.cardsGrid columnCount] + column;
}

#pragma mark - History and moves

- (NSAttributedString *) createHistory
{
  NSMutableString* history = [[NSMutableString alloc] init];
  for(CardMatchingMove* move in self.game.moves)
  {
    [history appendString:[self makeMoveString:move]];
    [history appendString:@"\n"];
  }
  return [[NSAttributedString alloc] initWithString:history];
}

- (IBAction)ChangeMoveTitle:(UISlider *)sender
{
    if(sender.maximumValue)
    {
         [self setMoveMessage:[self.game.moves count] - 1];
    }
}


- (NSString *) makeMoveString: (CardMatchingMove*) move
{
    NSMutableString* moveText = [[NSMutableString alloc] init];
    
    if(move.moveType == CARD_CLOSED)
    {
        [moveText appendFormat:@"%@ Unchosen", ((Card *)[move.chosenCards firstObject]).contents];
        return moveText;
    }
    if(move.moveType == CARD_OPENED)
    {
        [moveText appendFormat:@"%@ chosen", ((Card *)[move.chosenCards firstObject]).contents];
        return moveText;
    }

    [moveText appendFormat:@"%@ ", move.moveType == MATCH ? @"Match between" : @"No match between"];

    for (Card* card in move.chosenCards)
    {
        [moveText appendFormat:@"%@ ", card.contents];
    }
    
  [moveText appendFormat:@"%d points", move.moveScore];

    return [moveText copy];
}

- (NSString * ) titleForCard: (Card *) card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *) backgroundOfCard: (Card *) card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}


#pragma mark - redeal

- (void)redeal {
  self.game = nil;
  self.scoreCount.text = @"Score: 0";
  self.currentEvent.text = @"Please pick a card";
  self.cardsAreBunched = NO;
  [self updateUI];
}

- (IBAction)redealHandler:(UIButton *)sender
{
  [self redeal];
}


-(void) setMoveMessage: (long) index
{
    self.currentEvent.text = [self makeMoveString:self.game.moves[index]];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:@"show history"])
  {
    if([segue.destinationViewController isKindOfClass:[HistoryViewController class]])
    {
      HistoryViewController *history = (HistoryViewController *) segue.destinationViewController;
      if([self.game.moves count])
      {
        history.attrText = [self createHistory];
      }
    }
  }
}

- (CardMatchingGame*) game
{
    if(!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self getInitialNumber] usingDeck:[self createDeck] inMode:[self getMode]];
    }
    return _game;
}



- (void) removeMatchedCard: (int) index
{
  UIView *cardToRemove = self.cardViews[index];
  [self cardChosenAnimation:cardToRemove isChosen:YES];
  [self cardRemoveAnimation:cardToRemove delay:0.5];
}
- (void) cardChosenAnimation: (UIView *) cardView isChosen: (BOOL) chosen
{
  
}

- (void) updateUI
{
  for(int i = 0; i < [self.cardViews count] ; ++i)
  {
    if([self.cardViews[i] isEqual:[NSNull null]])
    {
      continue;
    }
    
    Card *card = [self.game cardAtIndex:i];
    if(card.isMatched)
    {
      NSLog(@"Card is matched index: %d", i);
      [self removeMatchedCard:i];
      self.cardViews[i] = [NSNull null];
      continue;
    }
    
    id <CardView> cardView = self.cardViews[i];
    if(![self.cardViews[i] isEqual:[NSNull null]] && (card.isChosen != cardView.isChosen))
    {
      [self cardChosenAnimation:self.cardViews[i] isChosen:card.isChosen];
    }

  }
  self.scoreCount.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
}

- (void) removeAllCards
{
  for(UIView *cardView in self.cardViews)
  {
    if(![cardView isEqual:[NSNull null]])
    {
      [self cardRemoveAnimation:cardView delay:0.0];
    }
  }
  [self.cardViews removeAllObjects];
}

#pragma mark - Type of game dependent functions
- (Deck*) createDeck
{
  return nil;
}


- (NSInteger) getInitialNumber{
  return 12;
}

- (NSInteger) getMode
{
  return 2;
}


@end
