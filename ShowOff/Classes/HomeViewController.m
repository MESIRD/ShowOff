//
//  HomeViewController.m
//  ShowOff
//
//  Created by xujie on 15/6/19.
//  Copyright (c) 2015年 mesird. All rights reserved.
//

#import "HomeViewController.h"
#import "FlatUIKit.h"
#import "MJRefresh.h"
#import "MeViewController.h"
#import "Universal.h"


typedef NS_ENUM(NSInteger, PageName) {
    HOTTEST_PAGE = 1,
    NEWEST_PAGE,
};

@interface HomeViewController ()
{
    PageName currentPageName;
}



@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set navigation bar color
    [self.navigationController.navigationBar configureFlatNavigationBarWithColor:[UIColor midnightBlueColor]];
    
    //set tab bar frame
    self.tabBarController.tabBar.frame = CGRectMake(0, self.tabBarController.tabBar.frame.origin.y + 15, SCREEN_WIDTH, 34);
    
    //set tab bar shadow color
    self.tabBarController.tabBar.shadowImage = [UIImage imageNamed:@"transparency"];
    
    //set tab bar item images to original color
    UITabBarItem *homeItem = [self.tabBarController.tabBar.items objectAtIndex:0];
    homeItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.selectedImage = [[UIImage imageNamed:@"home_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *meItem = [self.tabBarController.tabBar.items objectAtIndex:1];
    meItem.image = [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    meItem.selectedImage = [[UIImage imageNamed:@"me_highlighted"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    //add segmentedControl
    FUISegmentedControl *segmentedControl = [[FUISegmentedControl alloc] initWithItems:@[@"热门", @"最新"]];
    
    segmentedControl.selectedFont = [UIFont boldFlatFontOfSize:12];
    segmentedControl.deselectedFont = [UIFont boldFlatFontOfSize:12];
    segmentedControl.selectedColor = [UIColor turquoiseColor];
    segmentedControl.highlightedColor = [UIColor turquoiseColor];
    segmentedControl.deselectedColor = [UIColor clearColor];
    segmentedControl.dividerColor = [UIColor turquoiseColor];
    segmentedControl.cornerRadius = 5.0;
    segmentedControl.frame = CGRectMake(segmentedControl.frame.origin.x, segmentedControl.frame.origin.y, 100, 30);
    segmentedControl.borderWidth = 1.0f;
    segmentedControl.borderColor = [UIColor turquoiseColor];
    segmentedControl.selectedSegmentIndex = 0;
    
    [segmentedControl addTarget:self action:@selector(exchangeHomePage) forControlEvents:UIControlEventValueChanged];
    [self.navigationItem setTitleView:segmentedControl];
    
    //add 'add' button item
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addNewPost)];
    [addButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldFlatFontOfSize:12], NSForegroundColorAttributeName: [UIColor cloudsColor]} forState:UIControlStateNormal];
    [self.navigationItem setRightBarButtonItem:addButton];
    
    //configure table header & footer
    _hottestTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(hottestHeaderRefresh)];
    _hottestTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(hottestFooterRefresh)];
    
    _newestTableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(newestHeaderRefresh)];
    _newestTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(newestFooterRefresh)];
    
    //hide one table view
    currentPageName = HOTTEST_PAGE;
    [_newestTableView setHidden:YES];

}

- (void)exchangeHomePage {
    
    switch (currentPageName) {
        case HOTTEST_PAGE:
            [_hottestTableView setHidden:YES];
            [_newestTableView setHidden:NO];
            currentPageName = NEWEST_PAGE;
            break;
        case NEWEST_PAGE:
            [_hottestTableView setHidden:NO];
            [_newestTableView setHidden:YES];
            currentPageName = HOTTEST_PAGE;
        default:
            break;
    }
}

- (void)addNewPost {
    
    
}

- (void)hottestHeaderRefresh {
    
    [_hottestTableView.header endRefreshing];
}

- (void)hottestFooterRefresh {
    
    [_hottestTableView.footer endRefreshing];
}

- (void)newestHeaderRefresh {
    
    
}

- (void)newestFooterRefresh {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
