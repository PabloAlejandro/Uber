//
//  UCollectionViewController.m
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 17/08/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "UCollectionViewController.h"

static CGFloat const leftPadding = 10.0f;
static CGFloat const rightPadding = 10.0f;
static CGFloat const topPadding = 10.0f;
static CGFloat const bottomPadding = 10.0f;
//static NSTimeInterval const columns = 3;

@interface UCollectionViewController ()

@end

@implementation UCollectionViewController

#pragma mark - View Controller

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.entries.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // Override this method
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat padding = (leftPadding + rightPadding) / 2;
    return CGSizeMake((CGRectGetWidth(collectionView.frame) - padding * self.columns * 2) / self.columns, (CGRectGetWidth(collectionView.frame) - padding * self.columns * 2) / self.columns);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(topPadding, leftPadding, bottomPadding, rightPadding);
}

#pragma mark - Getters

- (NSUInteger)columns
{
    if(_columns == 0) {
        _columns = 3;
    }
    return _columns;
}

@end
