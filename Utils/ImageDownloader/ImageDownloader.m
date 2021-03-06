//
//  ImageDownloader.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "ImageDownloader.h"
#import "NetworkFactoryRequests.h"

@implementation ImageDownloader

- (void)downloadImageForUrl:(NSURL *)url collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo
{
    NetworkFactoryRequests * factoryRequest = [[NetworkFactoryRequests alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak typeof (self) weakSelf = self;
    
    [factoryRequest sendAsynchronousRequest:request completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        
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
