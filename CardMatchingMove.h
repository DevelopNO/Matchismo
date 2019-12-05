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



@interface CardMatchingMove : NSObject

- (instancetype) init: (int) matchedStatus cardsInMove:(NSArray*)cards;
@property (nonatomic, strong) NSArray* chosenCards;

// status:
// 1 - match
// -1 - no match
// 0 - added new
@property (nonatomic) int moveStatus;
 

@end

#endif /* CardMatchingMove_h */
