//
//  CardMatchingMove.h
//  Matchismo
//
//  Created by Noam Ohana on 04/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#ifndef CardMatchingMove_h
#define CardMatchingMove_h


#import <Foundation/Foundation.h>

typedef enum MOVE_TYPE
{
    CARD_OPENED,
    CARD_CLOSED,
    MATCH,
    NO_MATCH
} MOVE_TYPE;


@interface CardMatchingMove : NSObject

- (instancetype) init: (MOVE_TYPE) matchedStatus cardsInMove:(NSArray*)cards;
@property (nonatomic, strong) NSArray* chosenCards;

// status:
// 1 - match
// -1 - no match
// 0 - added new
@property (nonatomic, readonly) MOVE_TYPE moveType;

@end

#endif /* CardMatchingMove_h */
