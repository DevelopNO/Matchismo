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
@property (weak, nonatomic) IBOutlet UILabel *SliderIndex_debug;
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
    self.game = nil;
    self.scoreCount.text = @"Score: 0";
    [self updateUI];
    [self.modeSwitch setEnabled:YES];
}
- (IBAction)CangeMoveTitle:(UISlider *)sender
{
    long sliderValue = lroundf(self.movesPosition.value);
    [self.movesPosition setValue:sliderValue animated:YES];
    self.SliderIndex_debug.text = [ NSString stringWithFormat:@"%d", (int)sender.value];
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
        self.movesPosition.maximumValue = [self.game.moves count] - 1;
    }
    
    NSString* lastMoveText = [self makeMoveString:[self.game.moves lastObject]];
    self.currentEvent.text =lastMoveText;
}

-(NSString*) makeMoveString: (CardMatchingMove*) move
{
    NSMutableString* moveText = [[NSMutableString alloc] init];
    
    if(!move.moveStatus && [move.chosenCards count] == 0)
    {
        return @"Please pick a card";
    }
    if(move.moveStatus)
    {
        [moveText appendFormat:@"%@ ", move.moveStatus > 0 ? @"Match between" : @"No match between"];
    }
    
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
