//
//  CustomCache.h
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 27/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CustomCache : NSObject

+ (void)cacheImage:(UIImage *)image forUrl:(NSURL *)url;
+ (UIImage *)cachedImageForUrl:(NSURL *)url;

@end
