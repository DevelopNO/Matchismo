//
//  PlayingCard.m
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard : Card

- (NSString*) contents
{
    NSArray* rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (int) match:(NSArray*) otherCards
{
    int score = 0;
    
    if([otherCards count] > 0)
    {
        for(PlayingCard* otherCard in otherCards)
        {
            if(otherCard.rank == self.rank)
            {
                score += 4;
            }
            else if([otherCard.suit isEqualToString:self.suit] )
            {
                score += 1;
            }
        }
    }
    return score;
}

+ (NSArray*) rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSArray*) validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

@synthesize suit = _suit;

-(void) setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
    {
        _suit = suit;
    }
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count] - 1;
}

- (void)setRank:(NSUInteger)rank
{
    if(rank <= [PlayingCard maxRank])
    {
        _rank = rank;
    }
}

-(NSString*) suit
{
    return _suit ? _suit : @"?";
}

@end
