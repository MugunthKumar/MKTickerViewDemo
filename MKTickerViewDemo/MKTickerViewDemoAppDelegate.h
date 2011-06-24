//
//  MKTickerViewDemoAppDelegate.h
//  MKTickerViewDemo
//
//  Created by Mugunth on 24/06/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKTickerViewDemoViewController;

@interface MKTickerViewDemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet MKTickerViewDemoViewController *viewController;

@end
