//
//  CardView.h
//  Matchismo
//
//  Created by Noam Ohana on 21/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#ifndef CardView_h
#define CardView_h

@protocol CardView <NSObject> 

@property (nonatomic) BOOL isChosen;
@property (nonatomic) CGRect frame;
@property(nonatomic) CGPoint center;
@end

#endif /* CardView_h */
