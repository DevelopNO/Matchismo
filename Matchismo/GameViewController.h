//
//  ViewController.h
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Deck, Card, CardMatchingGame;

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *currentEvent;
@property (strong, nonatomic) CardMatchingGame* game;
- (Deck*) createDeck;
-(void) setMoveMessage: (long) index;
- (NSInteger) getMode;
- (NSString* ) titleForCard: (Card*) card;
- (UIImage* ) backgroundOfCard: (Card*) card;

@end

