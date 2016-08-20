//
//  CustomCache.m
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 27/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "CustomCache.h"

@implementation CustomCache

#pragma mark - Public methods

+ (void)cacheImage:(UIImage *)image forUrl:(NSURL *)url
{
    [self cacheImageInternal:image forUrl:[url absoluteString]];
}

+ (UIImage *)cachedImageForUrl:(NSURL *)url
{
    return [self cachedImageInternalForUrl:[url absoluteString]];
}

#pragma mark - Private methods

+ (BOOL)cacheImageInternal:(UIImage *)image forUrl:(NSString *)url
{
    NSData *imageData = UIImagePNGRepresentation(image);
    
    NSString *documentsDirectory = [self documentsDirectory];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:url];
    
    NSLog(@"%s -> %@", __func__, imagePath);
    
    return [imageData writeToFile:imagePath atomically:NO];
}

+ (UIImage *)cachedImageInternalForUrl:(NSString *)url
{
    NSString *documentsDirectory = [self documentsDirectory];
    
    NSString *imagePath = [documentsDirectory stringByAppendingPathComponent:url];
    
    NSError * error = nil;
    NSData * imageData = [NSData dataWithContentsOfFile:imagePath options:0 error:&error];
    
    NSLog(@"%s -> %@", __func__, imagePath);
    
    return error == nil ? [UIImage imageWithData:imageData] : nil;
}

+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

@end
