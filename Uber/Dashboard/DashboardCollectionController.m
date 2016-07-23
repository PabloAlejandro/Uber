//
//  DashboardCollectionController.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "DashboardCollectionController.h"
#import "PhotoCollectionCell.h"
#import "Photo+URL.h"
#import "Photos.h"
#import "NSUserDefaults+History.h"
#import "ImageDownloader.h"

static CGFloat const leftPadding = 10.0f;
static CGFloat const rightPadding = 10.0f;
static CGFloat const topPadding = 10.0f;
static CGFloat const bottomPadding = 10.0f;
static NSTimeInterval const columns = 3;

@interface DashboardCollectionController () <ImageDownloaderDelegate>

@property (nonatomic, strong) ImageDownloader * imageDownloader;
@property (nonatomic, strong) NSMutableDictionary * cached_images;  // We cache images for this session (we could have a persistent caching class)

@end

@implementation DashboardCollectionController

- (UICollectionViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath collectionView:(UICollectionView *)collectionView photo:(Photo *)photo
{
    static NSString * kMyIdentifier = @"PhotoCollectionCell";
    PhotoCollectionCell *cell = (PhotoCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kMyIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithWhite:.2 alpha:.35];
    
    UIImage * cached_image = [self.cached_images objectForKey:photo.id_photo];
    if(cached_image) {
        cell.customImageView.image = cached_image;
    }
    else {
        cell.customImageView.image = nil;   // We can show a "loading image" here
        [self.imageDownloader downloadImageForUrl:[photo url] collectionView:collectionView indexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.photos.photos.count ? 1 : 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.photos.photos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self cellAtIndexPath:indexPath collectionView:collectionView photo:[self.photos.photos objectAtIndex:indexPath.row]];
}

// TODO: We could have an UICollectionReusableView as section footer with an UIActivityIndicatorView to let the user
// know there is a request going on.
// Note: this is not implemented since the task description remarks not to implement anything that is not asked.

#pragma mark - UITableViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(collectionView:didSelectPhoto:atIndexPath:)]) {
        [self.delegate collectionView:collectionView didSelectPhoto:[self.photos.photos objectAtIndex:indexPath.row] atIndexPath:indexPath];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat padding = (leftPadding + rightPadding) / 2;
    return CGSizeMake((CGRectGetWidth(collectionView.frame) - padding * columns * 2) / columns, (CGRectGetWidth(collectionView.frame) - padding * columns * 2) / columns);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if([self.delegate respondsToSelector:@selector(collectionViewWillScroll:)]) {
        [self.delegate collectionViewWillScroll:self.collectionView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        // we are at the end
        if([self.delegate respondsToSelector:@selector(collectionViewDidScrollToBottom:)]) {
            [self.delegate collectionViewDidScrollToBottom:self.collectionView];
        }
    }
}

#pragma mark - ImageDownloaderDelegate

- (void)imageDidDownload:(UIImage *)image collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
{
    Photo * photo = [self.photos.photos objectAtIndex:indexPath.row];
    
    [self.cached_images setObject:image forKey:photo.id_photo];
    
    if([[collectionView indexPathsForVisibleItems] containsObject:indexPath]) {
        PhotoCollectionCell *cell = (PhotoCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
        cell.customImageView.image = image;
    }
}

- (void)imageDidFailDownload:(NSError *)error collectionView:(UICollectionView *)collectionView forIndexPath:(NSIndexPath *)indexPath
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

- (NSMutableDictionary *)cached_images
{
    if(!_cached_images) {
        _cached_images = [NSMutableDictionary new];
    }
    return _cached_images;
}

@end
