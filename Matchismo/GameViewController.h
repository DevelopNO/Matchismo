//
//  ViewController.h
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardView;

static const CGFloat WIDTH_HEIGHT_RATIO = 0.66;


@class Deck, Card, CardMatchingGame, Grid;

@interface GameViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *scoreCount;
@property (weak, nonatomic) IBOutlet UIView *CardsSpace;
@property (weak, nonatomic) IBOutlet UILabel *currentEvent;
@property (strong, nonatomic) NSMutableArray *cardViews;
@property (strong, nonatomic) Grid *cardsGrid;
@property (strong, nonatomic) CardMatchingGame* game;
- (void)animateCreation:(UIView *)cardView rect:(CGRect )rect delay:
(CGFloat) delay;

- (void) removeAllCards;
- (IBAction)chooseCard:(UITapGestureRecognizer *)sender;
- (void) cardChosenAnimation: (UIView *) cardView isChosen: (BOOL) chosen;
- (void) cardRemoveAnimation:(UIView *)cardToRemove delay:(CGFloat) delay;
- (CGPoint) rightBottomCornerOrigin;
- (NSUInteger)calculateCardIndex: (CGPoint) location;
- (NSAttributedString *) createHistory;
- (Deck*) createDeck;
- (void) setMoveMessage: (long) index;
- (NSInteger) getMode;
- (NSString* ) titleForCard: (Card*) card;
- (UIImage* ) backgroundOfCard: (Card*) card;
- (void) redeal;
- (void) updateUI;
- (void) setGridDimensions;
- (void) setGridDimensions: (NSUInteger) minNOfCells;
- (int) initialNumberOfCards;
- (CGPoint) calculatePointFromIndex: (NSUInteger) index;
- (BOOL)isNull:(id <CardView>)cardView;
- (void) repositionCards;

@end

