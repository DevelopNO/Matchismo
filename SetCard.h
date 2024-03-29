//
//  SetCard.h
//  Matchismo
//
//  Created by Noam Ohana on 10/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "Card.h"
#import "SetParameters.h"

NS_ASSUME_NONNULL_BEGIN



@interface SetCard : Card

@property (nonatomic) SHAPE_SET_GAME shape;
@property (nonatomic) FILL_SET_GAME fill;
@property (nonatomic) COLOR_SET_GAME color;
@property (nonatomic) NSInteger number;


+ (NSArray *) numOfShapes;


@end

NS_ASSUME_NONNULL_END
