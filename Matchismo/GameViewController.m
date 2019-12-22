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
@property (nonatomic) BOOL isBunched;

@end

@implementation GameViewController
- (IBAction)gatherAndDistributeCards:(UIPinchGestureRecognizer *)sender
{
  if (self.isBunched && sender.state == UIGestureRecognizerStateEnded)
  {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews
                     animations:^(void) {
      [self distributeCards];
    } completion: ^(BOOL isFinished)
     {
      if(isFinished)
        self.isBunched = NO;
    }];
  }
  else if(sender.state == UIGestureRecognizerStateEnded)
  {
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionLayoutSubviews
                     animations:^(void) {
      [self bunchCards: sender];
    } completion: ^(BOOL isFinished)
     {
      if(isFinished)
        self.isBunched = YES;
    }];
  }
}


- (CGPoint) calculatePointFromIndex: (NSUInteger) index
{
    NSUInteger row = index / self.cardsGrid.columnCount;
    NSUInteger column = index - row * self.cardsGrid.columnCount;
    return CGPointMake(column, row);
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

- (void) bunchCards: (UIPinchGestureRecognizer *) sender
{
  CGPoint rawCenterOfPile = [sender locationInView:self.CardsSpace];
  CGPoint actualCenterOfPile = [self calculateCenter: rawCenterOfPile];
  CGRect rectForCards = CGRectMake(actualCenterOfPile.x, actualCenterOfPile.y, self.cardsGrid.cellSize.width, self.cardsGrid.cellSize.height);
  for (NSUInteger i = 0; i < [self.cardViews count]; ++i)
  {
    if(self.cardViews[i] == [NSNull null])
    {
      continue;
    }
    
    id <CardView> cardView = self.cardViews[i];
    cardView.frame = rectForCards;
  }
}

- (CGPoint) calculateCenter: (CGPoint) rawCenter
{
  CGPoint center = {0,0};
  
  CGFloat maxXValue = (self.CardsSpace.bounds.size.width - self.cardsGrid.cellSize.width);
  CGFloat minXValue = (self.CardsSpace.bounds.origin.x);
  
  if(rawCenter.x > maxXValue)
  {
    center.x = maxXValue;
  }
  else if(rawCenter.x < minXValue)
  {
    center.x = minXValue;
  }
  else
  {
    center.x = rawCenter.x;
  }
  
  CGFloat maxYValue = (self.CardsSpace.bounds.size.height - self.cardsGrid.cellSize.height);
  CGFloat minYValue = (self.CardsSpace.bounds.origin.x);

  if(rawCenter.y > maxYValue)
  {
    center.y = maxYValue;
  }
  else if(rawCenter.y < minYValue)
  {
    center.y = minYValue;
  }
  else
  {
    center.y = rawCenter.y;
  }
  return center;
}

- (IBAction)chooseCard:(UITapGestureRecognizer *)sender
{
  CGPoint pointOfTouch = [sender locationInView:self.CardsSpace];
  NSUInteger index = [self calculateCardIndex: pointOfTouch];
  

  if(([self.cardViews count] > index) &&  (![self.cardViews[index] isEqual:[NSNull null]]))
  {
    [self.game chooseCardAtIndex:index];
    [self updateUI];
  }
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
  self.cardsGrid.size = self.CardsSpace.bounds.size;
  self.cardsGrid.cellAspectRatio = WIDTH_HEIGHT_RATIO;
  self.cardsGrid.minimumNumberOfCells = [self initialNumberOfCards];
  
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

- (void)redeal {
  self.game = nil;
  self.scoreCount.text = @"Score: 0";
  self.currentEvent.text = @"Please pick a card";
  [self updateUI];
}

- (IBAction)redealHandler:(UIButton *)sender
{
  [self redeal];
}

- (IBAction)ChangeMoveTitle:(UISlider *)sender
{
    if(sender.maximumValue)
    {
         [self setMoveMessage:[self.game.moves count] - 1];
    }
}

-(void) setMoveMessage: (long) index
{
    self.currentEvent.text = [self makeMoveString:self.game.moves[index]];
}

- (NSInteger) getInitialNumber{
  return 12;
}

- (NSInteger) getMode
{
  return 2;
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

- (Deck*) createDeck
{
  return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
//    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
//    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
}


- (void) removeCard: (int) index
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
      [self removeCard:i];
      self.cardViews[i] = [NSNull null];
      continue;
    }
    
    id <CardView> cardView = self.cardViews[i];
    if(![self.cardViews[i] isEqual:[NSNull null]] && (card.isChosen != cardView.isChosen))
    {
      [self cardChosenAnimation:self.cardViews[i] isChosen:card.isChosen];
    }

  }
}


- (BOOL)isNull:(id <CardView>)cardView
{
    return [cardView isEqual:[NSNull null]];
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


-(NSString*) makeMoveString: (CardMatchingMove*) move
{
    NSMutableString* moveText = [[NSMutableString alloc] init];
    
    if(move.moveType == CARD_CLOSED)
    {
        [moveText appendFormat:@"%@ Unchosen", ((Card*)[move.chosenCards firstObject]).contents];
        return moveText;
    }
    if(move.moveType == CARD_OPENED)
    {
        [moveText appendFormat:@"%@ chosen", ((Card*)[move.chosenCards firstObject]).contents];
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

- (NSString* ) titleForCard: (Card*) card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage* ) backgroundOfCard: (Card*) card
{
    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
}

@end
