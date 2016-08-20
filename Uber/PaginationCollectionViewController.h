//
//  PaginationCollectionViewController.h
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 17/08/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UCollectionViewController.h"

@protocol PaginationCollectionProtocol <NSObject>

@optional
- (void)loadMore;

@end

@interface PaginationCollectionViewController : UCollectionViewController <PaginationCollectionProtocol>

@end
