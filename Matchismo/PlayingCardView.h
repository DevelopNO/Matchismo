//
//  PlayingCardView.h
//  SuperCard
//
//  Created by Noam Ohana on 15/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlayingCardView : UIView
- (void) pinch: (UIPinchGestureRecognizer *) gesture;

@property (nonatomic, strong) NSString* suit;
@property (nonatomic) NSInteger rank;
@property (nonatomic) BOOL facedUp;
@end

NS_ASSUME_NONNULL_END
