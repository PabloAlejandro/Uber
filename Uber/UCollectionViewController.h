//
//  UCollectionViewController.h
//  Uber
//
//  Created by Pablo Alejandro Perez Martinez on 17/08/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JsonRequestRetry.h"

@interface UCollectionViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) IBOutlet UICollectionView * collectionView;
@property (nonatomic, copy) NSArray * entries;
@property (nonatomic, assign) NSUInteger columns;

@end
