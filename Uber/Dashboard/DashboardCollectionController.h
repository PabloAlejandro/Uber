//
//  DashboardCollectionController.h
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class Photos, Photo;

@interface DashboardCollectionController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

- (NSString *)collectionViewCellIdentifierAtIndexPath:(NSIndexPath *)indexPath;
- (void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath;
- (void)collectionViewShouldLoadMore;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) Photos * photos;

@end
