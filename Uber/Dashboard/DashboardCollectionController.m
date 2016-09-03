//
//  DashboardCollectionController.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "DashboardCollectionController.h"
#import "Photos.h"

static CGFloat const leftPadding = 10.0f;
static CGFloat const rightPadding = 10.0f;
static CGFloat const topPadding = 10.0f;
static CGFloat const bottomPadding = 10.0f;
static NSTimeInterval const columns = 3;

@interface DashboardCollectionController ()

@end

@implementation DashboardCollectionController

- (NSString *)collectionViewCellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    // Override this method
    assert(0);
}

- (void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    // Override this method
}

- (void)collectionViewShouldLoadMore {
    // Override this method
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

#pragma mark - UITableViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        [self collectionViewShouldLoadMore];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self collectionViewCellIdentifierAtIndexPath:indexPath] forIndexPath:indexPath];
    [self configureCollectionViewCell:cell indexPath:indexPath];
    return cell;
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

#pragma mark - Getters

- (Photos *)photos
{
    @synchronized (self) {
        return _photos;
    }
}

@end
