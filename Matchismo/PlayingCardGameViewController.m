//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingDeck.h"

@interface PlayingCardGameViewController()
@end

@implementation PlayingCardGameViewController

- (Deck*) createDeck
{
  return [[PlayingDeck alloc] init];
}
@end


