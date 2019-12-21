//
//  SetCardView.m
//  SuperCard
//
//  Created by Noam Ohana on 19/12/2019.
//  Copyright © 2019 Lightricks.ltd. All rights reserved.
//

#import "SetCardView.h"
#import "Grid.h"

@interface SetCardView()

@property (nonatomic, strong) Grid *shapeGrid;
@property (nonatomic, strong) NSMutableArray *drawingPaths;
@end

@implementation SetCardView
@synthesize shape = _shape;
@synthesize color = _color;
@synthesize fill = _fill;
@synthesize numberOfShapes = _numberOfShapes;

- (void) setIsChosen: (BOOL) isChosen
{
  _isChosen = isChosen;
  [self setNeedsDisplay];
}

-(NSInteger) numberOfShapes
{
  if(_numberOfShapes > 3 || _numberOfShapes < 0)
  {
    _numberOfShapes = 0;
  }
  return _numberOfShapes;
}


- (SHAPE_SET_GAME) shape
{
  if(_shape > NO_SHAPE || _shape < DIAMOND)
  {
    _shape = NO_SHAPE;
  }
  return _shape;
}

- (COLOR_SET_GAME) color
{
  if(_color > NO_COLOR || _color < RED)
  {
    _color = NO_COLOR;
  }
  return _color;
}

- (FILL_SET_GAME) fill
{
  if(_fill > NO_FILL || _fill < OPEN)
  {
    _fill = NO_FILL;
  }
  return _fill;
}

- (Grid *) shapeGrid
{
  if(!_shapeGrid)
  {
    _shapeGrid = [[Grid alloc] init];
  }
  return _shapeGrid;
}


- (void) setUp
{
  
}

- (CGSize) shapeSize
{
  CGSize size = {.width = self.bounds.size.width * .6, .height = self.bounds.size.height * 1.3 / 9.0};
  return size;
}

- (CGFloat) calculateVerticalSpace
{
  CGFloat noShapeSize = self.bounds.size.height - self.numberOfShapes * [self shapeSize].height;
  return noShapeSize / (self.numberOfShapes + 1);
}

const CGFloat HORIZONTAL_SPACE_RATIO = 3.0 / 18.0;

- (CGFloat) calculateHorizontalSpace
{
  return self.bounds.size.width * HORIZONTAL_SPACE_RATIO;
}

- (NSArray *) calculateRectsForShpaes
{
  NSMutableArray *rects = [[NSMutableArray alloc] init];
  CGSize singleShapeSize = [self shapeSize];
  CGFloat singleVerticalSpace = [self calculateVerticalSpace];
  CGFloat singleHorizontalSpace = [self calculateHorizontalSpace];
  
  for(int i = 1; i < self.numberOfShapes + 1; ++i)
  {
    CGRect rect = CGRectMake(self.bounds.origin.x + singleHorizontalSpace, self.bounds.origin.y + i * singleVerticalSpace + (singleShapeSize.height * (i - 1)), singleShapeSize.width, singleShapeSize.height);
    
    [rects addObject:[NSValue valueWithCGRect:rect]];
  }
  return rects;
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  [self setUp];
}

- (UIColor *) getColor
{
  switch (self.color) {
    case RED:
      return [UIColor redColor];
    case GREEN:
      return [UIColor greenColor];
    case PURPLE:
      return [UIColor purpleColor];
    default:
      return nil;
  }
}

- (UIBezierPath *) drawDiamond: (CGRect) rect
{

  UIBezierPath *shape = [[UIBezierPath alloc] init];
  [shape moveToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y)];
  [shape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height / 2)];
  [shape addLineToPoint:CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height)];
  [shape addLineToPoint:CGPointMake(rect.origin.x, rect.origin.y + rect.size.height / 2)];
  [shape closePath];
  [shape addClip];
  return shape;

}

- (void) drawStripes: (CGRect) drawingRect
{
  UIBezierPath *stripes = [UIBezierPath bezierPath];
  for ( CGFloat barPosition = 0.0; barPosition < drawingRect.size.width; barPosition += drawingRect.size.width / 20.0 )
  {
      [stripes moveToPoint:CGPointMake( drawingRect.origin.x + barPosition, drawingRect.origin.y )];
      [stripes addLineToPoint:CGPointMake( drawingRect.origin.x + barPosition, drawingRect.origin.y + drawingRect.size.height)];
  }
  [stripes stroke];
}

- (UIBezierPath *) drawOval: (CGRect) rect
{
  UIBezierPath *shape = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.height];
  [shape addClip];
  return shape;
}

- (UIBezierPath *) drawSquiggle: (CGRect) rect
{
  UIBezierPath *shape = [[UIBezierPath alloc] init];

  shape.lineWidth = 2;

  [shape moveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.05, rect.origin.y + rect.size.height*0.40)];

  [shape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.35, rect.origin.y + rect.size.height*0.25)
          controlPoint1:CGPointMake(rect.origin.x + rect.size.width*0.09, rect.origin.y + rect.size.height*0.15)
          controlPoint2:CGPointMake(rect.origin.x + rect.size.width*0.18, rect.origin.y + rect.size.height*0.10)];

  [shape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.75, rect.origin.y + rect.size.height*0.30)
          controlPoint1:CGPointMake(rect.origin.x + rect.size.width*0.40, rect.origin.y + rect.size.height*0.30)
          controlPoint2:CGPointMake(rect.origin.x + rect.size.width*0.60, rect.origin.y + rect.size.height*0.45)];

  [shape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.97, rect.origin.y + rect.size.height*0.35)
          controlPoint1:CGPointMake(rect.origin.x + rect.size.width*0.87, rect.origin.y + rect.size.height*0.15)
          controlPoint2:CGPointMake(rect.origin.x + rect.size.width*0.98, rect.origin.y + rect.size.height*0.00)];

  [shape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.45, rect.origin.y + rect.size.height*0.85)
          controlPoint1:CGPointMake(rect.origin.x + rect.size.width*0.95, rect.origin.y + rect.size.height*1.10)
          controlPoint2:CGPointMake(rect.origin.x + rect.size.width*0.50, rect.origin.y + rect.size.height*0.95)];

  [shape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.25, rect.origin.y + rect.size.height*0.85)
          controlPoint1:CGPointMake(rect.origin.x + rect.size.width*0.40, rect.origin.y + rect.size.height*0.80)
          controlPoint2:CGPointMake(rect.origin.x + rect.size.width*0.35, rect.origin.y + rect.size.height*0.75)];

  [shape addCurveToPoint:CGPointMake(rect.origin.x + rect.size.width*0.05, rect.origin.y + rect.size.height*0.40)
          controlPoint1:CGPointMake(rect.origin.x + rect.size.width*0.00, rect.origin.y + rect.size.height*1.10)
          controlPoint2:CGPointMake(rect.origin.x + rect.size.width*0.005, rect.origin.y + rect.size.height*0.60)];

  [shape closePath];
  [shape addClip];
  return shape;
}



- (UIBezierPath *) drawShape: (CGRect) rect
{
  switch(self.shape)
  {
    case DIAMOND:
      return [self drawDiamond:rect];
    case OVAL:
      return [self drawOval:rect];
    case SQUIGGLE:
      return [self drawSquiggle:rect];
    default:
      return nil;
  }
}

#define CORNER_FONT_STANDARD_HEIGHT (180.0)
#define CORNER_RADIUS (12.0)

- (CGFloat) cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat) cornerRadius {return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat) cornerOffSet { return [self cornerRadius] / 3.0; }

- (void) drawShapes: (NSArray *) rects
{
  for(int i = 0; i < [rects count]; ++i)
  {
    CGContextRef c = UIGraphicsGetCurrentContext();
    CGContextSaveGState(c);
    CGRect rect = [[rects objectAtIndex:i] CGRectValue];
    UIBezierPath *shape = [self drawShape: rect];
    
    if(self.fill == SOLID)
    {
     [[self getColor] setFill];
    }
    else
    {
      [[UIColor whiteColor] setFill];
    }
    
    
    
    [[self getColor] setStroke];
    [shape fill];
    [shape stroke];
    if(self.fill == STRIPED)
    {
      [self drawStripes:(CGRect) rect];
    }

    [self.drawingPaths addObject:shape];
    CGContextRestoreGState(c);
  }
}

- (NSMutableArray *) drawingPaths
{
  if(!_drawingPaths)
  {
    _drawingPaths = [[NSMutableArray alloc] init];
  }
  return _drawingPaths;
}

- (void) drawRect:(CGRect)rect
{
//  CGContextRef ref = UIGraphicsGetCurrentContext();
//  CGContextSaveGState(ref);
  UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
  [roundedRect addClip];
  
  if(self.isChosen)
  {
    [[UIColor colorWithRed: 180.0/255.0 green: 238.0/255.0 blue:180.0/255.0 alpha: 1.0] setFill];
  }
  else
  {
    [[UIColor whiteColor] setFill];
  }
  
  
  [roundedRect fill];

  [[UIColor blackColor] setStroke];
  [roundedRect stroke];
//  CGContextRestoreGState(ref);
  if(self.shape == NO_SHAPE || self.color == NO_COLOR || self.fill == NO_FILL || self.numberOfShapes == 0)
  {
    return;
  }
  

  [self.drawingPaths removeAllObjects];
  NSArray *rectsForShapes = [self calculateRectsForShpaes];
  [self drawShapes:rectsForShapes];
  
}

@end
