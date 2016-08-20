//
//  DashboardViewController.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "DashboardViewController.h"
#import "HistoryViewController.h"
#import "PhotosRequest.h"
#import "NSUserDefaults+History.h"
#import "Photos.h"
#import "Photo.h"

static NSInteger const perpage = 50;
static NSString * const baseURL = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&per_page=%lu&page=%lu&format=json&nojsoncallback=1&safe_search=1&text=%@";
static NSString * const kHistorySegue = @"HistorySegue";

@interface DashboardViewController () <UISearchBarDelegate, HistoryDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar * searchBar;
@property (nonatomic, strong) PhotosRequest * photosRequest;
@property (nonatomic, strong) NSURLSessionDataTask * downloadTask;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Flickr Search";
}

- (void)searchForPage:(NSInteger)page string:(NSString *)string
{
    [self. downloadTask cancel];
    
    NSCharacterSet * characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString * urlStr = [[NSString stringWithFormat:baseURL, perpage, page, string] stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    __weak typeof (self) weakSelf = self;
    self. downloadTask = [self.photosRequest retrieveDataForUrl:url completionBlock:^(Photos * photos, NSDictionary *userInfo) {
    
        __strong typeof (self) strongSelf = weakSelf;
        
        if(page == 0) {
            
            strongSelf.photos = photos;
            
            // If it's a new search we want to go to top
            [strongSelf.collectionView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(strongSelf.collectionView.frame), CGRectGetHeight(strongSelf.collectionView.frame)) animated:NO];
        }
        else {
            
            // If it's a pagination search we add the retrieved photos to our photos object
            [strongSelf.photos.photos addObjectsFromArray:photos.photos];
        }
        
        [strongSelf.collectionView reloadData];
    }];
}


#pragma mark - HistoryDelegate

- (void)historyDidSelectSearch:(NSString *)search
{
    [[NSUserDefaults standardUserDefaults] addSearchToHistory:search];
    [self searchForPage:0 string:search];
}

#pragma mark - PaginationCollectionProtocol

- (void)loadMore
{
    if(self.photos.page < self.photos.pages) {
        [self searchForPage:self.photos.page+1 string:self.photos.search];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] addSearchToHistory:searchBar.text];
    [self searchForPage:0 string:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
    [self performSegueWithIdentifier:kHistorySegue sender:self];
}

#pragma mark - Getters

- (PhotosRequest *)photosRequest
{
    if(!_photosRequest) {
        _photosRequest = [PhotosRequest new];
    }
    return _photosRequest;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:kHistorySegue]) {
        HistoryViewController * history = [segue destinationViewController];
        history.delegate = self;
    }
}

@end
