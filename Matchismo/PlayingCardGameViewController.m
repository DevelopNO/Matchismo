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

@interface PlayingCardGameViewController()
@end

@implementation PlayingCardGameViewController

- (Deck*) createDeck
{
  return [[PlayingDeck alloc] init];
}


- (CardMatchingGame*) game
{
  if(!super.game)
  {
      super.game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count] usingDeck:[self createDeck] inMode:2];
  }
  return super.game;
}
@end


