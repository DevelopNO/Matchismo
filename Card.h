//
//  Card.h
//  Matchismo
//
//  Created by Noam Ohana on 02/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Card : NSObject
@property (strong, nonatomic) NSString* contents;
@property (nonatomic) BOOL isChosen;
@property (nonatomic) BOOL isMatched;

- (int) match:(NSArray *) otherCards;

@end

NS_ASSUME_NONNULL_END
