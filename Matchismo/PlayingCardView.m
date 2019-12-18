//
//  PlayingCardView.m
//  SuperCard
//
//  Created by Noam Ohana on 15/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "PlayingCardView.h"
@interface PlayingCardView()
@property (nonatomic) CGFloat facedCardScaledFactor;
@end


@implementation PlayingCardView
@synthesize facedCardScaledFactor = _facedCardScaledFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR (0.9)

- (void) setFacedCardScaledFactor:(CGFloat)facedCardScaledFactor
{
  _facedCardScaledFactor = facedCardScaledFactor;
  [self setNeedsDisplay];
}

- (CGFloat) facedCardScaledFactor
{
  if(!_facedCardScaledFactor)
  {
    _facedCardScaledFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
  }
  return _facedCardScaledFactor;
}

- (void) setSuit: (NSString *) suit
{
  _suit = suit;
  [self setNeedsDisplay];
}

- (void) setRank: (NSInteger) rank
{
  _rank = rank;
  [self setNeedsDisplay];
}

- (void) setFacedUp: (BOOL) facedUp
{
  _facedUp = facedUp;
  [self setNeedsDisplay];
}
#define CORNER_FONT_STANDARD_HEIGHT (180.0)
#define CORNER_RADIUS (12.0)

- (CGFloat) cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat) cornerRadius {return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat) cornerOffSet { return [self cornerRadius] / 3.0; }


- (void) setup
{
  self.backgroundColor = nil;
  self.opaque = NO;
  self.contentMode = UIViewContentModeRedraw;
}

- (void) awakeFromNib
{
  [super awakeFromNib];
  [self setup];
}

- (void) pinch: (UIPinchGestureRecognizer *) gesture
{
  if(gesture.state == UIGestureRecognizerStateChanged ||
     gesture.state == UIGestureRecognizerStateEnded)
  {
    self.facedCardScaledFactor *= gesture.scale;
    gesture.scale = 1.0;
  }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
     //Drawing code
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  [roundedRect addClip];
  
  [[UIColor whiteColor] setFill];
  UIRectFill(self.bounds);
  
  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
  
  if(self.facedUp)
  {
    UIImage *faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", [self rankAsString], self.suit]];
    if(faceImage)
    {
      CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0 - self.facedCardScaledFactor),
                                     self.bounds.size.height * (1.0 - self.facedCardScaledFactor));
      [faceImage drawInRect:imageRect];
    }
    else
    {
      [self drawPips];
    }
    
    [self drawCorners];
  }
  else
  {
    [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
  }
}

#define PIP_HOFFSET_PERCENTAGE (0.165)
#define PIP_VOFFSET1_PERCENTAGE (0.090)
#define PIP_VOFFSET2_PERCENTAGE (0.175)
#define PIP_VOFFSET3_PERCENTAGE (0.270)

- (void) drawPips
{
  if((self.rank == 1) || (self.rank == 5) || (self.rank == 9) || (self.rank == 3))
  {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:0
                    mirroredVertically:NO];
  }
  if((self.rank == 6) || (self.rank == 7) || (self.rank == 8))
  {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:0
                    mirroredVertically:NO];

  }
  if((self.rank == 2) || (self.rank == 3) || (self.rank == 7) || (self.rank == 8) || (self.rank == 10))
  {
    [self drawPipsWithHorizontalOffset:0
                        verticalOffset:PIP_VOFFSET2_PERCENTAGE
                    mirroredVertically:(self.rank != 7)];

  }
  if((self.rank == 4) || (self.rank == 5) || (self.rank == 6) || (self.rank == 7) || (self.rank == 8) || (self.rank == 9) || (self.rank == 10))
  {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET3_PERCENTAGE
                    mirroredVertically:YES];

  }
  if((self.rank == 9) || (self.rank == 10))
  {
    [self drawPipsWithHorizontalOffset:PIP_HOFFSET_PERCENTAGE
                        verticalOffset:PIP_VOFFSET1_PERCENTAGE
                    mirroredVertically:YES];

  }

}

#define PIP_FONT_SCALE_FACTOR (0.012)

- (void) drawPipsWithHorizontalOffset:(CGFloat)hoffset verticalOffset:(CGFloat)voffset upsideDown:(BOOL) upsideDown
{
  if(upsideDown)
  {
    [self pushContextAndRotateUpsideDown];
  }
  
  CGPoint middle = CGPointMake (self.bounds.size.width / 2, self.bounds.size.height / 2);
  UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  
  pipFont = [pipFont fontWithSize:[pipFont pointSize] * self.bounds.size.width * PIP_FONT_SCALE_FACTOR];

  
  NSAttributedString *attrSuit = [[NSAttributedString alloc] initWithString:self.suit attributes:@{ NSFontAttributeName: pipFont}];
  CGSize pipSize = [attrSuit size];
  CGPoint pipOrigin = CGPointMake(middle.x - pipSize.width / 2.0 - hoffset * self.bounds.size.width,
                                  middle.y - pipSize.height / 2.0 - voffset * self.bounds.size.height);
  [attrSuit drawAtPoint:pipOrigin];
  
  if(hoffset)
  {
    pipOrigin.x += hoffset * 2.0 * self.bounds.size.width;
    [attrSuit drawAtPoint:pipOrigin];
  }
  
  if(upsideDown) [self popContext];
}


-(void) drawPipsWithHorizontalOffset: (CGFloat) hoffset
                      verticalOffset: (CGFloat) voffset
                  mirroredVertically: (BOOL) mirroredVertically
{
  [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:NO];
  if(mirroredVertically)
  {
   [self drawPipsWithHorizontalOffset:hoffset verticalOffset:voffset upsideDown:YES];
  }
}

-(void) pushContextAndRotateUpsideDown
{
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSaveGState(context);
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
  
}

-(void) popContext
{
  CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (NSString *)rankAsString
{
  return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"][self.rank];
}

- (void) drawCorners
{
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.alignment = NSTextAlignmentCenter;
  
  UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
  cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self cornerScaleFactor]];
  
  NSAttributedString* cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",[self rankAsString], self.suit] attributes:@{ NSFontAttributeName: cornerFont, NSParagraphStyleAttributeName: paragraphStyle,
      NSForegroundColorAttributeName: [self.suit isEqual:@"♥︎"] ||  [self.suit isEqual:@"♦︎"] ? [UIColor redColor] : [UIColor blackColor]
  }];
  
  CGRect textBounds;
  textBounds.origin = CGPointMake([self cornerOffSet], [self cornerOffSet]);
  textBounds.size = [cornerText size];
  [cornerText drawInRect:textBounds];
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
  CGContextRotateCTM(context, M_PI);
  [cornerText drawInRect:textBounds];
  
}

@end
