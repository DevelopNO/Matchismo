//
//  SetCard.h
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "Card.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetCard : Card

@property (nonatomic, strong) NSString *shape;
@property (nonatomic, strong) NSString *fill;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSNumber *number;

+ (NSArray *) shapeColors;
+ (NSArray *) shapeFills;
+ (NSArray *) numOfShapes;
+ (NSArray *) shapes;

@end

NS_ASSUME_NONNULL_END
