//
//  SetCardPresentationBuilder.m
//  Matchismo
//
//  Created by Noam Ohana on 11/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "SetCardPresentationBuilder.h"
#import "SetCard.h"
#import <UIKit/UIKit.h>


@implementation SetCardPresentationBuilder


+(NSAttributedString *)getCardPresentation: (SetCard *) card
{
  NSMutableAttributedString *cardText = nil;
  if(card)
  {
      NSString *cardShape = [self getShape:card.shape];
      if(!cardShape)
      {
        return nil;
      }
      cardText = [[NSMutableAttributedString alloc] init];
    //NSLog(@"color: %d, shape: %d, fill: %d, number: %d", card.color, card.shape, card.fill, card.number);
      for(NSInteger i = 0; i < card.number; ++i)
      {
        [cardText insertAttributedString:[[NSAttributedString alloc] initWithString:cardShape] atIndex:i];
      }
    UIColor* color = [self getColor:card.color fill:card.fill];
      [cardText setAttributes:@{NSForegroundColorAttributeName: color} range:NSMakeRange(0, card.number)];
    
      if(card.fill == OPEN)
      {
        [cardText setAttributes:@{ NSStrokeWidthAttributeName: @3,
        NSStrokeColorAttributeName: color} range:NSMakeRange(0, card.number)];
      }
      else if(card.fill == STRIPED)
      {
        [cardText setAttributes:@{ NSStrokeWidthAttributeName: @25,
        NSStrokeColorAttributeName: color} range:NSMakeRange(0, card.number)];
      }
  }
  return cardText;
}
                 
+(NSString *) getShape:(SHAPE_SET_GAME) shape
{
  switch(shape)
  {
    case CIRCLE:
      return @"●";
    case TRIANGLE:
      return @"▲";
    case SQUARE:
      return @"■";
    case NO_SHAPE:
    default:
      return nil;
  }
}

+(UIColor *)getColor:(COLOR_SET_GAME)color fill:(FILL_SET_GAME)cardFill
{
  switch(color)
  {
    case RED:
      return [[UIColor alloc] initWithRed:1.0 green:0 blue:0 alpha:1.0];
    case GREEN:
      return [[UIColor alloc] initWithRed:0 green:1.0 blue:0 alpha:1.0];
  
    case PURPLE:
      return [[UIColor alloc] initWithRed:0.5 green:0 blue:0.5 alpha:1.0];
    case NO_COLOR:
      return nil;
  }
  return nil;
}

+ (CGFloat) getAlpha: (FILL_SET_GAME) cardFill
{
  switch(cardFill)
  {
    case OPEN:
      return 0.3;
    
    case STRIPED:
      return 0.6;
    
    case SOLID:
      return 1.0;
    
    case NO_FILL:
    default:
      return -1;
  }
}

@end
