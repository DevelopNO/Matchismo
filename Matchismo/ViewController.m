//
//  ViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "ViewController.h"
#import "PlayingDeck.h"
#import "CardMatchingGame.h"
#import "CardMatchingMove.h"

@interface ViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame* game;
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;
@property (nonatomic) BOOL isModeChageAllowed;
@property (nonatomic) BOOL isIn3CardsMatchMode;
@property (weak, nonatomic) IBOutlet UILabel *currentEvent;
@property (weak, nonatomic) IBOutlet UISlider *movesPosition;
@property (weak, nonatomic) IBOutlet UISwitch *modeSwitch;

@end

@implementation ViewController


- (IBAction)handleMode:(UISwitch *)sender
{
    if(sender.isOn)
    {
        self.game = nil;
        self.isIn3CardsMatchMode = YES;
    }
    else
    {
        self.game = nil;
        self.isIn3CardsMatchMode = NO;
    }
}
- (IBAction)reDeal:(UIButton *)sender
{
    self.movesPosition.value = 0;
    self.movesPosition.minimumValue = 0;
    self.movesPosition.maximumValue = 0;
    self.game = nil;
    self.scoreCount.text = @"Score: 0";
    self.currentEvent.text = @"Please pick a card";
    [self updateUI];
    [self.modeSwitch setEnabled:YES];
}
- (IBAction)CangeMoveTitle:(UISlider *)sender
{
    if(sender.maximumValue)
    {
        long sliderValue = lroundf(self.movesPosition.value);
        [self.movesPosition setValue:sliderValue animated:YES];
    
        [self setMoveMessage:sliderValue];
    }
}

-(void) setMoveMessage: (long) index
{
    self.currentEvent.text = [self makeMoveString:self.game.moves[index]];
}

- (CardMatchingGame*) game
{
    if(!_game)
    {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] inMode:self.isIn3CardsMatchMode ? 3 : 2];
    }
    return _game;
}

- (Deck*) createDeck
{
    return [[PlayingDeck alloc] init];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    if([self.modeSwitch isEnabled])
    {
        [self.modeSwitch setEnabled:NO];
    }
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
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundOfCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
        self.scoreCount.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
        if([self.game.moves count])
        {
            self.movesPosition.maximumValue = [self.game.moves count] - 1;
            self.movesPosition.value = self.movesPosition.maximumValue;
            [self setMoveMessage:self.movesPosition.maximumValue];
        }
    }
    
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
