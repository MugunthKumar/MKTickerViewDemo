//
//  MKTickerView.m
//  MKTickerViewDemo
//  Created by Mugunth on 09/05/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//  Permission granted to do anything, commercial/non-commercial with this file apart from removing the line/URL above
//  Read my blog post at http://mk.sg/8i on how to use this code

//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	While I'm ok with modifications to this source code, 
//	if you are re-publishing after editing, please retain the above copyright notices

#import "MKTickerView.h"
#define kButtonBaseTag 10000
#define kLabelPadding 10
#define kItemPadding 30
#define kMaxWidth 200
#define kSpacer 100
#define kPixelsPerSecond 100.0f

@implementation MKTickerItemView

static UIFont *titleFont = nil;
static UIFont *valueFont = nil;

-(id) initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self != nil)
  {
    self.frame = CGRectMake(0, 0, 10, 26);
    self.opaque = YES;
    self.contentMode = UIViewContentModeCenter;
  }
  
  return self;
}
+(void) initialize
{
  titleFont = [[UIFont boldSystemFontOfSize:15] retain];
  valueFont = [[UIFont systemFontOfSize:15] retain];
}

+(void) dealloc
{
  [titleFont release], titleFont = nil;
  [valueFont release], valueFont = nil;
  [super dealloc];
}

-(CGFloat) titleWidth
{
  return [_title sizeWithFont:titleFont
            constrainedToSize:CGSizeMake(kMaxWidth, self.frame.size.height)                     
                lineBreakMode:UILineBreakModeClip].width;
}

-(CGFloat) valueWidth
{
  return [_value sizeWithFont:valueFont         
            constrainedToSize:CGSizeMake(kMaxWidth, self.frame.size.height)                                 
                lineBreakMode:UILineBreakModeClip].width;
}

-(CGFloat) width
{
  return 18 + [self titleWidth] + [self valueWidth] + kLabelPadding;
}

- (void) setTitle:(NSString *) title value:(NSString*) value image:(UIImage*) image
{
  if(_title != title)
  {
    [_title release];
    _title = [title retain];
  }
  if(_value != value)
  {
    [_value release];
    _value = [value retain];
  }
  if(_image != image)
  {
    [_image release];
    _image = [image retain];
  }
  
  self.frame = CGRectMake(0, 0, [self width], 26);

  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
  CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
	CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));

  CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [UIColor blueColor].CGColor);

  [_image drawInRect:CGRectMake(0, 9, 12, 7)];
  [_title drawInRect:CGRectMake(18, 2, [self titleWidth], 26) withFont:titleFont];
  [_value drawInRect:CGRectMake(18 + [self titleWidth] + kLabelPadding, 2, [self valueWidth], 26) withFont:valueFont];
  
  [super drawRect:rect];
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
  [_title release], _title = nil;
  [_value release], _value = nil;
  [_image release], _image = nil;
  
  [super dealloc];
}


@end

@implementation MKTickerView

@synthesize dataSource;

-(void) awakeFromNib
{
  self.bounces = YES;
  self.scrollEnabled = YES;
  self.alwaysBounceHorizontal = YES;
  self.alwaysBounceVertical = NO;
  self.showsHorizontalScrollIndicator = NO;
  self.showsVerticalScrollIndicator = NO;  
}

-(void) reloadData
{
  int itemCount = [dataSource numberOfItemsForTickerView:self];
  self.backgroundColor = [dataSource backgroundColorForTickerView:self];
  
  int xPos = 0;
  for(int i = 0 ; i < itemCount; i ++)
  {
    MKTickerItemView *tickerItemView = [[[MKTickerItemView alloc] init] autorelease];
    [tickerItemView setTitle:[dataSource tickerView:self titleForItemAtIndex:i]
                       value:[dataSource tickerView:self valueForItemAtIndex:i]
                       image:[dataSource tickerView:self imageForItemAtIndex:i]];
    
    tickerItemView.frame = CGRectMake(xPos, 0, [tickerItemView width], self.frame.size.height);
    xPos += ([tickerItemView width] + kItemPadding);
    [self addSubview:tickerItemView];
  }
  
  self.contentSize = CGSizeMake(xPos + self.frame.size.width + kSpacer, self.frame.size.height);
  self.contentOffset = CGPointMake(- self.frame.size.width/2, 0);

  xPos += kSpacer;

  CGFloat breakWidth = 0;
  for(int counter = 0 ; breakWidth < self.frame.size.width; counter ++)
  {
    int i = counter % itemCount;
    MKTickerItemView *tickerItemView = [[[MKTickerItemView alloc] init] autorelease];
    [tickerItemView setTitle:[dataSource tickerView:self titleForItemAtIndex:i]
                       value:[dataSource tickerView:self valueForItemAtIndex:i]
                       image:[dataSource tickerView:self imageForItemAtIndex:i]];
    
    tickerItemView.frame = CGRectMake(xPos, 0, [tickerItemView width], self.frame.size.height);
    xPos += ([tickerItemView width] + kItemPadding);
    breakWidth += ([tickerItemView width] + kItemPadding);
    [self addSubview:tickerItemView];
  }

  [self startAnimation];
}

-(void) startAnimation
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveLinear];
  [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];	
  NSTimeInterval animationDuration =  self.contentSize.width/kPixelsPerSecond;
  [UIView setAnimationDuration:animationDuration];
  [UIView setAnimationDelegate:self];
  [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
  self.contentOffset = CGPointMake(self.contentSize.width - self.frame.size.width, 0);

  [UIView commitAnimations];
}
   
-(void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
  self.contentOffset = CGPointMake(0, 0);
  [self startAnimation];
}

- (void)dealloc
{
  [super dealloc];
}

@end
