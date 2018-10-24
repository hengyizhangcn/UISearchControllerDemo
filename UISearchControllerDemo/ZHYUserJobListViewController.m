//
//  ZHYUserJobListViewController.m
//  TownForRemain
//
//  Created by zhy on 17/05/2017.
//  Copyright © 2017 ZHY. All rights reserved.
//

//problem demo
//describe: https://stackoverflow.com/questions/52960606/uitableview-uisearchcontroller-and-mjrefresh-vertical-scroll-indicator-flash-f

#import "ZHYUserJobListViewController.h"
#import "MJRefresh.h"

#define kIdentifier @"UITableViewCell"

static inline BOOL isIPhoneX() {
    
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneX;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    
    return iPhoneX;
}


@interface ZHYUserJobListViewController () <UISearchResultsUpdating, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
/**
 */
@property (nonatomic) NSArray *dataMArray;

/**
 */
@property (nonatomic) UISearchController *searchController;

@end

@implementation ZHYUserJobListViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Job List";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kIdentifier];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestFirstPage];
    }];
    if (@available(iOS 11.0, *)) {
        if (isIPhoneX()) {
            self.tableView.insetsContentViewsToSafeArea = NO;
            self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
            self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = isIPhoneX() ? 34 : 0;
        }
    } else {
        self.extendedLayoutIncludesOpaqueBars = YES;
    }
    
    self.definesPresentationContext = YES;
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.dataMArray.count == 0) {
        [self.tableView.mj_header beginRefreshing];
    }
}

#pragma mark - Network request
- (void)requestFirstPage
{
    //network request skipped
    
    [self.tableView.mj_header endRefreshing];
    
    //iphoneSE 10.3.1 mock data, the phenomenon appears whenever pulling down
//    self.dataMArray = @[@1, @2, @3, @4, @5];
    
    //iphone7 plus / iphone6s plus / iphone6 plus simulator mock data, the phenomenon appears when first enter
//    self.dataMArray = @[@1, @2, @3, @4, @5, @5, @5];
    
    //iphone7 / iphone6s / iphone6s simulator mock data, the phenomenon appears whenever pulling down
        self.dataMArray = @[@1, @2, @3, @4, @5, @5];
    
    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = self.searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = YES;
    }else if (!self.tableView.tableHeaderView) {
        self.tableView.tableHeaderView = self.searchController.searchBar;
    }
    [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate/UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataMArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UISearchResultsUpdating


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
}
- (void)resetTableViewDataSource{
}
#pragma mark - UISearchControllerDelegate

#pragma mark - UISearbarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
}

#pragma mark - Access Methods

- (UISearchController *)searchController
{
    if (!_searchController) {
        ZHYUserJobListViewController *jobListVC = [[ZHYUserJobListViewController alloc] init];
        _searchController = [[UISearchController alloc] initWithSearchResultsController:jobListVC];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
        _searchController.searchBar.placeholder = @"placeholder";
        [_searchController.searchBar sizeToFit];
    }
    return _searchController;
}
@end
