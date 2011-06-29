//
//  MKTickerViewDemoViewController.h
//  MKTickerViewDemo
//
//  Created by Mugunth on 24/06/11.
//  Copyright 2011 Steinlogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTickerView.h"

@interface MKTickerViewDemoViewController : UIViewController {
    
}

@property (nonatomic, retain) IBOutlet MKTickerView *tickerView;
@property (nonatomic, retain) NSArray *tickerItems;

@end
