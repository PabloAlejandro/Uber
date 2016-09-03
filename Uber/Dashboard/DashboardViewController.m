//
//  DashboardViewController.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "DashboardViewController.h"
#import "HistoryViewController.h"
#import "DashboardCollectionController.h"
#import "JsonRequestRetry.h"
#import "Photos.h"
#import "Photo.h"

#import "PhotoCollectionCell.h"
#import "Photo+URL.h"
#import "NSUserDefaults+History.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSInteger const perpage = 50;
static NSString * const baseURL = @"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=3e7cc266ae2b0e0d78e279ce8e361736&per_page=%lu&page=%lu&format=json&nojsoncallback=1&safe_search=1&text=%@";
static NSString * const kHistorySegue = @"HistorySegue";

@interface DashboardViewController () <UISearchBarDelegate, HistoryDelegate>

@property (nonatomic, weak) IBOutlet UISearchBar * searchBar;
@property (nonatomic, strong) JsonRequestRetry * jsonRequestRetry;
@property (nonatomic, assign) BOOL downloading;

@end

@implementation DashboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Flickr Search";
}

- (void)searchForPage:(NSInteger)page string:(NSString *)string
{
    if(self.downloading) {return;}
    
    self.downloading = YES;
    
    NSCharacterSet * characterSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString * urlStr = [[NSString stringWithFormat:baseURL, perpage, page, string] stringByAddingPercentEncodingWithAllowedCharacters:characterSet];
    
    NSURL * url = [NSURL URLWithString:urlStr];
    
    __weak typeof (self) weakSelf = self;
    [self.jsonRequestRetry retrieveDataForUrl:url completionBlock:^(id result, NSDictionary *userInfo) {
        
        // Note this is running on the main thread, since the completion block was called from it
        if([result isKindOfClass:[NSDictionary class]]) {
            
            __strong typeof (self) strongSelf = weakSelf;
            
            NSDictionary * photosDict = (NSDictionary *)[result objectForKey:@"photos"];
            
            // If it's a pagination request we just add the new results to the current Photo object, otherwise create a new object
            strongSelf.photos = page > 0 && strongSelf.photos != nil ? strongSelf.photos : [Photos new];
            strongSelf.photos.page = [[photosDict objectForKey:@"page"] integerValue];
            strongSelf.photos.pages = [[photosDict objectForKey:@"pages"] integerValue];
            strongSelf.photos.perpage = [[photosDict objectForKey:@"perpage"] integerValue];
            strongSelf.photos.total = [[photosDict objectForKey:@"total"] integerValue];
            strongSelf.photos.search = string;
            
            for(NSDictionary * photoDict in [photosDict objectForKey:@"photo"]) {
                
                Photo * photo = [Photo new];
                photo.farm = [[photoDict objectForKey:@"farm"] integerValue];
                photo.id_photo = [photoDict objectForKey:@"id"];
                photo.isfamily = [[photoDict objectForKey:@"isfamily"] boolValue];
                photo.isfriend = [[photoDict objectForKey:@"isfriend"] boolValue];
                photo.ispublic = [[photoDict objectForKey:@"ispublic"] boolValue];
                photo.owner = [photoDict objectForKey:@"owner"];
                photo.secret = [photoDict objectForKey:@"secret"];
                photo.server = [photoDict objectForKey:@"server"];
                photo.title = [photoDict objectForKey:@"title"];
                
                [strongSelf.photos.photos addObject:photo];
            }
            
            if(page == 0) {
                // If it's a new search we want to go to top
                [strongSelf.collectionView scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(strongSelf.collectionView.frame), CGRectGetHeight(strongSelf.collectionView.frame)) animated:NO];
            }
            strongSelf.photos = strongSelf.photos;
            [strongSelf.collectionView reloadData];
            strongSelf.downloading = NO;
            
            // TODO: if strongSelf.photos.photos.count == 0 then show message saying we couldn't find any photo
            // Note: this is not implemented since the task description remarks not to implement anything that is not asked.
        }
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (NSString *)collectionViewCellIdentifierAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * kMyIdentifier = @"PhotoCollectionCell";
    return kMyIdentifier;
}

- (void)configureCollectionViewCell:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    Photo * photo = self.photos.photos[indexPath.row];
    cell.backgroundColor = [UIColor colorWithWhite:.2 alpha:.35];
    [((PhotoCollectionCell *)cell).customImageView sd_setImageWithURL:[photo url]];
}

- (void)collectionViewShouldLoadMore {
    [self searchForPage:self.photos.page+1 string:self.photos.search];
}

#pragma mark - HistoryDelegate

- (void)historyDidSelectSearch:(NSString *)search {
    [[NSUserDefaults standardUserDefaults] addSearchToHistory:search];
    [self searchForPage:0 string:search];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [[NSUserDefaults standardUserDefaults] addSearchToHistory:searchBar.text];
    [self searchForPage:0 string:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
}

- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    if([searchBar isFirstResponder]) {
        [searchBar resignFirstResponder];
    }
    [self performSegueWithIdentifier:kHistorySegue sender:self];
}

#pragma mark - Getters

- (JsonRequestRetry *)jsonRequestRetry
{
    if(!_jsonRequestRetry) {
        _jsonRequestRetry = [JsonRequestRetry new];
    }
    return _jsonRequestRetry;
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
