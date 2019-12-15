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

+ (NSArray *) shapeColors
{
  return @[@"red", @"green", @"purple"];
}

+ (NSArray *) shapeFills
{
  return @[@"open", @"striped", @"solid"];
}

+ (NSArray *) numOfShapes
{
    return @[@1, @2, @3];
}

+ (NSArray *) shapes
{
    return @[@"▲", @"●", @"◼︎"];
}

- (NSString *) contents
{
  return nil;
}

@end
