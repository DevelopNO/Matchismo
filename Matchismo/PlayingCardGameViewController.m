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

static const int INITIAL_CARD_COUNT = 20;
static const CGFloat WIDTH_HEIGHT_RATIO = 0.66;

@interface PlayingCardGameViewController()
@property (nonatomic, readonly) CGPoint leftCornerOfCardsSpace;

@property (nonatomic) NSUInteger requestedCardNumber;
@end

@implementation PlayingCardGameViewController

-(CGPoint) leftCornerOfCardsSpace
{
  return CGPointMake( self.CardsSpace.frame.size.width - self.gridOfCards.cellSize.width, self.CardsSpace.frame.size.height - self.gridOfCards.cellSize.height);
}

- (Deck*) createDeck
{
  return [[PlayingDeck alloc] init];
}

- (NSUInteger)calculateCardIndex: (CGPoint) location
{
  NSUInteger row = [self.gridOfCards getRowByPoint:location];
  NSUInteger column = [self.gridOfCards getColumnByPoint:location];
  return row * [self.gridOfCards columnCount] + column;
}

- (void) cardFlipAnimation: (PlayingCardView *) cardView isChosen: (BOOL) chosen
{
  [UIView animateWithDuration:0.3
  animations:^(void) {
    CGAffineTransform currentTransform = cardView.transform;
      cardView.transform = CGAffineTransformMakeScale(-1, 1);
      cardView.transform = currentTransform;
      cardView.facedUp = chosen;
  }completion:nil];
}

- (IBAction)flipCard:(UITapGestureRecognizer *)sender
{
  CGPoint pointOfTouch = [sender locationInView:self.CardsSpace];
  NSUInteger index = [self calculateCardIndex: pointOfTouch];
  

  if(([self.cards count] > index) &&  (![self.cards[index] isEqual:[NSNull null]]))
  {
    [self.game chooseCardAtIndex:index];
    [self updateUI];
  }
}

- (void)cardRemoveAnimation:(PlayingCardView *)cardToRemove delay:(CGFloat) delay{
  [UIView animateWithDuration:0.5 delay:delay options:UIViewAnimationOptionLayoutSubviews
                   animations:^(void) {
    cardToRemove.alpha = 0.0;
  } completion: ^(BOOL isFinished)
   {
    if(isFinished)
      [cardToRemove removeFromSuperview];
  }];
}

- (void) removeCard: (int) index
{
  PlayingCardView *cardToRemove = self.cards[index];
  [self cardFlipAnimation:cardToRemove isChosen:YES];
  [self cardRemoveAnimation:cardToRemove delay:0.5];
  
}
- (void) updateUI
{
  for(int i = 0; i < [self.cards count] ; ++i)
  {
    if([self.cards[i] isEqual:[NSNull null]])
    {
      continue;
    }
    
    Card *card = [self.game cardAtIndex:i];
    if(card.isMatched && ![self.cards[i] isEqual:[NSNull null]])
    {
      NSLog(@"Card is matched index: %d", i);
      [self removeCard:i];
      self.cards[i] = [NSNull null];
      continue;
    }
    
    PlayingCardView *cardView = self.cards[i];
    
    if((card.isChosen != cardView.facedUp) && ![self.cards[i] isEqual:[NSNull null]])
    {
      [self cardFlipAnimation:self.cards[i] isChosen:card.isChosen];
    }
  }
  
  self.scoreCount.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  if([self.game.moves count])
  {
    [self setMoveMessage:[self.game.moves count] - 1];
  }
}
- (NSInteger) getInitialNumber
{
  return INITIAL_CARD_COUNT;
}

- (void)createAnimation:(PlayingCardView *)cardView rect:(CGRect )rect delay: (CGFloat) delay{
  [UIView animateWithDuration:1.0 delay:delay options:UIViewAnimationOptionLayoutSubviews
                   animations:^(void) {
    cardView.frame = rect;
    
  }completion:nil];
}


- (void) createCards: (CGFloat) delay
{
  int cardIndex = 0;
  for(int row = 0; row < self.gridOfCards.rowCount ; ++row)
  {
    for(int column = 0; column < self.gridOfCards.columnCount; ++column)
    {
      CGRect rect = [self.gridOfCards frameOfCellAtRow:row inColumn:column];

      PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(3 * self.leftCornerOfCardsSpace.x, 3 * self.leftCornerOfCardsSpace.y, rect.size.width, rect.size.height)];
      
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
        
        [self createAnimation:cardView rect:rect delay: delay];
        
        [self.CardsSpace addSubview:cardView];
        ++cardIndex;
        if(cardIndex >= INITIAL_CARD_COUNT) // should change on run time
        {
          return;
        }
        
      }
    }
  }
}

- (void) removeAllCards
{
  for(PlayingCardView *cardView in self.cards)
  {
    if(![cardView isEqual:[NSNull null]])
    {
      [self cardRemoveAnimation:cardView delay:0.0];
    }
  }
  [self.cards removeAllObjects];
}

- (void) redeal
{
  [super redeal];
  [self removeAllCards];
  [self createCards:1];
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
  self.requestedCardNumber = INITIAL_CARD_COUNT;
  [self setGridDimensions];
  [self createCards:0.0];
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


