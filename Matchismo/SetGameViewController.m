//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetCardPresentationBuilder.h"
#import "SetCard.h"
#import "SetDeck.h"

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
//    self.movesPosition.value = 0;
//    self.movesPosition.minimumValue = 0;
//    self.movesPosition.maximumValue = 0;
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

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateUI];
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
    
}

- (UIImage* ) backgroundOfCard: (Card*) card
{
  return [UIImage imageNamed:card.isChosen ? @"setCardSelected" : @"cardFront"];
}


@end


/// Move stuff

//- (IBAction)ChangeMoveTitle:(UISlider *)sender
//{
//    if(sender.maximumValue)
//    {
//        long sliderValue = lroundf(self.movesPosition.value);
//        [self.movesPosition setValue:sliderValue animated:YES];
//
//        [self setMoveMessage:sliderValue];
//    }
//}
//
//-(void) setMoveMessage: (long) index
//{
//    self.currentEvent.text = [self makeMoveString:self.game.moves[index]];
//}


// moves - in update uI
//if([self.game.moves count])
//{
//    self.movesPosition.maximumValue = [self.game.moves count] - 1;
//    self.movesPosition.value = self.movesPosition.maximumValue;
//    [self setMoveMessage:self.movesPosition.maximumValue];
//}


//-(NSString*) makeMoveString: (CardMatchingMove*) move
//{
//    NSMutableString* moveText = [[NSMutableString alloc] init];
//
//    if(move.moveType == CARD_CLOSED)
//    {
//        [moveText appendFormat:@"%@ Unchosen", ((Card*)[move.chosenCards firstObject]).contents];
//        return moveText;
//    }
//    if(move.moveType == CARD_OPENED)
//    {
//        [moveText appendFormat:@"%@ chosen", ((Card*)[move.chosenCards firstObject]).contents];
//        return moveText;
//    }
//
//    [moveText appendFormat:@"%@ ", move.moveType == MATCH ? @"Match between" : @"No match between"];
//
//    for (Card* card in move.chosenCards)
//    {
//        [moveText appendFormat:@"%@ ", card.contents];
//    }
//
//
//    return [moveText copy];
//}
