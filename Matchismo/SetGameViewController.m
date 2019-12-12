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
#import "SetCardPresentationBuilder.h"
#import "SetCard.h"
#import "SetDeck.h"
#import "CardMatchingMove.h"

@interface SetGameViewController ()

@end

@implementation SetGameViewController

- (void)setCardsHeaders {
  for(UIButton* cardButton in self.cardButtons)
  {
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    SetCard* card = (SetCard *) [[self game] cardAtIndex:cardButtonIndex];
    [cardButton setAttributedTitle:[SetCardPresentationBuilder getCardPresentation:card] forState:UIControlStateNormal];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setCardsHeaders];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(NSAttributedString *) CardContentBuilder: (SetCard *) card
{
  return [SetCardPresentationBuilder getCardPresentation:card];
}

- (IBAction)reDeal:(UIButton *)sender
{
  self.game = nil;
  self.scoreCount.text = @"Score: 0";
  self.currentEvent.text = @"Please pick a card";
  [self setCardsHeaders];
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

- (NSAttributedString *) createHistory
{
  NSMutableAttributedString *history = [[NSMutableAttributedString alloc] init];
  
  for(CardMatchingMove* move in self.game.moves)
  {
    [history appendAttributedString:[self makeMoveString:move]];
    [history appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
  }
  return history;
}

- (IBAction)touchCardButton:(UIButton *)sender
{
  NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
  [self.game chooseCardAtIndex:chosenButtonIndex];
  [self updateUI];
}


-(void) setMoveMessage: (long) index
{
    self.currentEvent.attributedText = [self makeMoveString:self.game.moves[index]];
}

- (void) updateUI
{
  for(UIButton* cardButton in self.cardButtons)
  {
    NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
    Card* card = [self.game cardAtIndex:cardButtonIndex];
    [cardButton setBackgroundImage:[self backgroundOfCard:card] forState:UIControlStateNormal];
    cardButton.enabled = !card.isMatched;
    super.scoreCount.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
  }
  
  if([self.game.moves count])
  {
    [self setMoveMessage:[self.game.moves count] - 1];
  }
  
}

- (UIImage* ) backgroundOfCard: (Card*) card
{
  return [UIImage imageNamed:card.isChosen ? @"setCardSelected" : @"cardFront"];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  if([segue.identifier isEqualToString:@"show history"])
  {
    if([segue.destinationViewController isKindOfClass:[HistoryViewController class]])
    {
      HistoryViewController *history = (HistoryViewController *) segue.destinationViewController;
      history.attrText = [self createHistory];
      
      // Send string
    }
  }
}

+ (void) setCardsToAttributedString: (NSMutableAttributedString *) text move: (CardMatchingMove *)move
{
  for(SetCard *card in move.chosenCards)
  {
    [text appendAttributedString:[SetCardPresentationBuilder getCardPresentation:card]];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
  }
}

+ (void) appendStringToAttributed: (NSMutableAttributedString *) attr string:(NSString *) text
{
  [attr appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithString:text]]];
  
}

+ (NSMutableAttributedString *) textOfCardsAndString:(CardMatchingMove *)move string:(NSString *) string
{
  NSMutableAttributedString* text = [[NSMutableAttributedString alloc] init];
  [SetGameViewController setCardsToAttributedString:text move:move];
  [SetGameViewController appendStringToAttributed:text string:string];
  
  return text;
}

+ (NSMutableAttributedString *) textForScoredMove:(CardMatchingMove *)move string:(NSString *) string
{
  NSMutableAttributedString* text = [[NSMutableAttributedString alloc] init];
  [SetGameViewController appendStringToAttributed:text string:string];
  [SetGameViewController setCardsToAttributedString:text move:move];
  [SetGameViewController appendStringToAttributed:text string:[NSString stringWithFormat:@" Score: %d", move.moveScore]];
  
  return text;
}

-(NSAttributedString *) makeMoveString: (CardMatchingMove *) move
{
  if(move.moveType == CARD_CLOSED)
  {
    return [SetGameViewController textOfCardsAndString:move string:@" Unchosen"];
  }
  
  if(move.moveType == CARD_OPENED)
  {
    return      [SetGameViewController textOfCardsAndString:move string:@" Chosen"];
    
  }
  
  if(move.moveType == MATCH)
  {
    return [SetGameViewController textForScoredMove:move string:@"Match between "];
  }
  
  if(move.moveType == NO_MATCH)
  {
    return [SetGameViewController textForScoredMove:move string:@"No Match between "];
  }
  
  return nil;
}

@end
