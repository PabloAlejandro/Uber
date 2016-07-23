//
//  Photos.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "Photos.h"

@implementation Photos

- (NSMutableArray <Photo *> *)photos
{
    if(!_photos) {
        _photos = [NSMutableArray new];
    }
    return _photos;
}

@end
