//
//  ViewController.h
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>



@class Deck, Card, CardMatchingGame, Grid;

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;
@property (weak, nonatomic) IBOutlet UIView *CardsSpace;
@property (weak, nonatomic) IBOutlet UILabel *currentEvent;
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) Grid *cardsGrid;
@property (strong, nonatomic) CardMatchingGame* game;
- (NSUInteger)calculateCardIndex: (CGPoint) location;
- (NSAttributedString *) createHistory;
- (Deck*) createDeck;
- (void) setMoveMessage: (long) index;
- (NSInteger) getMode;
- (NSString* ) titleForCard: (Card*) card;
- (UIImage* ) backgroundOfCard: (Card*) card;
- (void)redeal;
- (void) updateUI;
@end

