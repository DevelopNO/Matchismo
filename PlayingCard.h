//
//  PlayingCard.h
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#ifndef PlayingCard_h
#define PlayingCard_h

#import "Card.h"

@interface PlayingCard : Card
@property (strong, nonatomic) NSString* suit;
@property (nonatomic) NSUInteger rank;

+(NSArray*)validSuits;
+(NSUInteger)maxRank;
@end

#endif /* PlayingCard_h */
