//
//  SetDeck.m
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@interface SetDeck ()
//shapeColors;
//+ (NSArray *) shapeFills;
//+ (NSArray *) numOfShapes;
//+ (NSArray *) shapes;
@end;

@implementation SetDeck

- (instancetype)init
{
  self = [super init];
  if (self) {
    for (SHAPE_SET_GAME shape = DIAMOND; shape < NO_SHAPE; ++shape) {
      for (COLOR_SET_GAME color = RED; color < NO_COLOR; ++color) {
        for (NSNumber* number in [SetCard numOfShapes]) {
          for (FILL_SET_GAME fill = OPEN; fill < NO_FILL; ++fill) {
            SetCard *card = [[SetCard alloc] init];
            if(card)
            {
              card.shape = shape;
              card.color = color;
              card.number = [number integerValue];
              card.fill = fill;
              [self addCard:card];
            }
            else
            {
              return nil;
            }
          }
        }
      }
    }
  }
  return self;
}

@end
