//
//  PhotoCollectionController.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaginationCollectionViewController.h"

@class Photos;

@interface PhotoCollectionController : PaginationCollectionViewController

@property (nonatomic, strong) Photos * photos;

@end