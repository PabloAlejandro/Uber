//
//  ImageDownloader.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "ImageDownloader.h"
#import "NSURLSession+Factory.h"

@implementation ImageDownloader

- (void)downloadImageForUrl:(NSURL *)url collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    // TODO: Add NSURLSessionDataTask to a NSDictionary with the indexPath as key, so that when we get a new
    // request for the same indexPath we can cancel it.
    
    __weak typeof (self) weakSelf = self;
    
    [NSURLSession sendAsynchronousRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        __strong typeof (self) strongSelf = weakSelf;
        if(error == nil) {
            UIImage * image = [[UIImage alloc] initWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if([strongSelf.delegate respondsToSelector:@selector(imageDidDownload:collectionView:forIndexPath:userInfo:)])
                        [strongSelf.delegate imageDidDownload:image collectionView:collectionView forIndexPath:indexPath userInfo:userInfo];
                });
            }
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if([strongSelf.delegate respondsToSelector:@selector(imageDidFailDownload:collectionView:forIndexPath:userInfo:)])
                    [strongSelf.delegate imageDidFailDownload:error collectionView:collectionView forIndexPath:indexPath userInfo:userInfo];
            });
        }
    }];
}

@end
