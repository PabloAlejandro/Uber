//
//  HistoryViewController.m
//  Uber
//
//  Created by Pau (Personal) on 23/07/2016.
//  Copyright © 2016 Uber. All rights reserved.
//

#import "HistoryViewController.h"
#import "NSUserDefaults+History.h"

@interface HistoryViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray * entries;

@end

@implementation HistoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"History";
    self.entries = [[[[NSUserDefaults standardUserDefaults] retrieveSearchHistory] reverseObjectEnumerator] allObjects];
}

#pragma mark - Private

- (void)clearHistoryInternal
{
    [[NSUserDefaults standardUserDefaults] clearHistory];
    self.entries = nil;
    [self.tableView reloadData];
}

#pragma mark - IBAction

- (IBAction)clearHistory:(id)sender
{
    [self clearHistoryInternal];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [self.entries objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(historyDidSelectSearch:)]) {
        [self.delegate historyDidSelectSearch:[self.entries objectAtIndex:indexPath.row]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
