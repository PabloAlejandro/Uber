//
//  HistoryViewController.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryDelegate <NSObject>

@optional
- (void)historyDidSelectSearch:(NSString *)search;

@end

@interface HistoryViewController : UITableViewController

@property (nonatomic, weak) id <HistoryDelegate> delegate;

@end
