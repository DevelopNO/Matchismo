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

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (void) createCards
{
  for(int row = 0; row < self.cardsGrid.rowCount ; ++row)
  {
    for(int column = 0; column < self.cardsGrid.columnCount; ++column)
    {
      CGRect rect = [self.cardsGrid frameOfCellAtRow:row inColumn:column];

//      PlayingCardView *cardView = [[PlayingCardView alloc] initWithFrame:CGRectMake(3 * self.leftCornerOfCardsSpace.x, 3 * self.leftCornerOfCardsSpace.y, rect.size.width, rect.size.height)];
//
//      Card* card = [self.game cardAtIndex:cardIndex];
//
//      if([card isKindOfClass:[PlayingCard class]])
//      {
//        PlayingCard *playingCard = (PlayingCard *) card;
//        cardView.rank = playingCard.rank;
//        cardView.suit = playingCard.suit;
//
//        // index in array would indicate position in grid
//        // currentRow = indexInArray / nColums
//        // currentCoulmn = IndexInArray - currentRow * nColums
//
//        [self.cards addObject:cardView];
//
//        [self creationAnimation:cardView rect:rect delay: delay];
//
//        [self.CardsSpace addSubview:cardView];
//        ++cardIndex;
//        if(cardIndex >= INITIAL_CARD_COUNT) // should change on run time
//        {
//          return;
//        }
        
      }
    }
  }


- (void)viewDidLoad {
  [super viewDidLoad];
  [self createCards];

}



- (IBAction)reDeal:(UIButton *)sender
{
  self.game = nil;
  self.scoreCount.text = @"Score: 0";
  self.currentEvent.text = @"Please pick a card";

  [self updateUI];
}

- (NSInteger) getMode
{
  return 3;
}

- (Deck*) createDeck
{
  return [[SetDeck alloc] init];
}


- (IBAction)touchCardButton:(UIButton *)sender
{
//  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
//  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}



- (void) updateUI
{
//  for(UIButton* cardButton in self.cardButtons)
//  {
//    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
//    Card* card = [self.game cardAtIndex:cardButtonIndex];
//    [cardButton setBackgroundImage:[self backgroundOfCard:card] forState:UIControlStateNormal];
//    cardButton.enabled = !card.isMatched;
//    super.scoreCount.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
//  }
//
  if([self.game.moves count])
  {
    [self setMoveMessage:[self.game.moves count] - 1];
  }
  
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
