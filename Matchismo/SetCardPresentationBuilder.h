//
//  SetCardPresentationBuilder.h
//  Matchismo
//
//  Created by Noam Ohana on 11/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class SetCard;

@interface SetCardPresentationBuilder : NSObject
+(NSAttributedString *)getCardPresentation: (SetCard *) card;
@end

NS_ASSUME_NONNULL_END
