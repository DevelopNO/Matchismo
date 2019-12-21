//
//  SetCardView.h
//  SuperCard
//
//  Created by Noam Ohana on 19/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetParameters.h"
#import "CardView.h"
NS_ASSUME_NONNULL_BEGIN




@interface SetCardView : UIView<CardView>

@property (nonatomic) SHAPE_SET_GAME shape;
@property (nonatomic) FILL_SET_GAME fill;
@property (nonatomic) COLOR_SET_GAME color;
@property (nonatomic) NSInteger numberOfShapes;
@property (nonatomic) BOOL isChosen;
@end

NS_ASSUME_NONNULL_END
