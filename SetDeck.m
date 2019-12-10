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
    for (NSString* color in [SetCard shapeColors]) {
      for (NSString* shape in [SetCard shapes]) {
        for (NSNumber* number in [SetCard numOfShapes]) {
          for (NSString* fill in [SetCard shapeFills]) {
            SetCard *card = [[SetCard alloc] init];
            if(card)
            {
              card.shape = shape;
              card.color = color;
              card.number = number;
              card.fill = fill;
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
