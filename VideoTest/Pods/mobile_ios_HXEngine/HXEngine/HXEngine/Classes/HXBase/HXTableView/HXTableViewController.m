//
//  HXTableViewController.m
//  newHfax
//
//  Created by lly on 2017/7/2.
//  Copyright © 2017年 hfax. All rights reserved.
//

#import "HXTableViewController.h"
#import "HXTableViewDataSource.h"
#import "HXRefreshFooter.h"
#import "HXRefreshHeader.h"
#import "HXUIDefines.h"
#import "UIView+BFExtension.h"

@interface HXTableViewController ()
{
    BOOL _hasInitRefresh;
//    UITableViewStyle _tableViewStyle;

}

@end

@implementation HXTableViewController

- (id)init {
    self = [super init];
    if (self) {
        _tableViewStyle = UITableViewStyleGrouped;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor phc_lightGray];
    [self.view addSubview:self.tableView];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(!_hasInitRefresh){
        _hasInitRefresh = true;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  0.000001f;
}

#pragma mark - property

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, self.view.height) style:_tableViewStyle];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor phc_lightGray];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - refresh
- (void)initRefreshWithType:(HXRefreshType)refreshType{
    [self initRefreshWithType:refreshType WithUseNewTypeHeader:NO];
}

- (void)initRefreshWithType:(HXRefreshType)refreshType WithUseNewTypeHeader:(BOOL)useNewTypeHeader{
    _refreshType = refreshType;
    if(self.refreshType==HXRefreshTypeOnlyHeader||self.refreshType==HXRefreshTypeHeaderFooter){
        HXRefreshHeader *refreshHeader = [HXRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(onHeaderRefresh)];
        refreshHeader.isNewRefreshHeaderType = useNewTypeHeader;
        self.tableView.mj_header = refreshHeader;
    }
    if(self.refreshType==HXRefreshTypeOnlyFooter||self.refreshType==HXRefreshTypeHeaderFooter){
        self.tableView.mj_footer = [HXRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(onFooterLoadMore)];
    }
}

- (void)onHeaderRefresh{
    
}

- (void)onFooterLoadMore{
    
}

- (void)endHeaderFooterRefresh{
    [self endHeaderRefresh];
    [self endFooterRefresh];
}


- (void)endHeaderRefresh{
    HXRefreshHeader *headerView = self.tableView.mj_header;
    [headerView endHeaderRefresh];
}

- (void)endFooterRefresh{
    [self.tableView.mj_footer endRefreshing];
}

- (void)footerNoMoreData{
    [self.tableView.mj_footer endRefreshingWithNoMoreData];

}

@end
