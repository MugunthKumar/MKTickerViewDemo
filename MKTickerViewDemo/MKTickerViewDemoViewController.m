//
//  MKTickerViewDemoViewController.m
//  MKTickerViewDemo
//
//  Created by Mugunth on 24/06/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import "MKTickerViewDemoViewController.h"

@implementation MKTickerViewDemoViewController

@synthesize tickerView;
@synthesize tickerItems;

- (void)dealloc
{
  [super dealloc];
  
  [tickerView release], tickerView = nil;
  [tickerItems release], tickerItems = nil;
}

- (void)didReceiveMemoryWarning
{
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  
  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
  [super viewDidLoad];
  self.tickerItems = [NSArray arrayWithContentsOfFile:
                      [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:
                       @"tickerdata.plist"]];
  
  [self.tickerView reloadData];  
}


- (void)viewDidUnload
{
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
  self.tickerView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  // Return YES for supported orientations
  return YES;
}

- (UIColor*) backgroundColorForTickerView:(MKTickerView *)vertMenu
{
  return [UIColor whiteColor];
}

- (int) numberOfItemsForTickerView:(MKTickerView *)tabView
{
  return [self.tickerItems count];
}

- (NSString*) tickerView:(MKTickerView *)tickerView titleForItemAtIndex:(NSUInteger)index
{
  NSDictionary *thisDict = [self.tickerItems objectAtIndex:index];
  return [thisDict objectForKey:@"Name"];
}

- (NSString*) tickerView:(MKTickerView *)tickerView valueForItemAtIndex:(NSUInteger)index
{
  NSDictionary *thisDict = [self.tickerItems objectAtIndex:index];
  return [thisDict objectForKey:@"Value"];
}

- (UIImage*) tickerView:(MKTickerView*) tickerView imageForItemAtIndex:(NSUInteger) index
{
  NSDictionary *thisDict = [self.tickerItems objectAtIndex:index];
  NSString *imageFileName = [[thisDict objectForKey:@"Positive"] boolValue] ? @"greenArrow" : @"redArrow";
  return [UIImage imageNamed:imageFileName];
}

@end
