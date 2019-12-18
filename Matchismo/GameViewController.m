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
#import "Grid.h"



@interface GameViewController ()


@end

@implementation GameViewController

- (void)viewDidLoad
{
  self.cards = [[NSMutableArray alloc] init];
  self.gridOfCards = [[Grid alloc] init];
  self.CardsSpace.backgroundColor = nil;
  self.CardsSpace.opaque = NO;
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
- (IBAction)reDeal:(UIButton *)sender
{
    self.game = nil;
    self.scoreCount.text = @"Score: 0";
    self.currentEvent.text = @"Please pick a card";
    [self updateUI];
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
      // Send string
    }
  }
}

- (NSInteger) getInitialNumber
{
  return 0;
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
- (void) updateUI
{
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
