//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Noam Ohana on 12/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController()

@property (weak, nonatomic) IBOutlet UITextView *historyText;

@end

@implementation HistoryViewController
- (void) viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self updateUI];
}

- (void) updateUI
{
    if(self.attrText)
    {
      self.historyText.attributedText = self.attrText;
    }
    else
    {
      self.historyText.attributedText = [[NSAttributedString alloc] initWithString:@"No History"];
    }
}


@end
