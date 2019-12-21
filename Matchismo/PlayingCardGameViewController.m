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

@interface PlayingCardGameViewController()
  @property (nonatomic, readonly) CGPoint rightBottomCornerOrigin;
  @property (nonatomic) NSUInteger requestedCardNumber;
@end

@implementation PlayingCardGameViewController

- (int) initialNumberOfCards
{
  return 20;
}

- (void) viewDidLoad
{
  [super viewDidLoad];
  self.requestedCardNumber = [self initialNumberOfCards];
  [self setGridDimensions];
  [self createCards:0.0];
}

- (PlayingCardView *)createInitialCard:(int)column row:(int)row
{
  CGSize size = [self.cardsGrid cellSize];
  PlayingCardView * cardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(3 * self.rightBottomCornerOrigin.x, 3 * self.rightBottomCornerOrigin.y, size.width, size.height)];
  return cardView;
}

- (void)setCardsValues:(int)cardIndex cardView:(PlayingCardView *)cardView {
  Card* card = [self.game cardAtIndex:cardIndex];
  
  if(![card isKindOfClass:[PlayingCard class]])
  {
    return;
  }
  
  PlayingCard *playingCard = (PlayingCard *) card;
  cardView.rank = playingCard.rank;
  cardView.suit = playingCard.suit;
}

- (void) attachToViewAndAnimate:(PlayingCardView *)cardView withDelay:(CGFloat) delay row:(int) row column:(int) column
{
  CGRect position = [self.cardsGrid frameOfCellAtRow:row inColumn:column];
  [self animateCreation:cardView rect:position delay: delay];
  [self.CardsSpace addSubview:cardView];
}

- (void) createCards: (CGFloat) delay
{
  int cardIndex = 0;
  for(int row = 0; row < self.cardsGrid.rowCount ; ++row)
  {
    for(int column = 0; column < self.cardsGrid.columnCount; ++column)
    {
      PlayingCardView *cardView = [self createInitialCard:column row:row];
      
      [self setCardsValues:cardIndex cardView:cardView];
            
      [self.cardViews addObject:cardView];
      
      
      [self  attachToViewAndAnimate:cardView withDelay:delay row:row column:column];
      ++cardIndex;
      if(cardIndex >= [self initialNumberOfCards]) // should change on run time
      {
        return;
      }
    }
  }
}

- (void) redeal
{
  [super redeal];
  [self removeAllCards];
  [self createCards:1];
}

- (Deck*) createDeck
{
  return [[PlayingDeck alloc] init];
}

- (void) cardChosenAnimation: (UIView *) cardView isChosen: (BOOL) chosen
{
  [UIView animateWithDuration:0.3
  animations:^(void) {
    CGAffineTransform currentTransform = cardView.transform;
    cardView.transform = CGAffineTransformMakeScale(-1, 1);
    cardView.transform = currentTransform;
    PlayingCardView *playingCardView = (PlayingCardView *) cardView;
    playingCardView.isChosen = chosen;
  }
  completion:nil];
}

- (void) updateUI
{
  [super updateUI];
  self.scoreCount.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  if([self.game.moves count])
  {
    [self setMoveMessage:[self.game.moves count] - 1];
  }
}

- (NSInteger) getInitialNumber
{
  return [self initialNumberOfCards];
}

@end


