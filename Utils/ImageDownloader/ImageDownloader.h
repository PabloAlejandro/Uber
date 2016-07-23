//
//  ImageDownloader.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol ImageDownloaderDelegate <NSObject>

- (void)imageDidDownload:(UIImage *)image collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;;
- (void)imageDidFailDownload:(NSError *)error collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;;

@end

@interface ImageDownloader : NSObject

@property (nonatomic, weak) id <ImageDownloaderDelegate> delegate;

- (void)downloadImageForUrl:(NSURL *)url collectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;

@end
