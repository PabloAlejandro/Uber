//
//  PaginationCollectionViewController.m
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 17/08/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "PaginationCollectionViewController.h"

@implementation PaginationCollectionViewController

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == [collectionView numberOfSections] - 1 && indexPath.row == [collectionView numberOfItemsInSection:indexPath.section] - 1) {
        if([self respondsToSelector:@selector(loadMore)]) {
            [self loadMore];
        }
    }
}

@end
