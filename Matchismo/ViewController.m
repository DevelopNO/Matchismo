//
//  ViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "ViewController.h"
#import "PlayingDeck.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLable;
@property (nonatomic) int flipCount;
@property (nonatomic, strong) Deck* deck;
@end

@implementation ViewController

-(Deck*)deck
{
    if(!_deck)
    {
        _deck = [[PlayingDeck alloc] init];
    }
    return _deck;
}

- (void) setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLable.text = [NSString stringWithFormat:@"Filps: %d", self.flipCount];
    NSLog(@"flipCount changed to %d", self.flipCount);
}

- (IBAction)touchCardButton:(UIButton *)sender {
    if([sender.currentTitle length])
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"cardBack"]
                      forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
    }
    else
    {
        Card* card = [self.deck drawRandomCard];
        if(card)
        {
            [sender setBackgroundImage:[UIImage imageNamed:@"cardFront"]
                              forState:UIControlStateNormal];
            [sender setTitle:[card contents] forState:UIControlStateNormal];
        }
    }
    ++self.flipCount;
}

@end
