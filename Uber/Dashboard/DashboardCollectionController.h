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

@protocol DashboardCollectionDelegate <NSObject>

@optional
- (void)collectionView:(UICollectionView *)collectionView didSelectPhoto:(Photo *)photo atIndexPath:(NSIndexPath *)indexPath;
- (void)collectionViewWillScroll:(UICollectionView *)collectionView;
- (void)collectionViewDidScrollToBottom:(UICollectionView *)collectionView;

@end

@interface DashboardCollectionController : NSObject <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet id <DashboardCollectionDelegate> delegate;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) Photos * photos;

@end
