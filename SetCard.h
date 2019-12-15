//
//  SetCard.h
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum SHAPE_SET_GAME
{
  TRIANGLE = 0,
  SQUARE,
  CIRCLE,
  NO_SHAPE
}SHAPE_SET_GAME;

typedef enum COLOR_SET_GAME
{
  RED = 0,
  GREEN,
  PURPLE,
  NO_COLOR
}COLOR_SET_GAME;

typedef enum FILL_SET_GAME
{
  OPEN = 0,
  STRIPED,
  SOLID,
  NO_FILL
}FILL_SET_GAME;

@interface SetCard : Card

@property (nonatomic) SHAPE_SET_GAME shape;
@property (nonatomic) FILL_SET_GAME fill;
@property (nonatomic) COLOR_SET_GAME color;
@property (nonatomic) NSInteger number;


+ (NSArray *) numOfShapes;


@end

NS_ASSUME_NONNULL_END
