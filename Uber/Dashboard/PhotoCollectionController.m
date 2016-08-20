//
//  PhotoCollectionController.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "PhotoCollectionController.h"
#import "PhotoCollectionCell.h"
#import "Photo+URL.h"
#import "Photos.h"
#import "NSUserDefaults+History.h"
#import "ImageDownloader.h"
#import "CustomCache.h"

@interface PhotoCollectionController () <ImageDownloaderDelegate>

@property (nonatomic, strong) ImageDownloader * imageDownloader;

@end

@implementation PhotoCollectionController

@synthesize photos = _photos;

- (UICollectionViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView photo:(Photo *)photo
{
    static NSString * kMyIdentifier = @"PhotoCollectionCell";
    PhotoCollectionCell *cell = (PhotoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kMyIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:.2 alpha:.35];
    
    UIImage * cached_image = [CustomCache cachedImageForUrl:photo.url];
    
    NSLog(@"cached_image -> %@", cached_image);
    
    if(cached_image) {
        cell.customImageView.image = cached_image;
    } else {
        cell.customImageView.image = nil;   // We can show a "loading image" here
        NSDictionary * user_info = @{@"id_photo" : photo.id_photo};
        [self.imageDownloader downloadImageForUrl:[photo url] collectionView:collectionView indexPath:indexPath userInfo:user_info];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.photos.photos.count ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photos.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellAtIndexPath:indexPath
                  collectionView:collectionView
                           photo:[self.photos.photos objectAtIndex:indexPath.row]];
}

#pragma mark - ImageDownloaderDelegate

- (void)imageDidDownload:(UIImage *)image collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;
{
    NSArray <Photo * > * photos = self.photos.photos;
    
    if(indexPath.row >= photos.count) {return;}
    
    Photo * photo = [photos objectAtIndex:indexPath.row];
    
    if(photo == nil) {return;}
    
    // If the image is from the previous search we return
    NSString * id_photo = [userInfo objectForKey:@"id_photo"];
    if(![photo.id_photo isEqualToString:id_photo]) {return;}
    
    // We cache the image
    [CustomCache cacheImage:image forUrl:photo.url];
    
    if([[collectionView indexPathsForVisibleItems] containsObject:indexPath]) {
        PhotoCollectionCell *cell = (PhotoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.customImageView.image = image;
    }
}

- (void)imageDidFailDownload:(NSError *)error collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath userInfo:(NSDictionary *)userInfo;
{
    // TODO: Handle error (ie. alert view message, etc.)
}

#pragma mark - Getters

- (ImageDownloader *)imageDownloader
{
    if(!_imageDownloader) {
        _imageDownloader = [ImageDownloader new];
        _imageDownloader.delegate = self;
    }
    return _imageDownloader;
}

- (Photos *)photos
{
    @synchronized (self) {
        return _photos;
    }
}

@end
