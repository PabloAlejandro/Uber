//
//  Photos.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Photo;

@interface Photos : NSObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger pages;
@property (nonatomic, assign) NSInteger perpage;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, strong) NSMutableArray <Photo *> * photos;
@property (nonatomic, strong) NSString * search;

@end
