//
//  SetCard.m
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "SetCard.h"

@interface SetCard ()

@end



@implementation SetCard 

- (void) setContents:(NSString *)contents
{
 
}

+ (NSArray *) numOfShapes
{
    return @[@1, @2, @3];
}


- (NSString *) contents
{
  return nil;
}

-(BOOL) checkShape:(NSArray*) otherCards
{
  SetCard* card1 = otherCards[0];
  SetCard* card2 = otherCards[1];
  
  bool allEquals = card1.shape == self.shape && self.shape == card2.shape;
  bool allDifferent = card1.shape != self.shape && card2.shape != self.shape && card1.shape != card2.shape;
  return allEquals || allDifferent;
}

-(BOOL) checkFill:(NSArray*) otherCards
{
  SetCard* card1 = otherCards[0];
  SetCard* card2 = otherCards[1];
  
  bool allEquals = card1.fill == self.fill && self.fill == card2.fill;
  bool allDifferent = card1.fill != self.fill && card2.fill != self.fill && card1.fill != card2.fill;
  return allEquals || allDifferent;
}

-(BOOL) checkNumber:(NSArray*) otherCards
{
  SetCard* card1 = otherCards[0];
  SetCard* card2 = otherCards[1];
  
  bool allEquals = card1.number == self.number && self.number == card2.number;
  bool allDifferent = card1.number != self.number && card2.number != self.number && card1.number != card2.number;
  return allEquals || allDifferent;
}

-(BOOL) checkColor:(NSArray*) otherCards
{
  SetCard* card1 = otherCards[0];
  SetCard* card2 = otherCards[1];
  
  bool allEquals = card1.color == self.color && self.color == card2.color;
  bool allDifferent = card1.color != self.color && card2.color != self.color && card1.color != card2.color;
  return allEquals || allDifferent;
}

-(BOOL) canBeSet:(NSArray*) otherCards
{
  return [self checkShape:otherCards] && [self checkFill:otherCards] && [self checkNumber:otherCards] && [self checkColor:otherCards];
}


- (int) match:(NSArray*) otherCards
{
    int score = 0;
    
    if([otherCards count] == 2)
    {
      if([self canBeSet:otherCards])
      {
        return 3;
      }
    }
    return score;
}

@end
